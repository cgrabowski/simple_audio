part of simple_audio;

/** [AudioMusic] plays music from an omnidirectional [AudioSource].
 */
class AudioMusic {
  final AudioManager _manager;
  AudioSource _source;
  AudioSound _sound;
  AudioMusic._internal(this._manager, GainNode output) {
    _source = new AudioSource._internal(_manager, output);
  }

  void _stop() {
    if (_sound != null) {
      _sound.stop();
      _sound = null;
    }
  }

  /** Is the music paused? */
  bool get paused => _sound == null ? false : _sound.paused;

  /** Play the music [clip]. The music will loop. */
  void play(AudioClip clip) {
    _stop();
    _sound = new AudioSound._internal(_source, clip, true);
    _sound.play();
  }

  /** Stop the music. */
  void stop() {
    _stop();
  }

  /** Pause the music. */
  void pause() {
    if (_sound != null) {
      _sound.pause();
    }
  }

  /** Resume the music. */
  void resume() {
    if (_sound != null) {
      _sound.resume();
    }
  }
}