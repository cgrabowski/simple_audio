part of simple_audio;

/** An [AudioClip] stores sound data. It can be played by an [AudioSource]
 * or played with [AudioMusic].
 */
class AudioClip {
  final AudioManager _manager;
  final String name;
  AudioBuffer _buffer;
  String _url;
  bool _isReadyToPlay;

  AudioClip._internal(this._manager, this.name) {
    _isReadyToPlay = false;
  }

  void _empty() {
    _isReadyToPlay = false;
    _buffer = null;
  }

  void _onDecode(AudioBuffer buffer) {
    if (buffer == null) {
      _empty();
      // TODO(johnmccutchan): Determine error route.
      print('Error decoding $name');
      return;
    }
    _buffer = buffer;
    _isReadyToPlay = true;
    print('ready');
  }


  void _onRequestSuccess(HttpRequest request) {
    var response = request.response;
    _manager._context.decodeAudioData(response,
                                      _onDecode,
                                      _onDecode);
  }

  void _onRequestError(HttpRequest request) {
    _empty();
    // TODO(johnmccutchan): Determine error route.
    print('Error fetching $name');
  }

  void loadFrom(String url) {
    var request = new HttpRequest();
    request.responseType = 'arraybuffer';
    request.on.load.add((e) => _onRequestSuccess(request));
    request.on.error.add((e) => _onRequestError(request));
    request.on.abort.add((e) => _onRequestError(request));
    request.open('GET', url);
    request.send();
  }

  /** Length of audio clip in seconds */
  num get length {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.duration;
  }

  /** Length of audio clip in samples */
  num get samples {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.length;
  }

  /** Samples per second */
  num get frequency {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.sampleRate;
  }

  /** Is the audio clip ready to be played ? */
  bool get isReadyToPlay => _isReadyToPlay;
}
