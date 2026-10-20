
// ==UserScript==
// @name         Web Video Frame Blend
// @namespace    https://github.com/Kinomerc/annoyinglist_Kinomerc
// @version      1.1.0
// @description  영상에 프레임 블렌딩을 적용하여 프레임 가짜보간을 실행합니다
// @match        *://*/*
// @run-at       document-idle
// @grant        none
// @noframes
// ==/UserScript==

(() => {
    'use strict';

    const MAX_PROCESS_PIXELS = 4_000_000;
    const MAX_PROCESS_SIDE = 2560;
    const DEFAULT_FRAME_INTERVAL_MS = 1000 / 30;
    const MAX_FRAME_INTERVAL_MS = 500;
    const MIN_VIDEO_WIDTH = 240;
    const MIN_VIDEO_HEIGHT = 135;
    const SCAN_INTERVAL_MS = 500;

    let activeSession = null;
    let scanQueued = false;
    const failedVideos = new WeakSet();

    const saveInlineStyle = (element, property) => ({
        value: element.style.getPropertyValue(property),
        priority: element.style.getPropertyPriority(property),
    });

    const restoreInlineStyle = (element, property, saved) => {
        if (saved.value) {
            element.style.setProperty(property, saved.value, saved.priority);
        } else {
            element.style.removeProperty(property);
        }
    };

    const setStyle = (element, property, value) => {
        element.style.setProperty(property, value, 'important');
    };

    function isEligibleVideo(video) {
        if (!video.isConnected || video.videoWidth <= 0 || video.videoHeight <= 0) return false;
        if (failedVideos.has(video)) return false;

        const style = getComputedStyle(video);
        if (style.display === 'none' || Number(style.opacity) === 0) return false;
        if (style.visibility === 'hidden' && activeSession?.video !== video) return false;

        const rect = video.getBoundingClientRect();
        return rect.width >= MIN_VIDEO_WIDTH && rect.height >= MIN_VIDEO_HEIGHT;
    }

    function findTargetVideo() {
        let bestVideo = null;
        let bestScore = 0;

        for (const video of document.querySelectorAll('video')) {
            if (!isEligibleVideo(video)) continue;

            const rect = video.getBoundingClientRect();
            const area = rect.width * rect.height;
            const score = area * (video.paused || video.ended ? 1 : 2);

            if (score > bestScore) {
                bestScore = score;
                bestVideo = video;
            }
        }

        return bestVideo;
    }

    function createCanvas() {
        const canvas = document.createElement('canvas');
        canvas.width = 1;
        canvas.height = 1;
        return canvas;
    }

    function getProcessingSize(width, height) {
        const pixelScale = Math.sqrt(MAX_PROCESS_PIXELS / (width * height));
        const sideScale = MAX_PROCESS_SIDE / Math.max(width, height);
        const scale = Math.min(1, pixelScale, sideScale);

        return {
            width: Math.max(1, Math.floor(width * scale)),
            height: Math.max(1, Math.floor(height * scale)),
        };
    }

    function resizeSession(session) {
        const width = session.video.videoWidth;
        const height = session.video.videoHeight;
        if (!width || !height) return false;

        const size = getProcessingSize(width, height);
        if (session.width === size.width && session.height === size.height) return false;

        for (const canvas of session.frames) {
            canvas.width = size.width;
            canvas.height = size.height;
        }

        session.outputCanvas.width = size.width;
        session.outputCanvas.height = size.height;
        session.width = size.width;
        session.height = size.height;
        session.hasCurrentFrame = false;
        session.hasPreviousFrame = false;
        session.currentIndex = 0;
        return true;
    }

    function positionCanvas(session) {
        const { video, host, outputCanvas } = session;
        if (!video.isConnected || !host.isConnected) return;

        const videoRect = video.getBoundingClientRect();
        const hostRect = host.getBoundingClientRect();
        const scaleX = host.offsetWidth > 0 ? hostRect.width / host.offsetWidth : 1;
        const scaleY = host.offsetHeight > 0 ? hostRect.height / host.offsetHeight : 1;
        const safeScaleX = scaleX > 0 ? scaleX : 1;
        const safeScaleY = scaleY > 0 ? scaleY : 1;

        outputCanvas.style.left = `${(videoRect.left - hostRect.left - host.clientLeft + host.scrollLeft) / safeScaleX}px`;
        outputCanvas.style.top = `${(videoRect.top - hostRect.top - host.clientTop + host.scrollTop) / safeScaleY}px`;
        outputCanvas.style.width = `${videoRect.width / safeScaleX}px`;
        outputCanvas.style.height = `${videoRect.height / safeScaleY}px`;

        const videoStyle = getComputedStyle(video);
        outputCanvas.style.objectFit = videoStyle.objectFit;
        outputCanvas.style.objectPosition = videoStyle.objectPosition;
        outputCanvas.style.borderRadius = videoStyle.borderRadius;
        outputCanvas.style.display = session.nativeVideoFullscreen ? 'none' : 'block';
    }

    function captureVideoFrame(session) {
        const { video } = session;
        if (!video.videoWidth || !video.videoHeight) return;

        resizeSession(session);

        if (session.hasCurrentFrame) {
            session.previousIndex = session.currentIndex;
            session.currentIndex = 1 - session.currentIndex;
            session.hasPreviousFrame = true;
        } else {
            session.currentIndex = 0;
            session.hasPreviousFrame = false;
            session.hasCurrentFrame = true;
        }

        const frameCanvas = session.frames[session.currentIndex];
        const context = frameCanvas.getContext('2d', { alpha: false });
        context.drawImage(video, 0, 0, session.width, session.height);
    }

    function drawBlendedFrame(session, now) {
        const context = session.outputContext;
        const { width, height } = session;
        context.globalAlpha = 1;
        context.clearRect(0, 0, width, height);

        if (!session.hasCurrentFrame) return;
        if (!session.hasPreviousFrame) {
            context.drawImage(session.frames[session.currentIndex], 0, 0, width, height);
            return;
        }

        const elapsed = Math.max(0, now - session.frameArrivalTime);
        const blend = Math.max(0, Math.min(1, elapsed / session.frameIntervalMs));

        context.drawImage(session.frames[session.previousIndex], 0, 0, width, height);
        if (blend > 0) {
            context.globalAlpha = blend;
            context.drawImage(session.frames[session.currentIndex], 0, 0, width, height);
            context.globalAlpha = 1;
        }
    }

    function stopSession() {
        const session = activeSession;
        if (!session) return;

        session.stopped = true;
        if (session.rafId) cancelAnimationFrame(session.rafId);
        if (session.frameCallbackId && typeof session.video.cancelVideoFrameCallback === 'function') {
            session.video.cancelVideoFrameCallback(session.frameCallbackId);
        }

        document.removeEventListener('fullscreenchange', session.fullscreenHandler);
        session.outputCanvas.remove();
        restoreInlineStyle(session.video, 'visibility', session.videoVisibility);

        if (session.hostPositionChanged) {
            restoreInlineStyle(session.host, 'position', session.hostPosition);
        }

        activeSession = null;
    }

    function onVideoFrame(session, now, metadata) {
        if (activeSession !== session || session.stopped) return;

        const mediaTime = Number.isFinite(metadata.mediaTime)
            ? metadata.mediaTime
            : session.video.currentTime;

        if (session.lastCallbackTime !== null) {
            const callbackDelta = now - session.lastCallbackTime;
            if (callbackDelta > 0 && callbackDelta <= MAX_FRAME_INTERVAL_MS) {
                session.frameIntervalMs = callbackDelta;
            }

            const mediaDelta = mediaTime - session.lastMediaTime;
            if (mediaDelta <= 0 || mediaDelta * 1000 > MAX_FRAME_INTERVAL_MS) {
                session.hasCurrentFrame = false;
                session.hasPreviousFrame = false;
            }
        }

        try {
            captureVideoFrame(session);
        } catch (error) {
            failedVideos.add(session.video);
            console.warn('[Web Video Frame Blend] 영상 프레임을 캡처하지 못했습니다.', error);
            stopSession();
            scheduleScan();
            return;
        }

        session.lastMediaTime = mediaTime;
        session.lastCallbackTime = now;
        session.frameArrivalTime = now;
        session.frameCallbackId = session.video.requestVideoFrameCallback(
            (nextNow, nextMetadata) => onVideoFrame(session, nextNow, nextMetadata)
        );
    }

    function syncFullscreen(session) {
        const fullscreenElement = document.fullscreenElement;
        const videoAloneIsFullscreen = fullscreenElement === session.video;
        const canvasIsInsideFullscreen = Boolean(
            fullscreenElement && fullscreenElement.contains(session.outputCanvas)
        );
        const shouldShowNativeVideo = videoAloneIsFullscreen && !canvasIsInsideFullscreen;

        if (shouldShowNativeVideo !== session.nativeVideoFullscreen) {
            session.nativeVideoFullscreen = shouldShowNativeVideo;
            if (shouldShowNativeVideo) {
                restoreInlineStyle(session.video, 'visibility', session.videoVisibility);
            } else {
                setStyle(session.video, 'visibility', 'hidden');
            }
        }

        positionCanvas(session);
    }

    function startSession(video) {
        if (!video || typeof video.requestVideoFrameCallback !== 'function') return false;
        if (!video.videoWidth || !video.videoHeight) return false;

        let host = video.parentElement || document.body;
        if (getComputedStyle(host).display === 'contents' && host.parentElement) {
            host = host.parentElement;
        }

        const hostPosition = saveInlineStyle(host, 'position');
        const hostPositionChanged = getComputedStyle(host).position === 'static';
        if (hostPositionChanged) setStyle(host, 'position', 'relative');

        const outputCanvas = createCanvas();
        outputCanvas.setAttribute('aria-hidden', 'true');
        outputCanvas.style.cssText = [
            'position:absolute!important',
            'z-index:0!important',
            'pointer-events:none!important',
            'margin:0!important',
            'padding:0!important',
            'border:0!important',
            'max-width:none!important',
            'max-height:none!important',
            'transform:none!important',
            'background:transparent!important',
        ].join(';');

        let insertionAnchor = video;
        while (insertionAnchor.parentElement && insertionAnchor.parentElement !== host) {
            insertionAnchor = insertionAnchor.parentElement;
        }
        host.insertBefore(outputCanvas, insertionAnchor);

        const session = {
            video,
            host,
            outputCanvas,
            outputContext: outputCanvas.getContext('2d', { alpha: false }),
            frames: [createCanvas(), createCanvas()],
            currentIndex: 0,
            previousIndex: 1,
            hasCurrentFrame: false,
            hasPreviousFrame: false,
            width: 1,
            height: 1,
            frameIntervalMs: DEFAULT_FRAME_INTERVAL_MS,
            frameArrivalTime: performance.now(),
            lastMediaTime: null,
            lastCallbackTime: null,
            frameCallbackId: 0,
            rafId: 0,
            stopped: false,
            nativeVideoFullscreen: false,
            videoVisibility: saveInlineStyle(video, 'visibility'),
            hostPosition,
            hostPositionChanged,
            fullscreenHandler: null,
        };

        activeSession = session;

        try {
            resizeSession(session);
            captureVideoFrame(session);
        } catch (error) {
            failedVideos.add(video);
            console.warn('[Web Video Frame Blend] 초기 프레임을 캡처하지 못했습니다.', error);
            stopSession();
            return false;
        }

        setStyle(video, 'visibility', 'hidden');
        session.lastMediaTime = video.currentTime;
        session.lastCallbackTime = null;
        session.frameArrivalTime = performance.now();

        session.fullscreenHandler = () => syncFullscreen(session);
        document.addEventListener('fullscreenchange', session.fullscreenHandler);

        const render = (now) => {
            if (activeSession !== session || session.stopped) return;
            if (!video.isConnected || !outputCanvas.isConnected) {
                stopSession();
                scheduleScan();
                return;
            }

            try {
                positionCanvas(session);
                drawBlendedFrame(session, now);
            } catch (error) {
                failedVideos.add(video);
                console.warn('[Web Video Frame Blend] 캔버스 렌더링에 실패했습니다.', error);
                stopSession();
                scheduleScan();
                return;
            }

            session.rafId = requestAnimationFrame(render);
        };

        session.frameCallbackId = video.requestVideoFrameCallback(
            (now, metadata) => onVideoFrame(session, now, metadata)
        );
        session.rafId = requestAnimationFrame(render);
        return true;
    }

    function scanVideos() {
        const target = findTargetVideo();

        if (target === activeSession?.video) return;
        if (activeSession) stopSession();
        if (target) startSession(target);
    }

    function scheduleScan() {
        if (scanQueued) return;
        scanQueued = true;
        queueMicrotask(() => {
            scanQueued = false;
            scanVideos();
        });
    }

    document.addEventListener('loadedmetadata', (event) => {
        if (event.target instanceof HTMLVideoElement) failedVideos.delete(event.target);
        scheduleScan();
    }, true);
    document.addEventListener('loadeddata', scheduleScan, true);
    document.addEventListener('play', scheduleScan, true);
    document.addEventListener('playing', scheduleScan, true);
    document.addEventListener('emptied', scheduleScan, true);
    document.addEventListener('ended', scheduleScan, true);

    const observer = new MutationObserver(scheduleScan);
    observer.observe(document.documentElement, { childList: true, subtree: true });

    setInterval(scanVideos, SCAN_INTERVAL_MS);
    scheduleScan();
})();
