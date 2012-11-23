part of simple_audio;

/** [AudioSound] is an [AudioClip] scheduled to be played from an [AudioSource].
 * You cannot construct an instance of [AudioSound] directly, it must be
 * done by playing an [AudioClip] from an [AudioSource].
 */
class AudioSound {
  final AudioSource _source;
  final AudioClip _clip;
  final bool _loop;
  AudioBufferSourceNode _sourceNode;
  num _pausedTime;
  num _startTime;
  num _scheduledTime;

  bool get isScheduled => _sourceNode == null ? false : _sourceNode.playbackState == AudioBufferSourceNode.SCHEDULED_STATE;
  bool get isPlaying => _sourceNode == null ? false : _sourceNode.playbackState == AudioBufferSourceNode.PLAYING_STATE;
  bool get isFinished => _sourceNode == null ? false : _sourceNode.playbackState == AudioBufferSourceNode.FINISHED_STATE;

  AudioSound._internal(this._source, this._clip, this._loop) {
    _setupSourceNodeForPlayback();
  }

  void _dumpSourceNode() {
    if (_sourceNode != null) {
      print('${_sourceNode.playbackState}');
    }
  }

  void _setupSourceNodeForPlayback() {
    _sourceNode = _source._manager._context.createBufferSource();
    if (_clip != null && _clip._buffer != null) {
      _sourceNode.buffer = _clip._buffer;
      _sourceNode.loopStart = 0.0;
      _sourceNode.loopEnd = _clip._buffer.duration;
    }
    _sourceNode.loop = _loop;
    _sourceNode.connect(_source._panNode, 0, 0);
  }

  bool get paused => _pausedTime != null;

  void _stop() {
    if (_sourceNode != null) {
      _sourceNode.stop(0.0);
    }
    _sourceNode = null;
  }

  bool get pause => _pausedTime != null;

  void set pause(bool b) {
    if (b) {
      if (_pausedTime != null) {
        // Double pause.
        return;
      }
      _pause();
    } else {
      if (_pausedTime == null) {
        // Double unpause.
        return;
      }
      _resume();
    }
  }

  /**
   * Time cursor for sound. Will be negative is sound is scheduled
   * to be played. Positive if playing.
   */
  num get time {
    var now = _source._manager._context.currentTime;
    if (_pausedTime != null) {
      return _pausedTime;
    }
    return _computePausedTime();
  }

  num _computePausedTime() {
    assert(_startTime != null);
    var now = _source._manager._context.currentTime;
    var delta = now - _startTime;
    if (now < _scheduledTime) {
      // Haven't started yet.
      return now-_scheduledTime;
    }
    // Playing sound.
    if (_loop) {
      return delta % _sourceNode.buffer.duration;
    }
    return delta;
  }

  void _pause() {
    if (_startTime == null) {
      // Not started.
      return;
    }
    print('Sound.pause');
    _dumpSourceNode();
    if (_sourceNode != null) {
      _pausedTime = _computePausedTime();
      _stop();
      print('paused at $_pausedTime');
    }
  }

  void _resume() {
    if (_pausedTime == null) {
      // Not paused.
      return;
    }
    print('Sound.resume');
    _dumpSourceNode();
    _setupSourceNodeForPlayback();
    if (_pausedTime < 0.0) {
      // Schedule again.
      _pausedTime = -_pausedTime;
      print('Scheduling to play sound in $_pausedTime.');
      _scheduledTime = _source._manager._context.currentTime+_pausedTime;
      _sourceNode.start(_scheduledTime, 0.0, _sourceNode.buffer.duration);
      _startTime = _source._manager._context.currentTime;
    } else {
      print('Starting to play at offset $_pausedTime');
      _scheduledTime = _source._manager._context.currentTime;
      _sourceNode.start(_scheduledTime, // Now.
                        _pausedTime, // Offset.
                        _sourceNode.buffer.duration-_pausedTime); // Length.
      // Offset the time that start was called by the offset into clip.
      _startTime = _source._manager._context.currentTime-_pausedTime;
    }
    // Clear paused time.
    _pausedTime = null;
  }

  /** Start playing this sound */
  void play([num when=0.0]) {
    print('Sound.play');
    _dumpSourceNode();
    _stop();
    _setupSourceNodeForPlayback();
    _scheduledTime = _source._manager._context.currentTime+when;
    _sourceNode.start(_scheduledTime);
    // Called start now.
    _startTime = _source._manager._context.currentTime;
  }

  /** Stop playing this sound */
  void stop() {
    _stop();
    _startTime = null;
    _scheduledTime = null;
    _pausedTime = null;
  }
}
