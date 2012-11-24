part of simple_audio;

/** [AudioMusic] plays a clip from an omnidirectional [AudioSource].
 */
class AudioMusic {
  final AudioManager _manager;
  AudioSource _source;
  AudioSound _sound;
  AudioClip _clip;
  AudioMusic._internal(this._manager, GainNode output) {
    _source = new AudioSource._internal(_manager, 'music', output);
  }

  Map toJson() {
    Map map = new Map();
    map['clipName'] = _clip._name;
    return map;
  }

  void fromMap(Map map) {
    _clip = _manager.findClip(map['clipName']);
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

  AudioClip get clip => _clip;

  void set clip(AudioClip clip) {
    _clip = clip;
  }

  /** Play the music clip. The music will loop. */
  void play() {
    _stop();
    _sound = new AudioSound._internal(_source, _clip, true);
    _sound.play();
  }

  /** Stop the music. */
  void stop() {
    _stop();
  }
}