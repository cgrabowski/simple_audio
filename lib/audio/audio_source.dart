part of simple_audio;

class AudioSource {
  AudioContext _context;
  AudioBufferSourceNode _sourceNode;
  num _volume;
  num _savedVolume;
  bool _loop;
  AudioClip _clip;
  num _pausedTime;
  num _startTime;

  /** Create a new AudioSource. */
  AudioSource() {
    _context = simpleAudio._context;
    _sourceNode = _context.createBufferSource();
    _connectToListener(_sourceNode);
    _volume = 1.0;
    _loop = false;
  }

  /** Create a new AudioSource ready to play [AudioClip]. */
  AudioSource.withClip(this._clip) {
    _context = simpleAudio._context;
    _sourceNode = _context.createBufferSource();
    _connectToListener(_sourceNode);
    _volume = 1.0;
    _loop = false;
  }

  void _connectToListener(AudioBufferSourceNode sourceNode) {
    sourceNode.connect(_context.destination, 0, 0);
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
    if (v > _sourceNode.gain.maxValue) {
      v = _sourceNode.gain.maxValue;
    }
    if (v < _sourceNode.gain.minValue) {
      v = _sourceNode.gain.minValue;
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
    return _savedVolume != null;
  }

  /** Mute this source */
  void set mute(bool b) {
    if (b) {
      if (_savedVolume != null) {
        // Double mute.
        return;
      }
      _savedVolume = volume;
      volume = 0.0;
    } else {
      if (_savedVolume == null) {
        // Double unmute.
        return;
      }
      volume = _savedVolume;
      _savedVolume = null;
    }
  }

  /** Is the source currently playing  ? */
  bool get isPlaying {
    return _sourceNode.playbackState == AudioBufferSourceNode.PLAYING_STATE;
  }

  AudioBufferSourceNode _readyClipForPlay(AudioClip clip_, bool oneShot) {
    // New source node
    AudioBufferSourceNode sourceNode = _context.createBufferSource();
    sourceNode.loop = oneShot == true ? false : _loop;
    sourceNode.gain.value = _volume;
    _connectToListener(sourceNode);
    if (clip_ != null) {
      sourceNode.buffer = clip_._buffer;
      sourceNode.loopStart = 0.0;
      sourceNode.loopEnd = clip_._buffer.duration;
    } else {
      sourceNode.buffer = null;
    }

    if (!oneShot) {
      _sourceNode = sourceNode;
    }
    return sourceNode;
  }

  void _start(AudioBufferSourceNode sourceNode, num resumeTime) {
    if (resumeTime != null) {
      sourceNode.start(0.0, resumeTime, 0.0);
    } else {
      sourceNode.start(0.0);
    }
  }

  void _stop(AudioBufferSourceNode sourceNode) {
    sourceNode.stop(0.0);
  }

  void _pause(AudioBufferSourceNode sourceNode) {
    if (isPlaying) {
      var now = _context.currentTime;
      _pausedTime = now - _startTime;
      sourceNode.stop(0.0);
    }
  }

  /** Start playing the clip from this source */
  void play() {
    _stop(_sourceNode);
    _readyClipForPlay(_clip, false);
    _start(_sourceNode, _pausedTime);
    _startTime = _context.currentTime;
    _pausedTime = null;
  }

  /** Play [oneShotClip] from this source. Does not affect default clip.
   * Clips played with this function cannot be paused or stopped.
   */
  void playOneShot(AudioClip oneShotClip) {
    AudioBufferSourceNode sourceNode = _readyClipForPlay(oneShotClip, true);
    _start(sourceNode, null);
  }

  /** Pause this source */
  void pause() {
    _pause(_sourceNode);
  }

  /** Stop this source */
  void stop() {
    _stop(_sourceNode);
    _pausedTime = null;
  }
}
