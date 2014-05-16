/*
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

part of simple_audio;

/**
 * A lowpass audio effect.
 */
class LowpassAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;
  final AudioManager _audioManager;

  LowpassAudioEffect(AudioManager audioManager, {num cutoffFrequency: 350.0,
    num resonance: 1.0})
      : _audioManager = audioManager,
        _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'lowpass';
    _filterNode.frequency.value = cutoffFrequency;
    _filterNode.Q.value = resonance;
  }

  num get cutoffFrequency => _filterNode.frequency.value;
  void set cutoffFrequency(num value) {
    _filterNode.frequency.value = value;
  }

  num get resonance => _filterNode.Q.value;
  void set resonance(num value) {
    _filterNode.Q.value = value;
  }

  void fadeCutoffFrequency(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.frequency, value,
        fadeDuration, delay);
  }

  void fadeResonance(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.Q, value, fadeDuration,
        delay);
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _filterNode.disconnect(0);
    inNode.connectNode(_filterNode);
    return _filterNode;
  }
}

/**
 * A highpass audio effect.
 */
class HighpassAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;
  final AudioManager _audioManager;

  HighpassAudioEffect(AudioManager audioManager, {num cutoffFrequency: 350.0,
    num resonance: 1.0})
      : _audioManager = audioManager,
        _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'highpass';
    _filterNode.frequency.value = cutoffFrequency;
    _filterNode.Q.value = resonance;
  }

  num get cutoffFrequency => _filterNode.frequency.value;
  void set cutoffFrequency(num value) {
    _filterNode.frequency.value = value;
  }

  num get resonance => _filterNode.Q.value;
  void set resonance(num value) {
    _filterNode.Q.value = value;
  }

  void fadeCutoffFrequency(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.frequency, value,
        fadeDuration, delay);
  }

  void fadeResonance(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.Q, value, fadeDuration,
        delay);
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _filterNode.disconnect(0);
    inNode.connectNode(_filterNode);
    return _filterNode;
  }
}

/**
 * A bandpass audio effect.
 */
class BandpassAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;
  final AudioManager _audioManager;

  BandpassAudioEffect(AudioManager audioManager, {num centerFrequency: 350.0,
    num bandwidth: 1.0})
      : _audioManager = audioManager,
        _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'bandpass';
    _filterNode.frequency.value = centerFrequency;
    _filterNode.Q.value = bandwidth;
  }

  num get centerFrequency => _filterNode.frequency.value;
  void set centerFrequency(num value) {
    _filterNode.frequency.value = value;
  }

  num get bandwidth => _filterNode.Q.value;
  void set bandwidth(num value) {
    _filterNode.Q.value = value;
  }

  void fadeCenterFrequency(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.frequency, value,
        fadeDuration, delay);
  }

  void fadeBandwidth(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.Q, value, fadeDuration,
        delay);
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _filterNode.disconnect(0);
    inNode.connectNode(_filterNode);
    return _filterNode;
  }
}

/**
 * A lowshelf audio effect.
 */
class LowshelfAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;
  final AudioManager _audioManager;

  LowshelfAudioEffect(AudioManager audioManager, {num upperFrequency: 350.0,
    num boost: 0.0})
      : _audioManager = audioManager,
        _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'lowshelf';
    _filterNode.frequency.value = upperFrequency;
    _filterNode.gain.value = boost;
  }

  num get upperFrequency => _filterNode.frequency.value;
  void set upperFrequency(num value) {
    _filterNode.frequency.value = value;
  }

  num get boost => _filterNode.gain.value;
  void set boost(num value) {
    _filterNode.gain.value = value;
  }

  void fadeUpperFrequency(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.frequency, value,
        fadeDuration, delay);
  }

  void fadeBoost(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.gain, value,
        fadeDuration, delay);
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _filterNode.disconnect(0);
    inNode.connectNode(_filterNode);
    return _filterNode;
  }
}

/**
 * A highshelf audio effect.
 */
class HighshelfAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;
  final AudioManager _audioManager;

  HighshelfAudioEffect(AudioManager audioManager, {num lowerFrequency: 350.0,
    num boost: 0.0})
      : _audioManager = audioManager,
        _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'highshelf';
    _filterNode.frequency.value = lowerFrequency;
    _filterNode.gain.value = boost;
  }

  num get lowerFrequency => _filterNode.frequency.value;
  void set lowerFrequency(num value) {
    _filterNode.frequency.value = value;
  }

  num get boost => _filterNode.gain.value;
  void set boost(num value) {
    _filterNode.gain.value = value;
  }

  void fadeLowerFrequency(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.frequency, value,
        fadeDuration, delay);
  }

  void fadeBoost(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.gain, value,
        fadeDuration, delay);
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _filterNode.disconnect(0);
    inNode.connectNode(_filterNode);
    return _filterNode;
  }
}

/**
 * A lowshelf audio effect.
 */
class PeakingAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;
  final AudioManager _audioManager;

  PeakingAudioEffect(AudioManager audioManager, {num frequency: 350.0,
    num width: 1.0, num boost: 0.0})
      : _audioManager = audioManager,
        _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'peaking';
    _filterNode.frequency.value = frequency;
    _filterNode.Q.value = width;
    _filterNode.gain.value = boost;
  }

  num get frequency => _filterNode.frequency.value;
  void set frequency(num value) {
    _filterNode.frequency.value = value;
  }

  num get width => _filterNode.Q.value;
  void set width(num value) {
    _filterNode.Q.value = value;
  }

  num get boost => _filterNode.gain.value;
  void set boost(num value) {
    _filterNode.gain.value = value;
  }

  void fadeFrequency(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.frequency, value,
        fadeDuration, delay);
  }

  void fadeWidth(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.Q, value, fadeDuration,
        delay);
  }

  void fadeBoost(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.gain, value,
        fadeDuration, delay);
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _filterNode.disconnect(0);
    inNode.connectNode(_filterNode);
    return _filterNode;
  }
}

/**
 * A notch audio effect.
 */
class NotchAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;
  final AudioManager _audioManager;

  NotchAudioEffect(AudioManager audioManager, {num frequency: 350.0,
    num bandwidth: 1.0})
      : _audioManager = audioManager,
        _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'notch';
    _filterNode.frequency.value = frequency;
    _filterNode.Q.value = bandwidth;
  }

  num get frequency => _filterNode.frequency.value;
  void set frequency(num value) {
    _filterNode.frequency.value = value;
  }

  num get bandwidth => _filterNode.Q.value;
  void set bandwidth(num value) {
    _filterNode.Q.value = value;
  }

  void fadeFrequency(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.frequency, value,
        fadeDuration, delay);
  }

  void fadeBandwidth(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.Q, value, fadeDuration,
        delay);
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _filterNode.disconnect(0);
    inNode.connectNode(_filterNode);
    return _filterNode;
  }
}

/**
 * A allpass audio effect.
 */
class AllpassAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;
  final AudioManager _audioManager;

  AllpassAudioEffect(AudioManager audioManager, {num centerFrequency: 350.0,
    num transissionSharpness: 1.0})
      : _audioManager = audioManager,
        _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'allpass';
    _filterNode.frequency.value = centerFrequency;
    _filterNode.Q.value = transissionSharpness;
  }

  num get centerFrequency => _filterNode.frequency.value;
  void set centerFrequency(num value) {
    _filterNode.frequency.value = value;
  }

  num get transissionSharpness => _filterNode.Q.value;
  void set transissionSharpness(num value) {
    _filterNode.Q.value = value;
  }

  void fadeCenterFrequency(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.frequency, value,
        fadeDuration, delay);
  }

  void fadeTransissionSharpness(num value, num fadeDuration, {num delay: 0.0}) {
    _fadeAudioParam(_audioManager._context, _filterNode.Q, value, fadeDuration,
        delay);
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _filterNode.disconnect(0);
    inNode.connectNode(_filterNode);
    return _filterNode;
  }
}

/**
 * A audio effect based on an impulse response.
 */
class ConvolverAudioEffect extends AudioEffect {
  final ConvolverNode _convolverNode;

  ConvolverAudioEffect(AudioManager audioManager, AudioClip impulseResponse,
    {bool normalize: true})
      : _convolverNode = audioManager._context.createConvolver() {
    _convolverNode.buffer = impulseResponse._buffer;
    _convolverNode.normalize = normalize;
  }

  @override
  AudioNode _apply(AudioNode inNode) {
    _convolverNode.disconnect(0);
    inNode.connectNode(_convolverNode);
    return _convolverNode;
  }
}
