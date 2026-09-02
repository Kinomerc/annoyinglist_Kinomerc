// ==UserScript==
// @name         CHZZK 통나무 파워 자동 수령
// @namespace    chzzk-log-power
// @version      1.0.0
// @description  통나무 파워 자동 수령 + 라이브 상태 확인 + 재생 상태 추적 + SPA/BFCache 대응
// @match        https://chzzk.naver.com/*
// @grant        none
// @run-at       document-start
// ==/UserScript==

(function () {
  'use strict';

  if (window.top !== window.self) return;

  const BOOT_KEY = '__CHZZK_LOG_POWER_CORE_BOOT__';
  if (window[BOOT_KEY]) return;

  window[BOOT_KEY] = {
    version: '1.0.0',
    startedAt: Date.now(),
  };

  /* =========================================================
   * 설정
   * ======================================================= */

  const POWER_MESSAGE_RE =
    /1\s*시간\s*시청\s*통나무\s*파워\s*배달\s*완료/i;

  const POWER_ITEM_RE = /통나무\s*파워/i;
  const AMOUNT_RE = /([\d,]+)\s*(?:개\s*)?받기/i;
  const LIVE_ROUTE_RE = /^\/live\/([^/?#]+)/i;

  const RETRY_COOLDOWN_MS = 10_000;
  const CLAIM_SETTLE_MS = 120;
  const HEARTBEAT_MS = 5_000;

  const LIVE_STATUS_REFRESH_MS = 60_000;
  const API_TIMEOUT_MS = 5_000;

  const LIVE_STATUS_UNKNOWN_GRACE_MS = 90_000;

  const PLAYBACK_TRANSITION_GRACE_MS = 3_000;
  const PLAYBACK_TRANSIENT_GRACE_MS = 90_000;

  const PAUSE_CONFIRM_MS = 150;
  const MODE_TOGGLE_SIGNAL_MS = 1_500;

  const PAGE_READINESS_WARMUP_DELAYS_MS = [
    0,
    150,
    400,
    900,
    1_600,
    3_000,
    5_000,
    8_000,
  ];

  /* =========================================================
   * 상태
   * ======================================================= */

  const lastAttemptAt = new WeakMap();
  const lastCandidateObservationAt = new WeakMap();
  const pendingClaims = new WeakMap();
  const observedVideos = new WeakSet();

  let observedVideo = null;
  let lastPathname = location.pathname;

  let refreshQueued = false;

  let playbackLossAt = 0;
  let playbackLossGraceMs = 0;
  let playbackGraceKind = '';
  let playbackGraceTimer = 0;

  let pendingPauseTimer = 0;
  let pendingPauseVideo = null;

  let lastPlayerModeToggleAt = 0;

  let initialSyncWarmupTimers = [];
  let pageReadinessWarmupTimers = [];

  let runtimeDisposed = false;

  let pageLifecycleState = 'active';
  let pageHideCount = 0;
  let pageShowCount = 0;
  let bfcacheResumeCount = 0;
  let lastPageHidePersisted = false;

  let liveStatus = {
    channelId: '',
    status: 'UNKNOWN',
    checkedAt: 0,
    inFlight: false,
    lastConfirmedOpenAt: 0,
    unknownSinceAt: 0,
    outcome: 'initial',
    httpStatus: 0,
  };

  let watchSession = {
    channelId: '',
    accumulatedMs: 0,
    runningSince: 0,
  };

  let localState = {
    channelId: '',
    eligible: false,
    loginRequired: false,
    playing: false,
    rawPlaying: false,
    playSessionStartedAt: 0,
    farmingSessionStartedAt: 0,
    lastRawPlayingAt: 0,
    updatedAt: Date.now(),
    reason: 'initial',
  };

  /* =========================================================
   * 공통
   * ======================================================= */

  function getLiveChannelId() {
    return location.pathname.match(LIVE_ROUTE_RE)?.[1] || '';
  }

  function normalizedText(element) {
    return (element?.textContent || '')
      .replace(/\s+/g, ' ')
      .trim();
  }

  function isVisible(element) {
    if (
      !(element instanceof HTMLElement) ||
      !element.isConnected ||
      element.hidden ||
      element.getAttribute('aria-hidden') === 'true' ||
      element.closest('[hidden], [aria-hidden="true"]')
    ) {
      return false;
    }

    const style = getComputedStyle(element);

    if (
      style.display === 'none' ||
      style.visibility === 'hidden' ||
      style.visibility === 'collapse' ||
      Number(style.opacity) === 0
    ) {
      return false;
    }

    return (
      element.getClientRects().length > 0
    );
  }

  /* =========================================================
   * 로그인 상태 확인
   * ======================================================= */

  function isLoginControl(element) {
    if (!(element instanceof HTMLElement)) return false;

    const text = normalizedText(element);
    const ariaLabel =
      element.getAttribute('aria-label') || '';

    const href =
      element instanceof HTMLAnchorElement
        ? element.href
        : '';

    const pointsToNaverLogin =
      !!href &&
      (() => {
        try {
          const url = new URL(href);

          return (
            url.hostname.endsWith('nid.naver.com') &&
            /login/i.test(
              url.pathname + url.search,
            )
          );
        } catch {
          return false;
        }
      })();

    return (
      (
        element.matches(
          'button, a, [role="button"]',
        ) &&
        (
          text === '로그인' ||
          ariaLabel === '로그인'
        )
      ) ||
      pointsToNaverLogin
    );
  }

  function isLoginRequired() {
    return [
      ...document.querySelectorAll(
        'button, a[href*="nid.naver.com"], a[href*="login"], [role="button"]',
      ),
    ].some(
      (element) =>
        isLoginControl(element) &&
        isVisible(element),
    );
  }

  /* =========================================================
   * 라이브 비디오
   * ======================================================= */

  function findLiveVideo() {
    if (!getLiveChannelId()) return null;

    const liveRoot =
      document.querySelector(
        '#live_player_layout, ' +
          '[id^="live_player_layout"], ' +
          '[id*="live_player_layout"]',
      );

    const rootedVideo =
      liveRoot?.querySelector(
        'video.webplayer-internal-video, video',
      );

    if (
      rootedVideo instanceof HTMLVideoElement
    ) {
      return rootedVideo;
    }

    const fallback =
      document.querySelector(
        '.chzzk_player video.webplayer-internal-video, ' +
          '.pzp video.webplayer-internal-video',
      );

    if (
      fallback instanceof HTMLVideoElement &&
      !fallback.closest(
        '#vod_player_layout, #video_player_layout',
      )
    ) {
      return fallback;
    }

    return null;
  }

  function hasPlaybackStarted(video) {
    return !!(
      video instanceof HTMLVideoElement &&
      !video.paused &&
      !video.ended &&
      (
        video.readyState >=
          HTMLMediaElement.HAVE_CURRENT_DATA ||
        video.currentTime > 0
      )
    );
  }

  /* =========================================================
   * 라이브 상태 API
   * ======================================================= */

  async function refreshLiveStatus(force = false) {
    const channelId = getLiveChannelId();

    if (!channelId) {
      liveStatus = {
        channelId: '',
        status: 'UNKNOWN',
        checkedAt: 0,
        inFlight: false,
        lastConfirmedOpenAt: 0,
        unknownSinceAt: 0,
        outcome: 'left-live-route',
        httpStatus: 0,
      };

      refreshLocalPlaybackState(
        'live-status-left-route',
      );

      return;
    }

    const now = Date.now();

    if (
      liveStatus.inFlight ||
      (
        !force &&
        liveStatus.channelId === channelId &&
        now - liveStatus.checkedAt <
          LIVE_STATUS_REFRESH_MS
      )
    ) {
      return;
    }

    const previous = {
      ...liveStatus,
    };

    const sameChannel =
      previous.channelId === channelId;

    liveStatus = {
      channelId,
      status: sameChannel
        ? previous.status
        : 'UNKNOWN',
      checkedAt: sameChannel
        ? previous.checkedAt
        : 0,
      inFlight: true,
      lastConfirmedOpenAt:
        sameChannel
          ? Number(
              previous.lastConfirmedOpenAt,
            ) || 0
          : 0,
      unknownSinceAt:
        sameChannel
          ? Number(
              previous.unknownSinceAt,
            ) || 0
          : 0,
      outcome:
        sameChannel
          ? previous.outcome || ''
          : 'channel-changed',
      httpStatus:
        sameChannel
          ? Number(
              previous.httpStatus,
            ) || 0
          : 0,
    };

    const controller =
      new AbortController();

    const timer =
      setTimeout(
        () => controller.abort(),
        API_TIMEOUT_MS,
      );

    try {
      const response =
        await fetch(
          `https://api.chzzk.naver.com/polling/v2/channels/${channelId}/live-status`,
          {
            signal:
              controller.signal,
            cache: 'no-store',
            credentials: 'include',
          },
        );

      let data = null;
      let outcome =
        response.ok
          ? 'invalid-payload'
          : 'http-error';

      if (response.ok) {
        try {
          data = await response.json();
        } catch {
          outcome = 'invalid-json';
        }
      }

      if (
        channelId !==
        getLiveChannelId()
      ) {
        return;
      }

      const reportedStatus =
        String(
          data?.content?.status ||
            '',
        )
          .trim()
          .toUpperCase();

      const status =
        reportedStatus || 'UNKNOWN';

      if (
        reportedStatus === 'OPEN'
      ) {
        outcome = 'open';
      } else if (
        reportedStatus
      ) {
        outcome = 'non-open';
      }

      const checkedAt =
        Date.now();

      const current =
        liveStatus.channelId ===
        channelId
          ? liveStatus
          : {};

      const lastConfirmedOpenAt =
        Math.max(
          Number(
            previous.lastConfirmedOpenAt,
          ) || 0,
          Number(
            current.lastConfirmedOpenAt,
          ) || 0,
        );

      const unknownSinceAt =
        current.status === 'UNKNOWN'
          ? Number(
              current.unknownSinceAt,
            ) || 0
          : 0;

      liveStatus = {
        channelId,
        status,
        checkedAt,
        inFlight: false,
        lastConfirmedOpenAt:
          status === 'OPEN'
            ? checkedAt
            : lastConfirmedOpenAt,
        unknownSinceAt:
          status === 'UNKNOWN'
            ? unknownSinceAt ||
              checkedAt
            : 0,
        outcome,
        httpStatus:
          Number(
            response.status,
          ) || 0,
      };
    } catch (error) {
      if (
        channelId !==
        getLiveChannelId()
      ) {
        return;
      }

      const checkedAt =
        Date.now();

      const current =
        liveStatus.channelId ===
        channelId
          ? liveStatus
          : {};

      const lastConfirmedOpenAt =
        Math.max(
          Number(
            previous.lastConfirmedOpenAt,
          ) || 0,
          Number(
            current.lastConfirmedOpenAt,
          ) || 0,
        );

      const unknownSinceAt =
        current.status === 'UNKNOWN'
          ? Number(
              current.unknownSinceAt,
            ) || 0
          : 0;

      liveStatus = {
        channelId,
        status: 'UNKNOWN',
        checkedAt,
        inFlight: false,
        lastConfirmedOpenAt,
        unknownSinceAt:
          unknownSinceAt ||
          checkedAt,
        outcome:
          error?.name === 'AbortError'
            ? 'timeout'
            : 'network-error',
        httpStatus: 0,
      };
    } finally {
      clearTimeout(timer);

      if (
        channelId ===
        getLiveChannelId()
      ) {
        liveStatus.inFlight = false;

        refreshLocalPlaybackState(
          'live-status-result',
        );
      }
    }
  }

  function getLiveStatusEligibility(
    channelId,
    now = Date.now(),
  ) {
    const sameChannel =
      !!channelId &&
      liveStatus.channelId ===
        channelId;

    const statusOpen =
      sameChannel &&
      liveStatus.status ===
        'OPEN';

    const unknownGraceRemainingMs =
      sameChannel &&
      liveStatus.status ===
        'UNKNOWN' &&
      liveStatus.lastConfirmedOpenAt &&
      liveStatus.unknownSinceAt
        ? LIVE_STATUS_UNKNOWN_GRACE_MS -
          (
            now -
            Number(
              liveStatus.unknownSinceAt,
            )
          )
        : 0;

    const usingUnknownGrace =
      unknownGraceRemainingMs > 0;

    return {
      eligible:
        statusOpen ||
        usingUnknownGrace,
      statusOpen,
      usingUnknownGrace,
      unknownGraceRemainingMs:
        usingUnknownGrace
          ? unknownGraceRemainingMs
          : 0,
    };
  }

  /* =========================================================
   * 시청 시간 / 재생 상태
   * ======================================================= */

  function updateWatchSession(
    channelId,
    playing,
    channelChanged,
  ) {
    const now = Date.now();

    if (
      channelChanged ||
      !channelId ||
      watchSession.channelId !==
        channelId
    ) {
      watchSession = {
        channelId,
        accumulatedMs: 0,
        runningSince: 0,
      };
    }

    if (
      playing &&
      !watchSession.runningSince
    ) {
      watchSession.runningSince =
        now;
    } else if (
      !playing &&
      watchSession.runningSince
    ) {
      watchSession.accumulatedMs +=
        now -
        watchSession.runningSince;

      watchSession.runningSince = 0;
    }
  }

  function getWatchElapsedMs() {
    return Math.max(
      0,
      watchSession.accumulatedMs +
        (
          watchSession.runningSince
            ? Date.now() -
              watchSession.runningSince
            : 0
        ),
    );
  }

  function isTransientPlaybackReason(
    reason,
  ) {
    const value =
      String(reason || '');

    return (
      value === 'heartbeat' ||
      value === 'initial' ||
      value ===
        'live-status-result' ||
      value ===
        'video:waiting' ||
      value ===
        'video:canplay' ||
      value ===
        'video:playing' ||
      value ===
        'video:loadeddata' ||
      value ===
        'video:stalled' ||
      value ===
        'video:suspend' ||
      value.startsWith(
        'page-readiness:',
      )
    );
  }

  function clearPlaybackGraceTimer() {
    if (
      playbackGraceTimer
    ) {
      clearTimeout(
        playbackGraceTimer,
      );
    }

    playbackGraceTimer = 0;
  }

  function schedulePlaybackGraceExpiry(
    delayMs,
  ) {
    clearPlaybackGraceTimer();

    playbackGraceTimer =
      setTimeout(
        () => {
          playbackGraceTimer = 0;

          refreshLocalPlaybackState(
            'playback-transition-grace-expired',
          );
        },
        Math.max(
          0,
          delayMs,
        ) + 20,
      );
  }

  function clearPendingPauseConfirmation() {
    if (
      pendingPauseTimer
    ) {
      clearTimeout(
        pendingPauseTimer,
      );
    }

    pendingPauseTimer = 0;
    pendingPauseVideo = null;
  }

  function schedulePauseConfirmation(
    video,
  ) {
    clearPendingPauseConfirmation();

    pendingPauseVideo = video;

    updateWatchSession(
      getLiveChannelId(),
      false,
      false,
    );

    pendingPauseTimer =
      setTimeout(
        () => {
          pendingPauseTimer = 0;

          const stillCurrentAndPaused =
            video.isConnected &&
            findLiveVideo() ===
              video &&
            (
              video.paused ||
              video.ended
            );

          const followsModeToggle =
            Date.now() -
              lastPlayerModeToggleAt <=
            MODE_TOGGLE_SIGNAL_MS;

          pendingPauseVideo =
            null;

          if (
            stillCurrentAndPaused &&
            !followsModeToggle
          ) {
            playbackLossAt = 0;
            clearPlaybackGraceTimer();

            refreshLocalPlaybackState(
              'video:pause-confirmed',
            );
          } else {
            refreshLocalPlaybackState(
              'video:pause-remount',
            );
          }
        },
        PAUSE_CONFIRM_MS,
      );
  }

  function handleVideoEvent(
    video,
    type,
  ) {
    if (type === 'pause') {
      schedulePauseConfirmation(
        video,
      );
      return;
    }

    if (
      (
        type === 'play' ||
        type === 'playing'
      ) &&
      pendingPauseVideo ===
        video
    ) {
      clearPendingPauseConfirmation();
    } else if (
      type === 'ended'
    ) {
      clearPendingPauseConfirmation();
    }

    refreshLocalPlaybackState(
      `video:${type}`,
    );
  }

  function attachVideoEvents(
    video,
  ) {
    if (
      !(
        video instanceof
        HTMLVideoElement
      ) ||
      observedVideos.has(video)
    ) {
      return;
    }

    observedVideos.add(video);

    for (
      const type of [
        'play',
        'playing',
        'pause',
        'ended',
        'loadeddata',
        'canplay',
        'emptied',
        'waiting',
        'stalled',
        'suspend',
      ]
    ) {
      video.addEventListener(
        type,
        () =>
          handleVideoEvent(
            video,
            type,
          ),
        {
          passive: true,
        },
      );
    }
  }

  function refreshLocalPlaybackState(
    reason = 'refresh',
  ) {
    const now = Date.now();

    const channelId =
      getLiveChannelId();

    const video =
      findLiveVideo();

    const statusEligibility =
      getLiveStatusEligibility(
        channelId,
        now,
      );

    const eligible =
      !!channelId &&
      statusEligibility.eligible;

    const loginRequired =
      eligible &&
      isLoginRequired();

    const rawPlaying =
      eligible &&
      !loginRequired &&
      video instanceof
        HTMLVideoElement &&
      hasPlaybackStarted(video);

    const channelChanged =
      channelId !==
      localState.channelId;

    const loginRequirementChanged =
      loginRequired !==
      !!localState.loginRequired;

    const previousVideo =
      observedVideo;

    const videoReplaced =
      previousVideo instanceof
        HTMLVideoElement &&
      video !== previousVideo;

    const transitionSignal =
      reason ===
        'dom-player-change' ||
      reason ===
        'video:emptied' ||
      reason ===
        'video:pause-remount' ||
      videoReplaced ||
      (!video &&
        localState.playing) ||
      (
        pendingPauseVideo &&
        pendingPauseVideo ===
          video
      );

    if (
      video &&
      video !== observedVideo
    ) {
      observedVideo = video;
      attachVideoEvents(video);
    } else if (!video) {
      observedVideo = null;
    }

    if (
      channelChanged ||
      !channelId ||
      !eligible ||
      loginRequired
    ) {
      clearPendingPauseConfirmation();

      playbackLossAt = 0;
      playbackLossGraceMs = 0;
      playbackGraceKind = '';

      clearPlaybackGraceTimer();
    } else if (rawPlaying) {
      playbackLossAt = 0;
      playbackLossGraceMs = 0;
      playbackGraceKind = '';

      clearPlaybackGraceTimer();
    } else {
      const canTreatAsTransient =
        video instanceof
          HTMLVideoElement &&
        !video.paused &&
        !video.ended &&
        isTransientPlaybackReason(
          reason,
        );

      const nextGraceMs =
        transitionSignal
          ? PLAYBACK_TRANSITION_GRACE_MS
          : canTreatAsTransient
            ? PLAYBACK_TRANSIENT_GRACE_MS
            : 0;

      const nextGraceKind =
        transitionSignal
          ? 'transition'
          : canTreatAsTransient
            ? 'transient'
            : '';

      if (
        localState.eligible &&
        localState.playing &&
        playbackLossAt &&
        nextGraceMs >
          playbackLossGraceMs
      ) {
        playbackLossGraceMs =
          nextGraceMs;

        playbackGraceKind =
          nextGraceKind;
      } else if (
        localState.eligible &&
        localState.playing &&
        !playbackLossAt &&
        nextGraceMs > 0
      ) {
        playbackLossAt = now;
        playbackLossGraceMs =
          nextGraceMs;
        playbackGraceKind =
          nextGraceKind;
      }
    }

    const graceRemaining =
      playbackLossAt > 0
        ? playbackLossGraceMs -
          (
            now -
            playbackLossAt
          )
        : 0;

    const usingTransitionGrace =
      !channelChanged &&
      !!channelId &&
      eligible &&
      !loginRequired &&
      localState.eligible &&
      !localState.loginRequired &&
      localState.playing &&
      !rawPlaying &&
      graceRemaining > 0;

    if (
      usingTransitionGrace
    ) {
      schedulePlaybackGraceExpiry(
        graceRemaining,
      );
    }

    const playing =
      rawPlaying ||
      usingTransitionGrace;

    updateWatchSession(
      channelId,
      rawPlaying,
      channelChanged ||
        loginRequirementChanged,
    );

    let playSessionStartedAt =
      Number(
        localState.playSessionStartedAt,
      ) || 0;

    let farmingSessionStartedAt =
      Number(
        localState.farmingSessionStartedAt,
      ) || 0;

    let lastRawPlayingAt =
      Number(
        localState.lastRawPlayingAt,
      ) || 0;

    if (
      channelChanged ||
      !eligible ||
      loginRequired
    ) {
      playSessionStartedAt = 0;
      farmingSessionStartedAt = 0;
      lastRawPlayingAt = 0;
    }

    if (
      eligible &&
      !rawPlaying &&
      !usingTransitionGrace
    ) {
      playSessionStartedAt = 0;
    } else if (
      rawPlaying &&
      !playSessionStartedAt
    ) {
      playSessionStartedAt = now;
    }

    if (
      rawPlaying &&
      !farmingSessionStartedAt
    ) {
      farmingSessionStartedAt =
        now;
    }

    if (rawPlaying) {
      lastRawPlayingAt = now;
    }

    localState = {
      channelId,
      eligible,
      loginRequired,
      playing,
      rawPlaying,
      playSessionStartedAt,
      farmingSessionStartedAt,
      lastRawPlayingAt,
      updatedAt: now,
      reason,

      usingTransitionGrace,
      playbackGraceKind:
        usingTransitionGrace
          ? playbackGraceKind
          : '',

      playbackGraceRemainingMs:
        usingTransitionGrace
          ? Math.max(
              0,
              graceRemaining,
            )
          : 0,

      liveStatusStatus:
        liveStatus.status ||
        'UNKNOWN',

      usingLiveStatusGrace:
        statusEligibility
          .usingUnknownGrace,

      liveStatusGraceRemainingMs:
        Math.max(
          0,
          Number(
            statusEligibility
              .unknownGraceRemainingMs,
          ) || 0,
        ),
    };
  }

  function schedulePlaybackRefresh(
    reason,
  ) {
    if (refreshQueued) return;

    refreshQueued = true;

    requestAnimationFrame(
      () => {
        refreshQueued = false;

        refreshLocalPlaybackState(
          reason,
        );
      },
    );
  }

  /* =========================================================
   * 통나무 파워 버튼 감지 / 자동 수령
   * ======================================================= */

  function isClaimControlText(
    text,
  ) {
    const normalized =
      String(text || '')
        .replace(/\s+/g, ' ')
        .trim();

    if (
      !AMOUNT_RE.test(
        normalized,
      )
    ) {
      return false;
    }

    return (
      POWER_MESSAGE_RE.test(
        normalized,
      ) ||
      POWER_ITEM_RE.test(
        normalized,
      )
    );
  }

  function isVisibleAndEnabled(
    element,
  ) {
    if (
      !(
        element instanceof
        HTMLElement
      ) ||
      !element.isConnected ||
      element.disabled ||
      element.hidden ||
      element.getAttribute(
        'aria-disabled',
      ) === 'true' ||
      element.closest(
        '[hidden], [aria-hidden="true"]',
      )
    ) {
      return false;
    }

    return isVisible(element);
  }

  function parseClaimAmount(
    element,
  ) {
    const match =
      (
        element.textContent ||
        ''
      ).match(AMOUNT_RE);

    return Math.max(
      1,
      Number(
        (
          match?.[1] || '1'
        ).replace(/,/g, ''),
      ) || 1,
    );
  }

  function createReactLikeEvent(
    element,
    eventName,
  ) {
    const type =
      eventName ===
      'onPointerDown'
        ? 'pointerdown'
        : eventName ===
            'onMouseDown'
          ? 'mousedown'
          : 'click';

    const NativeEvent =
      type === 'pointerdown' &&
      typeof PointerEvent ===
        'function'
        ? PointerEvent
        : MouseEvent;

    return {
      type,
      target: element,
      currentTarget: element,
      isTrusted: true,

      nativeEvent:
        new NativeEvent(
          type,
          {
            bubbles: true,
            cancelable: true,
            view: window,
          },
        ),

      preventDefault() {},
      stopPropagation() {},
      stopImmediatePropagation() {},
      persist() {},
    };
  }

  function invokeReactHandler(
    element,
  ) {
    const eventNames = [
      'onClick',
      'onPointerDown',
      'onMouseDown',
    ];

    const ownKeys =
      Object.getOwnPropertyNames(
        element,
      );

    for (
      const key of ownKeys
    ) {
      if (
        !key.startsWith(
          '__reactProps$',
        )
      ) {
        continue;
      }

      const props =
        element[key];

      for (
        const eventName of
          eventNames
      ) {
        if (
          typeof props?.[
            eventName
          ] === 'function'
        ) {
          props[eventName](
            createReactLikeEvent(
              element,
              eventName,
            ),
          );

          return eventName;
        }
      }
    }

    const fiberKey =
      ownKeys.find(
        (key) =>
          key.startsWith(
            '__reactFiber$',
          ) ||
          key.startsWith(
            '__reactInternalInstance$',
          ),
      );

    let fiber =
      fiberKey
        ? element[fiberKey]
        : null;

    for (
      let depth = 0;
      fiber &&
      depth < 5;
      depth += 1
    ) {
      const props =
        fiber.memoizedProps;

      for (
        const eventName of
          eventNames
      ) {
        if (
          typeof props?.[
            eventName
          ] === 'function'
        ) {
          props[eventName](
            createReactLikeEvent(
              element,
              eventName,
            ),
          );

          return eventName;
        }
      }

      fiber =
        fiber.return;
    }

    return '';
  }

  function claimNow(
    element,
  ) {
    pendingClaims.delete(
      element,
    );

    if (
      !element?.isConnected ||
      !localState.eligible ||
      localState.loginRequired ||
      !isClaimControlText(
        element.textContent || '',
      ) ||
      !isVisibleAndEnabled(
        element,
      )
    ) {
      return false;
    }

    const now = Date.now();

    if (
      now -
        (
          lastAttemptAt.get(
            element,
          ) || 0
        ) <
        RETRY_COOLDOWN_MS
    ) {
      return false;
    }

    lastAttemptAt.set(
      element,
      now,
    );

    const amount =
      parseClaimAmount(
        element,
      );

    try {
      const reactHandlerInvoked =
        invokeReactHandler(
          element,
        );

      if (
        !reactHandlerInvoked
      ) {
        element.click();
      }

      console.info(
        `[CHZZK Log Power] 통나무 파워 ${amount}개 수령 버튼을 클릭했습니다.`,
      );

      return true;
    } catch (error) {
      lastAttemptAt.delete(
        element,
      );

      console.warn(
        '[CHZZK Log Power] 자동 수령 클릭에 실패했습니다.',
        error,
      );

      return false;
    }
  }

  function considerClaim(
    element,
  ) {
    if (
      !isClaimControlText(
        element.textContent ||
          '',
      ) ||
      !isVisibleAndEnabled(
        element,
      )
    ) {
      return;
    }

    const now = Date.now();

    if (
      now -
        (
          lastCandidateObservationAt.get(
            element,
          ) || 0
        ) >=
        RETRY_COOLDOWN_MS
    ) {
      lastCandidateObservationAt.set(
        element,
        now,
      );
    }

    if (
      now -
        (
          pendingClaims.get(
            element,
          ) || 0
        ) <
        CLAIM_SETTLE_MS
    ) {
      return;
    }

    pendingClaims.set(
      element,
      now,
    );

    setTimeout(
      () => {
        claimNow(element);
      },
      CLAIM_SETTLE_MS,
    );
  }

  /* =========================================================
   * DOM 탐색
   * ======================================================= */

  function inspectButton(
    button,
  ) {
    considerClaim(button);
  }

  function inspectClaimControl(
    control,
  ) {
    if (
      control instanceof
      Element
    ) {
      considerClaim(control);
    }
  }

  function nodeContainsPlaybackElement(
    node,
  ) {
    if (
      !(node instanceof
        Element)
    ) {
      return false;
    }

    return (
      node.matches(
        'video, #live_player_layout, [id*="live_player_layout"]',
      ) ||
      !!node.querySelector(
        'video, #live_player_layout, [id*="live_player_layout"]',
      )
    );
  }

  function inspectNode(
    node,
  ) {
    if (
      node.nodeType ===
      Node.TEXT_NODE
    ) {
      const control =
        node.parentElement?.closest(
          'button, [role="button"]',
        );

      if (
        control?.matches(
          'button',
        )
      ) {
        inspectButton(
          control,
        );
      } else if (
        control
      ) {
        inspectClaimControl(
          control,
        );
      }

      return;
    }

    if (
      node.nodeType !==
      Node.ELEMENT_NODE
    ) {
      return;
    }

    const element =
      /** @type {Element} */ (
        node
      );

    if (
      element.matches(
        'button',
      )
    ) {
      inspectButton(
        element,
      );
    } else if (
      element.matches(
        '[role="button"]',
      )
    ) {
      inspectClaimControl(
        element,
      );
    }

    for (
      const button of
        element.querySelectorAll(
          'button',
        )
    ) {
      inspectButton(
        button,
      );
    }

    for (
      const control of
        element.querySelectorAll(
          '[role="button"]:not(button)',
        )
    ) {
      inspectClaimControl(
        control,
      );
    }
  }

  function inspectMutations(
    mutations,
  ) {
    let playbackMayHaveChanged =
      observedVideo instanceof
        HTMLVideoElement &&
      !observedVideo.isConnected;

    for (
      const mutation of
        mutations
    ) {
      if (
        mutation.type ===
        'characterData'
      ) {
        inspectNode(
          mutation.target,
        );

        continue;
      }

      if (
        mutation.type ===
        'attributes'
      ) {
        inspectNode(
          mutation.target,
        );

        continue;
      }

      for (
        const addedNode of
          mutation.addedNodes
      ) {
        inspectNode(
          addedNode,
        );

        if (
          nodeContainsPlaybackElement(
            addedNode,
          )
        ) {
          playbackMayHaveChanged =
            true;
        }
      }

      for (
        const removedNode of
          mutation.removedNodes
      ) {
        if (
          nodeContainsPlaybackElement(
            removedNode,
          )
        ) {
          playbackMayHaveChanged =
            true;
        }
      }
    }

    if (
      playbackMayHaveChanged
    ) {
      schedulePlaybackRefresh(
        'dom-player-change',
      );
    }
  }

  /* =========================================================
   * SPA 라우팅
   * ======================================================= */

  function handleRouteChange(
    reason,
  ) {
    if (
      location.pathname ===
      lastPathname
    ) {
      return;
    }

    lastPathname =
      location.pathname;

    clearPendingPauseConfirmation();

    playbackLossAt = 0;
    playbackLossGraceMs = 0;
    playbackGraceKind = '';

    clearPlaybackGraceTimer();

    liveStatus = {
      channelId: '',
      status: 'UNKNOWN',
      checkedAt: 0,
      inFlight: false,
      lastConfirmedOpenAt: 0,
      unknownSinceAt: 0,
      outcome: 'route-change',
      httpStatus: 0,
    };

    refreshLocalPlaybackState(
      reason,
    );

    void refreshLiveStatus(
      true,
    );

    schedulePageReadinessWarmup(
      reason,
    );
  }

  function installRouteWatcher() {
    for (
      const methodName of [
        'pushState',
        'replaceState',
      ]
    ) {
      const original =
        history[methodName];

      if (
        typeof original !==
          'function' ||
        original.__chzzkCoreWrapped
      ) {
        continue;
      }

      function wrappedHistoryMethod(
        ...args
      ) {
        const result =
          original.apply(
            this,
            args,
          );

        queueMicrotask(
          () =>
            handleRouteChange(
              `history.${methodName}`,
            ),
        );

        return result;
      }

      Object.defineProperty(
        wrappedHistoryMethod,
        '__chzzkCoreWrapped',
        {
          value: true,
        },
      );

      history[methodName] =
        wrappedHistoryMethod;
    }

    window.addEventListener(
      'popstate',
      () =>
        handleRouteChange(
          'popstate',
        ),
    );
  }

  /* =========================================================
   * 페이지 준비 단계
   * ======================================================= */

  function clearPageReadinessWarmup() {
    for (
      const timer of
        pageReadinessWarmupTimers
    ) {
      clearTimeout(timer);
    }

    pageReadinessWarmupTimers =
      [];
  }

  function runPageReadinessWarmup(
    reason,
  ) {
    const channelId =
      getLiveChannelId();

    if (!channelId) {
      return;
    }

    if (
      liveStatus.channelId !==
        channelId ||
      liveStatus.status ===
        'UNKNOWN' ||
      !liveStatus.checkedAt
    ) {
      void refreshLiveStatus(
        true,
      );
    } else {
      void refreshLiveStatus(
        false,
      );
    }

    refreshLocalPlaybackState(
      `page-readiness:${reason}`,
    );

    for (
      const button of
        document.querySelectorAll(
          'button',
        )
    ) {
      inspectButton(
        button,
      );
    }

    for (
      const control of
        document.querySelectorAll(
          '[role="button"]:not(button)',
        )
    ) {
      inspectClaimControl(
        control,
      );
    }
  }

  function schedulePageReadinessWarmup(
    reason = 'page-ready',
  ) {
    clearPageReadinessWarmup();

    if (
      !getLiveChannelId()
    ) {
      return;
    }

    pageReadinessWarmupTimers =
      PAGE_READINESS_WARMUP_DELAYS_MS.map(
        (delayMs) =>
          setTimeout(
            () => {
              runPageReadinessWarmup(
                reason,
              );
            },
            Math.max(
              0,
              Number(
                delayMs,
              ) || 0,
            ),
          ),
      );
  }

  /* =========================================================
   * T 키 플레이어 모드 전환 감지
   * ======================================================= */

  function installPlayerModeToggleTracking() {
    document.addEventListener(
      'keydown',
      (event) => {
        const target =
          event.target;

        const isEditing =
          target instanceof
            Element &&
          !!target.closest(
            'input, textarea, select, [contenteditable="true"], [role="textbox"]',
          );

        if (
          isEditing ||
          event.repeat ||
          event.ctrlKey ||
          event.metaKey ||
          event.altKey ||
          event.key.toLowerCase() !==
            't'
        ) {
          return;
        }

        lastPlayerModeToggleAt =
          Date.now();
      },
      true,
    );
  }

  /* =========================================================
   * 초기화
   * ======================================================= */

  function scheduleInitialWarmup() {
    const syncNow = () => {
      refreshLocalPlaybackState(
        'initial-warmup',
      );

      void refreshLiveStatus(
        false,
      );

      for (
        const button of
          document.querySelectorAll(
            'button',
          )
      ) {
        inspectButton(
          button,
        );
      }

      for (
        const control of
          document.querySelectorAll(
            '[role="button"]:not(button)',
          )
      ) {
        inspectClaimControl(
          control,
        );
      }
    };

    syncNow();

    initialSyncWarmupTimers = [
      250,
      1_250,
      3_000,
    ].map(
      (delayMs) =>
        setTimeout(
          syncNow,
          delayMs,
        ),
    );
  }

  function disposeRuntime() {
    if (runtimeDisposed) {
      return;
    }

    runtimeDisposed = true;
    pageLifecycleState =
      'disposed';

    clearInterval(
      heartbeat,
    );

    for (
      const timer of
        initialSyncWarmupTimers
    ) {
      clearTimeout(timer);
    }

    initialSyncWarmupTimers =
      [];

    clearPageReadinessWarmup();
    clearPendingPauseConfirmation();
    clearPlaybackGraceTimer();

    observer.disconnect();
  }

  installRouteWatcher();
  installPlayerModeToggleTracking();

  refreshLocalPlaybackState(
    'initial',
  );

  void refreshLiveStatus(
    true,
  );

  scheduleInitialWarmup();
  schedulePageReadinessWarmup(
    'initial',
  );

  for (
    const button of
      document.querySelectorAll(
        'button',
      )
  ) {
    inspectButton(
      button,
    );
  }

  for (
    const control of
      document.querySelectorAll(
        '[role="button"]:not(button)',
      )
  ) {
    inspectClaimControl(
      control,
    );
  }

  const observer =
    new MutationObserver(
      inspectMutations,
    );

  observer.observe(
    document.documentElement,
    {
      subtree: true,
      childList: true,
      characterData: true,
      attributes: true,
      attributeFilter: [
        'role',
        'disabled',
        'aria-disabled',
        'hidden',
      ],
    },
  );

  const heartbeat =
    setInterval(
      () => {
        handleRouteChange(
          'heartbeat-route',
        );

        refreshLocalPlaybackState(
          'heartbeat',
        );

        void refreshLiveStatus(
          false,
        );
      },
      HEARTBEAT_MS,
    );

  /* =========================================================
   * BFCache
   * ======================================================= */

  window.addEventListener(
    'pagehide',
    (event) => {
      pageHideCount++;

      lastPageHidePersisted =
        !!event.persisted;

      if (
        lastPageHidePersisted
      ) {
        pageLifecycleState =
          'bfcache';

        return;
      }

      disposeRuntime();
    },
  );

  window.addEventListener(
    'pageshow',
    (event) => {
      pageShowCount++;

      if (
        !event.persisted ||
        runtimeDisposed
      ) {
        return;
      }

      bfcacheResumeCount++;
      pageLifecycleState =
        'active';

      handleRouteChange(
        'pageshow-bfcache',
      );

      refreshLocalPlaybackState(
        'pageshow-bfcache',
      );

      void refreshLiveStatus(
        true,
      );

      scheduleInitialWarmup();

      schedulePageReadinessWarmup(
        'pageshow-bfcache',
      );
    },
  );

  /* =========================================================
   * 디버깅용 최소 상태
   * ======================================================= */

  window.__CHZZK_LOG_POWER_CORE__ = {
    getState() {
      return {
        path: location.pathname,
        channelId:
          getLiveChannelId(),

        liveStatus: {
          ...liveStatus,
        },

        playback: {
          ...localState,
          watchElapsedMs:
            getWatchElapsedMs(),
        },

        lifecycle: {
          state:
            pageLifecycleState,
          pageHideCount,
          pageShowCount,
          bfcacheResumeCount,
          lastPageHidePersisted,
        },
      };
    },
  };
})();
