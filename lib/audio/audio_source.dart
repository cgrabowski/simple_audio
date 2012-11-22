part of simple_audio;

class AudioSource {
  AudioManager _manager;
  PannerNode _panNode;
  AudioBufferSourceNode _sourceNode;
  AudioClip _clip;
  bool _loop;
  num _volume;
  num _mutedVolume;
  num _pausedTime;
  num _startTime;

  AudioSource._internal(this._manager, GainNode output) {
    _panNode = _manager._context.createPanner();
    _panNode.connect(output, 0, 0);
    _volume = 1.0;
    _loop = false;
  }

  AudioSource._cloneForOneShot(AudioSource other) {
    _manager = other._manager;
    _panNode = other._panNode;
    _volume = other._volume;
    _loop = false;
  }

  /** Get the volume of this source. 0.0 <= volume <= 1.0. */
  num get volume => _volume;

  /** Get the clip for this source. */
  AudioClip get clip => _clip;

  /** Set the clip for this source. */
  void set clip(AudioClip clip) {
    // Reset paused state.
    _pausedTime = null;
    _clip = clip;
  }

  /** Set the volume for this source. */
  void set volume(num v) {
    _volume = v;
    if (_sourceNode == null) {
      return;
    }
    _volume = v;
    _sourceNode.gain.value = v;
  }

  /** Get the loop flag for this source. */
  bool get loop => _loop;

  /** Set the loop flag for this source. */
  void set loop(bool l) {
    _loop = l;
  }

  /** Is this source muted? */
  bool get mute {
    return _mutedVolume != null;
  }

  /** Mute this source */
  void set mute(bool b) {
    if (b) {
      if (_mutedVolume != null) {
        // Double mute.
        return;
      }
      _mutedVolume = volume;
      volume = 0.0;
    } else {
      if (_mutedVolume == null) {
        // Double unmute.
        return;
      }
      volume = _mutedVolume;
      _mutedVolume = null;
    }
  }

  /** Is the source currently playing  ? */
  bool get isPlaying {
    return _sourceNode == null ?
      false : _sourceNode.playbackState == AudioBufferSourceNode.PLAYING_STATE;
  }

  AudioBufferSourceNode _readyClipForPlay(AudioClip clip_) {
    // New source node
    AudioBufferSourceNode sourceNode = _manager._context.createBufferSource();
    sourceNode.loop = _loop;
    sourceNode.gain.value = _volume;
    if (clip_ != null && clip_._buffer != null) {
      sourceNode.buffer = clip_._buffer;
      sourceNode.loopStart = 0.0;
      sourceNode.loopEnd = clip_._buffer.duration;
    } else {
      sourceNode.buffer = null;
    }
    _sourceNode = sourceNode;
    _sourceNode.connect(_panNode, 0, 0);
    return sourceNode;
  }

  void _start() {
    if (_pausedTime != null) {
      // Resume playing
      _sourceNode.start(0.0, _pausedTime, 0.0);
      _pausedTime = null;
    } else {
      _sourceNode.start(0.0);
    }
  }

  void _stop() {
    if (_sourceNode != null) {
      _sourceNode.stop(0.0);
      _sourceNode = null;
    }
  }

  void _pause(AudioBufferSourceNode sourceNode) {
    if (isPlaying) {
      var now = _manager._context.currentTime;
      _pausedTime = now - _startTime;
      sourceNode.stop(0.0);
    }
  }

  /** Start playing the clip from this source */
  void play() {
    if (_pausedTime == null) {
      // Straight play
      _stop();
    }
    _readyClipForPlay(_clip);
    _start();
    _startTime = _manager._context.currentTime;
  }

  /** Pause this source */
  void pause() {
    _pause(_sourceNode);
  }

  /** Stop this source */
  void stop() {
    _stop();
    _pausedTime = null;
  }
}
