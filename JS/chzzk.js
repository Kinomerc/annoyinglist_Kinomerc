// ==UserScript==
// @name         CHZZK Direct Stream
// @description  
// @version      1.0
// @namespace    
// @match        https://chzzk.naver.com/*
// @run-at       document-start
// @grant        unsafeWindow
// ==/UserScript==

(() => {
  'use strict'

  const root = typeof unsafeWindow === 'undefined' ? window : unsafeWindow
  const nativeParse = root.JSON.parse
  const nativeStringify = root.JSON.stringify
  const playbackFields = [
    'livePlaybackJson',
    'liveRewindPlaybackJson',
    'radioModePlaybackJson',
    'previewPlaybackJson',
    'playbackJson',
  ]

  const isObject = value => value !== null && typeof value === 'object'

  function hasPlaybackField(value) {
    return 'livePlaybackJson' in value ||
      'liveRewindPlaybackJson' in value ||
      'radioModePlaybackJson' in value ||
      'previewPlaybackJson' in value ||
      'playbackJson' in value
  }

  function getDirectUrl(p2pPath) {
    if (typeof p2pPath !== 'string') return

    try {
      const encoded = new root.URL(p2pPath, root.location.origin)
        .searchParams.get('cdn_url')
      if (!encoded) return

      const base64 = encoded
        .replace(/ /g, '+')
        .replace(/-/g, '+')
        .replace(/_/g, '/')
        .padEnd(Math.ceil(encoded.length / 4) * 4, '=')
      const direct = new root.URL(root.atob(base64))
      const host = direct.hostname

      if (
        host === 'pstatic.net' || host.endsWith('.pstatic.net') ||
        host === 'navercdn.com' || host.endsWith('.navercdn.com')
      ) return direct.href
    } catch {}
  }

  function patchTrack(track) {
    if (!isObject(track)) return false

    let changed = false
    const direct = getDirectUrl(track.p2pPath)

    if (direct && track.path !== direct) {
      track.path = direct
      changed = true
    }
    if ('p2pPath' in track) {
      delete track.p2pPath
      changed = true
    }
    if ('p2pPathUrlEncoding' in track) {
      delete track.p2pPathUrlEncoding
      changed = true
    }

    return changed
  }

  function patchPlayback(playback) {
    if (!isObject(playback)) return false

    let changed = false
    if (isObject(playback.meta) && playback.meta.p2p !== false) {
      playback.meta.p2p = false
      changed = true
    }
    if (!root.Array.isArray(playback.media)) return changed

    for (const media of playback.media) {
      if (media?.mediaId !== 'HLS' && media?.mediaId !== 'LLHLS') continue
      changed = patchTrack(media) || changed

      if (!root.Array.isArray(media.encodingTrack)) continue
      for (const track of media.encodingTrack) {
        changed = patchTrack(track) || changed
      }
    }

    return changed
  }

  function patchPayload(payload) {
    let changed = patchPlayback(payload)

    if (
      root.Array.isArray(payload.adBreaks) && payload.adBreaks.length &&
      (payload.head?.description === 'GFP Video Ad Schedule' ||
        typeof payload.videoAdScheduleId === 'string')
    ) {
      payload.adBreaks.length = 0
      changed = true
    }

    if (
      root.Array.isArray(payload.ads) && payload.ads.length &&
      (payload.head?.description === 'Naver SSP Waterfall List' ||
        typeof payload.adUnit === 'string' && typeof payload.adDivId === 'string')
    ) {
      payload.ads.length = 0
      changed = true
    }

    const display = payload.playerAdDisplayResponse
    if (isObject(display)) {
      if (display.preRoll !== false) {
        display.preRoll = false
        changed = true
      }
      if (display.midRoll !== false) {
        display.midRoll = false
        changed = true
      }
      if (display.postRoll !== false) {
        display.postRoll = false
        changed = true
      }
    }

    if ('adControlType' in payload && ('event' in payload || 'adCount' in payload)) {
      payload.id = null
      payload.event = 'ABORT'
      payload.adCount = 0
      changed = true
    }

    const legacy = payload.livePlaybackJson
    if (isObject(legacy) && ('liveId' in legacy || 'chatChannelId' in legacy)) {
      legacy.liveId = false
      legacy.chatChannelId = false
      changed = true
    }

    const isMedia =
      'liveId' in payload || 'videoNo' in payload ||
      hasPlaybackField(payload)

    if (isMedia && payload.skipPreRollAd === false) {
      payload.skipPreRollAd = true
      changed = true
    }
    if (isMedia && 'dab' in payload && payload.dab !== false) {
      payload.dab = false
      changed = true
    }

    for (const key of playbackFields) {
      const text = payload[key]
      if (typeof text !== 'string' || !text) continue

      try {
        const playback = nativeParse(text)
        if (!patchPlayback(playback)) continue
        payload[key] = nativeStringify(playback)
        changed = true
      } catch {}
    }

    return changed
  }

  function isCandidate(value) {
    return isObject(value) && (
      'media' in value || 'meta' in value ||
      'adBreaks' in value || 'ads' in value ||
      'playerAdDisplayResponse' in value || 'adControlType' in value ||
      'skipPreRollAd' in value || 'dab' in value ||
      hasPlaybackField(value)
    )
  }

  function patchResponse(value) {
    let changed = false
    if (isCandidate(value)) changed = patchPayload(value)
    if (isCandidate(value?.content)) changed = patchPayload(value.content) || changed
    return changed
  }

  root.JSON.parse = function parse(text, reviver) {
    const value = nativeParse(text, reviver)
    patchResponse(value)
    return value
  }

  const nativeResponseJson = root.Response?.prototype?.json
  if (nativeResponseJson) {
    root.Response.prototype.json = function json() {
      const result = nativeResponseJson.call(this)
      return this.url?.startsWith('https://api.chzzk.naver.com/')
        ? result.then(value => (patchResponse(value), value))
        : result
    }
  }

  const subtle = root.crypto?.subtle
  const nativeDecrypt = subtle?.decrypt
  if (nativeDecrypt && root.TextDecoder && root.TextEncoder) {
    const decoder = new root.TextDecoder('utf-8', { fatal: true })
    const encoder = new root.TextEncoder()

    function patchBuffer(buffer) {
      if (
        !(buffer instanceof root.ArrayBuffer) ||
        buffer.byteLength < 2 || buffer.byteLength > 2 * 1024 * 1024
      ) return buffer

      try {
        const bytes = new root.Uint8Array(buffer)
        let offset = bytes[0] === 0xef && bytes[1] === 0xbb && bytes[2] === 0xbf ? 3 : 0
        const limit = Math.min(bytes.length, offset + 32)

        while (offset < limit && (
          bytes[offset] === 0x09 || bytes[offset] === 0x0a ||
          bytes[offset] === 0x0d || bytes[offset] === 0x20
        )) offset += 1

        if (bytes[offset] !== 0x7b && bytes[offset] !== 0x5b) return buffer

        const value = nativeParse(decoder.decode(bytes.subarray(offset)))
        if (!patchResponse(value)) return buffer
        return encoder.encode(nativeStringify(value)).buffer
      } catch {
        return buffer
      }
    }

    function decrypt(algorithm, key, data) {
      return nativeDecrypt.call(this, algorithm, key, data).then(patchBuffer)
    }

    const prototype = root.Object.getPrototypeOf(subtle)
    const descriptor = root.Object.getOwnPropertyDescriptor(prototype, 'decrypt')
    try {
      root.Object.defineProperty(prototype, 'decrypt', { ...descriptor, value: decrypt })
    } catch {
      try { subtle.decrypt = decrypt } catch {}
    }
  }
  const style = root.document.createElement('style')
  style.textContent = 'html body div.banner_ad_wrapper{display:block!important}[id$="_banner"]:has(iframe[id$="_tgtLREC"][title="AD"]){display:none!important}'
  root.document.documentElement.append(style)
})()
