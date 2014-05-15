part of simple_audio;

/**
 * A lowpass audio effect.
 */
class LowpassAudioEffect extends AudioEffect {
  final BiquadFilterNode _filterNode;

  LowpassAudioEffect(AudioManager audioManager, {num cutoffFrequency: 350.0, num resonance: 1.0})
      : _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'lowpass';
    _filterNode.frequency.value = cutoffFrequency;
    _filterNode.Q.value = resonance;
  }

  num get cutoffFrequency => _filterNode.frequency.value;
      set cutoffFrequency(num value) {
        _filterNode.frequency.value = value;
      }

  num get resonance => _filterNode.Q.value;
      set resonance(num value) {
        _filterNode.Q.value = value;
      }

  void linearRampCutoffFrequency(num value, num time) {
    _filterNode.frequency.linearRampToValueAtTime(value, time);
  }

  void linearRampResonance(num value, num time) {
    _filterNode.Q.linearRampToValueAtTime(value, time);
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

  HighpassAudioEffect(AudioManager audioManager, {num cutoffFrequency: 350.0, num resonance: 1.0})
      : _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'highpass';
    _filterNode.frequency.value = cutoffFrequency;
    _filterNode.Q.value = resonance;
  }

  num get cutoffFrequency => _filterNode.frequency.value;
      set cutoffFrequency(num value) {
        _filterNode.frequency.value = value;
      }

  num get resonance => _filterNode.Q.value;
      set resonance(num value) {
        _filterNode.Q.value = value;
      }

  void linearRampCutoffFrequency(num value, num time) {
    _filterNode.frequency.linearRampToValueAtTime(value, time);
  }

  void linearRampResonance(num value, num time) {
    _filterNode.Q.linearRampToValueAtTime(value, time);
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

  BandpassAudioEffect(AudioManager audioManager, {num centerFrequency: 350.0, num bandwidth: 1.0})
      : _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'bandpass';
    _filterNode.frequency.value = centerFrequency;
    _filterNode.Q.value = bandwidth;
  }

  num get centerFrequency => _filterNode.frequency.value;
      set centerFrequency(num value) {
        _filterNode.frequency.value = value;
      }

  num get bandwidth => _filterNode.Q.value;
      set bandwidth(num value) {
        _filterNode.Q.value = value;
      }

  void linearRampCenterFrequency(num value, num time) {
    _filterNode.frequency.linearRampToValueAtTime(value, time);
  }

  void linearRampBandwidth(num value, num time) {
    _filterNode.Q.linearRampToValueAtTime(value, time);
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

  LowshelfAudioEffect(AudioManager audioManager, {num upperFrequency: 350.0, num boost: 0.0})
      : _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'lowshelf';
    _filterNode.frequency.value = upperFrequency;
    _filterNode.gain.value = boost;
  }

  num get upperFrequency => _filterNode.frequency.value;
      set upperFrequency(num value) {
        _filterNode.frequency.value = value;
      }

  num get boost => _filterNode.gain.value;
      set boost(num value) {
        _filterNode.gain.value = value;
      }

  void linearRampUpperFrequency(num value, num time) {
    _filterNode.frequency.linearRampToValueAtTime(value, time);
  }

  void linearRampBoost(num value, num time) {
    _filterNode.gain.linearRampToValueAtTime(value, time);
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

  HighshelfAudioEffect(AudioManager audioManager, {num lowerFrequency: 350.0, num boost: 0.0})
      : _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'highshelf';
    _filterNode.frequency.value = lowerFrequency;
    _filterNode.gain.value = boost;
  }

  num get lowerFrequency => _filterNode.frequency.value;
      set lowerFrequency(num value) {
        _filterNode.frequency.value = value;
      }

  num get boost => _filterNode.gain.value;
      set boost(num value) {
        _filterNode.gain.value = value;
      }

  void linearRampLowerFrequency(num value, num time) {
    _filterNode.frequency.linearRampToValueAtTime(value, time);
  }

  void linearRampBoost(num value, num time) {
    _filterNode.gain.linearRampToValueAtTime(value, time);
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

  PeakingAudioEffect(AudioManager audioManager, {num frequency: 350.0, num width: 1.0, num boost: 0.0})
      : _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'peaking';
    _filterNode.frequency.value = frequency;
    _filterNode.Q.value = width;
    _filterNode.gain.value = boost;
  }

  num get frequency => _filterNode.frequency.value;
      set frequency(num value) {
        _filterNode.frequency.value = value;
      }

  num get width => _filterNode.Q.value;
      set width(num value) {
        _filterNode.Q.value = value;
      }

  num get boost => _filterNode.gain.value;
      set boost(num value) {
        _filterNode.gain.value = value;
      }

  void linearRampFrequency(num value, num time) {
    _filterNode.frequency.linearRampToValueAtTime(value, time);
  }

  void linearRampWidth(num value, num time) {
    _filterNode.Q.linearRampToValueAtTime(value, time);
  }

  void linearRampBoost(num value, num time) {
    _filterNode.gain.linearRampToValueAtTime(value, time);
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

  NotchAudioEffect(AudioManager audioManager, {num frequency: 350.0, num bandwidth: 1.0})
      : _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'notch';
    _filterNode.frequency.value = frequency;
    _filterNode.Q.value = bandwidth;
  }

  num get frequency => _filterNode.frequency.value;
      set frequency(num value) {
        _filterNode.frequency.value = value;
      }

  num get bandwidth => _filterNode.Q.value;
      set bandwidth(num value) {
        _filterNode.Q.value = value;
      }

  void linearRampFrequency(num value, num time) {
    _filterNode.frequency.linearRampToValueAtTime(value, time);
  }

  void linearRampBandwidth(num value, num time) {
    _filterNode.Q.linearRampToValueAtTime(value, time);
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

  AllpassAudioEffect(AudioManager audioManager, {num centerFrequency: 350.0, num transissionSharpness: 1.0})
      : _filterNode = audioManager._context.createBiquadFilter() {
    _filterNode.type = 'allpass';
    _filterNode.frequency.value = centerFrequency;
    _filterNode.Q.value = transissionSharpness;
  }

  num get centerFrequency => _filterNode.frequency.value;
      set centerFrequency(num value) {
        _filterNode.frequency.value = value;
      }

  num get transissionSharpness => _filterNode.Q.value;
      set transissionSharpness(num value) {
        _filterNode.Q.value = value;
      }

  void linearRampCenterFrequency(num value, num time) {
    _filterNode.frequency.linearRampToValueAtTime(value, time);
  }

  void linearRampTransissionSharpness(num value, num time) {
    _filterNode.Q.linearRampToValueAtTime(value, time);
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

  ConvolverAudioEffect(AudioManager audioManager, AudioClip impulseResponse, {bool normalize: true})
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
