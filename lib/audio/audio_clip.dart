part of simple_audio;

class AudioClip {
  AudioManager _manager;
  AudioBuffer _buffer;
  String _url;
  bool _isReadyToPlay;

  AudioClip._load(this._manager, this._url) {
    _isReadyToPlay = false;
    var request = new HttpRequest();
    request.responseType = 'arraybuffer';
    request.on.load.add((e) => _onRequestSuccess(request));
    request.on.error.add((e) => _onRequestError(request));
    request.on.abort.add((e) => _onRequestError(request));
    request.open('GET', _url);
    request.send();
  }

  AudioClip._fromBuffer(this._manager, this._buffer) {
    _isReadyToPlay = true;
  }

  void _empty() {
    _isReadyToPlay = false;
    _buffer = null;
  }

  void _onDecode(AudioBuffer buffer) {
    if (buffer == null) {
      _empty();
      // TODO(johnmccutchan): Determine error route.
      print('Error decoding $_url');
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
    print('Error fetching $_url');
  }

  num get length {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.duration;
  }

  num get samples {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.length;
  }

  num get frequency {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.sampleRate;
  }

  bool get isReadyToPlay => _isReadyToPlay;
}
