part of simple_audio;

/** [AudioSound] is an [AudioClip] being played from an [AudioSource].
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

  bool get isScheduled => _sourceNode == null ? false : _sourceNode.playbackState == AudioBufferSourceNode.SCHEDULED_STATE;
  bool get isPlaying => _sourceNode == null ? false : _sourceNode.playbackState == AudioBufferSourceNode.PLAYING_STATE;
  bool get isFinished => _sourceNode == null ? true : _sourceNode.playbackState == AudioBufferSourceNode.FINISHED_STATE;

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

  /** Start playing this sound */
  void play() {
    print('Sound.play');
    _dumpSourceNode();
    _stop();
    _setupSourceNodeForPlayback();
    _sourceNode.start(0.0);
    _startTime = _source._manager._context.currentTime;
  }

  /** Pause this sound */
  void pause() {
    if (_startTime == null) {
      return;
    }
    print('Sound.pause');
    _dumpSourceNode();
    if (_sourceNode != null) {
      var now = _source._manager._context.currentTime;
      _pausedTime = now - _startTime;
      _sourceNode.stop(0.0);
      print('paused at $_pausedTime');
    }
  }

  /** Resume playing this sound */
  void resume() {
    if (_pausedTime == null) {
      return;
    }
    print('Sound.resume');
    _dumpSourceNode();
    _stop();
    _setupSourceNodeForPlayback();
    print('resume $_pausedTime ${_sourceNode.loopStart} ${_sourceNode.loopEnd}');
    _sourceNode.start(0.0, _pausedTime, _sourceNode.buffer.duration-_pausedTime);
    _startTime = _source._manager._context.currentTime-_pausedTime;
    _pausedTime = null;
  }

  /** Stop playing this sound */
  void stop() {
    print('Sound.stop');
    _dumpSourceNode();
    _stop();
    _startTime = null;
    _pausedTime = null;
  }
}
