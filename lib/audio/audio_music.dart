part of simple_audio;

/** [AudioMusic] plays a clip from an omnidirectional [AudioSource].
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
  bool get pause => _sound == null ? false : _sound.pause;
  /** Pause or unpause the music */
  void set pause(bool b) {
    if (_sound != null) {
      _sound.pause = b;
    }
  }

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
}