part of simple_audio;

/** An [AudioClip] stores sound data. To play an [AudioClip],
 * see [AudioSource], [AudioMusic], and [AudioManager].
 */
class AudioClip {
  final AudioManager _manager;
  final String name;
  AudioBuffer _buffer;
  bool _hasError = false;
  String _errorString = '';
  bool _isReadyToPlay = false;

  AudioClip._internal(this._manager, this.name);

  void _empty() {
    _isReadyToPlay = false;
    _buffer = null;
  }

  /** Does the clip have an error? */
  bool get hasError => _hasError;
  /** Human readable error */
  String get errorString => _errorString;

  void _clearError() {
    _hasError = false;
    _errorString = 'OK';
  }

  void _setError(String error) {
    _hasError = true;
    _errorString = error;
  }

  void _onDecode(AudioBuffer buffer, Completer<bool> completer) {
    if (buffer == null) {
      _empty();
      _setError('Error decoding buffer.');
      completer.complete(false);
      return;
    }
    _clearError();
    _buffer = buffer;
    _isReadyToPlay = true;
    print('ready');
    completer.complete(true);
  }

  void _onRequestSuccess(HttpRequest request, Completer<bool> completer) {
    var response = request.response;
    _manager._context.decodeAudioData(response,
                                      (b) => _onDecode(b, completer),
                                      (b) => _onDecode(b, completer));
  }

  void _onRequestError(HttpRequest request, Completer<bool> completer) {
    _empty();
    _setError('Error fetching data');
    completer.complete(false);
  }

  /** Fetch [url] and decode it into the clip buffer.
   * Returns a [Future<bool>] which completes to true if the clip was
   * succesfully loaded and decoded. Will complete to false if the clip
   * could not be loaded or could not be decoded. On error,
   * check [hasError] and [errorString].
   */
  Future<bool> loadFrom(String url) {
    var request = new HttpRequest();
    var completer = new Completer<bool>();
    request.responseType = 'arraybuffer';
    request.on.load.add((e) => _onRequestSuccess(request, completer));
    request.on.error.add((e) => _onRequestError(request, completer));
    request.on.abort.add((e) => _onRequestError(request, completer));
    request.open('GET', url);
    request.send();
    return completer.future;
  }

  /** Make an empty clip buffer with [numberOfSampleFrames] in
   * each [numberOfChannels]. The buffer plays at a rate of [sampleRate].
   * The duration (in seconds) of the buffer is equal to:
   * numberOfSampleFrames / sampleRate
   */
  void makeBuffer(num numberOfSampleFrames, num numberOfChannels, num sampleRate) {
    _buffer = _manager._context.createBuffer(numberOfChannels,
                                             numberOfChannels,
                                             sampleRate);
  }

  /** Return the sample frames array for [channel]. Assuming a stereo setup,
   * the left and right speakers are mapped to channel 0 and 1 respectively. */
  Float32Array getSampleFramesForChannel(num channel) {
    if (_buffer == null) {
      return null;
    }
    return _buffer.getChannelData(channel);
  }

  /** Number of clip channels. */
  num get numberOfChannels {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.numberOfChannels;
  }

  /** Length of clip in seconds. */
  num get length {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.duration;
  }

  /** Length of clip in samples. */
  num get samples {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.length;
  }

  /** Samples per second. */
  num get frequency {
    if (_buffer == null) {
      return 0;
    }
    return _buffer.sampleRate;
  }

  /** Is the clip ready to be played? */
  bool get isReadyToPlay => _isReadyToPlay;
}
