part of simple_audio;

class AudioMusic {
  AudioManager _manager;
  AudioSource _source;

  AudioMusic._internal(this._manager, GainNode output) {
    _source = new AudioSource._internal(_manager, output);
    // Music loops.
    _source.loop = true;
  }

  void play() {
    _source.play();
  }

  void stop() {
    _source.stop();
  }

  void pause() {
    _source.pause();
  }

  AudioClip get clip => _source._clip;

  void set clip(AudioClip clip) {
    _source._clip = clip;
  }

  bool get mute => _source.mute;
  void set mute(bool b) {
    _source.mute = b;
  }

  bool get isPlaying => _source.isPlaying;
}