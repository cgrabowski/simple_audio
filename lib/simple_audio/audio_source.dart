part of simple_audio;

/** An [AudioSource] is analogous to a speaker in the game world.
 * It has a location and direction in the game world and can emit sound.
 * The location of the listener can be controlled with an [AudioManager].
 * You must play an [AudioClip] from the [AudioSource].
 */
class AudioSource {
  AudioManager _manager;
  String _name;
  GainNode _gainNode;
  PannerNode _panNode;
  List<AudioSound> _sounds;
  num _mutedVolume;
  bool _isPaused = false;
  num _x = 0.0;
  num _y = 0.0;
  num _z = 0.0;
  num _xForward = 0.0;
  num _yForward = 0.0;
  num _zForward = -1.0;
  num _xUp = 0.0;
  num _yUp = 1.0;
  num _zUp = 0.0;

  AudioSource._internal(this._manager, this._name, GainNode output) {
    _gainNode = _manager._context.createGain();
    _gainNode.connect(output, 0, 0);
    _panNode = _manager._context.createPanner();
    _panNode.connect(_gainNode, 0, 0);
    _sounds = new List<AudioSound>();
  }

  /** Get the volume of the source. 0.0 <= volume <= 1.0. */
  num get volume => _gainNode.gain.value;

  /** Set the volume for the source. All sounds being played are affected. */
  void set volume(num v) {
    _gainNode.gain.value = v;
  }

  Map toJson() {
    return {
      "_name": _name,
      "volume": _gainNode.gain.value,
      "_mutedVolume": _mutedVolume,
      "_isPaused": _isPaused,
      "_x":_x,
      "_y":_y,
      "_z":_z,
      "_xForward":_xForward,
      "_yForward":_yForward,
      "_zForward":_zForward,
      "_xUp":_xUp,
      "_yUp":_yUp,
      "_zUp":_zUp,
    };
  }

  AudioSource fromMap(Map map) {
    _gainNode.gain.value = map["volume"];
    _mutedVolume = map["_mutedVolume"];
    _isPaused = map["_isPaused"];
    _name = map["_name"];
    _x = map["_x"];
    _y = map["_y"];
    _z = map["_z"];
    setPosition(_x, _y, _z);
    _xForward = map["_xForward"];
    _yForward = map["_yForward"];
    _zForward = map["_zForward"];
    _xUp = map["_xUp"];
    _yUp = map["_yUp"];
    _zUp = map["_zUp"];
    setOrientation(_xForward, _yForward, _zForward, _xUp, _yUp, _zUp);
    return this;
  }

  /** Is the source muted? */
  bool get mute {
    return _mutedVolume != null;
  }

  /** Mute or unmute the source. */
  void set mute(bool b) {
    if (b) {
      if (_mutedVolume != null) {
        // Double mute.
        return;
      }
      _mutedVolume = volume;
      volume = 0.0;
    } else {
      if (_mutedVolume == null) {
        // Double unmute.
        return;
      }
      volume = _mutedVolume;
      _mutedVolume = null;
    }
  }

  /** Play [clip] from the source. */
  AudioSound playOnce(AudioClip clip) {
    return playOnceIn(0.0, clip);
  }

  /** Play [clip] from the source starting in [delay] seconds. */
  AudioSound playOnceIn(num delay, AudioClip clip) {
    AudioSound sound = new AudioSound._internal(this, clip, false);
    _sounds.add(sound);
    sound.play(delay);
    sound.pause = pause;

    return sound;
  }

  /** Play [clip] from the source in a loop. */
  AudioSound playLooped(AudioClip clip) {
    return playLoopedIn(0.0, clip);
  }

  /** Play [clip] from the source in a loop starting in [delay]
   * seconds.
   */
  AudioSound playLoopedIn(num delay, AudioClip clip) {
    AudioSound sound = new AudioSound._internal(this, clip, true);
    _sounds.add(sound);
    sound.play(delay);
    sound.pause = pause;
    return sound;
  }

  bool _scanSounds() {
    for (int i = _sounds.length-1; i >= 0; i--) {
      AudioSound sound = _sounds[i];
      if (sound.isFinished) {
        int last = _sounds.length-1;
        // Copy last over
        _sounds[i] = _sounds[last];
        // Pop end
        _sounds.removeLast();
        print('removing sound.');
        sound.stop();
      }
    }
  }

  /** Is the source currently paused? */
  bool get pause => _isPaused;

  /** Pause or resume the source */
  void set pause(bool b) {
    if (b) {
      if (_isPaused == true) {
        // Double pause.
        return;
      }
      _pause();
      _isPaused = true;
    } else {
      if (_isPaused == false) {
        // Double unpause.
        return;
      }
      _resume();
      _isPaused = false;
    }
  }

  void _pause() {
    _scanSounds();
    _sounds.forEach((sound) {
      sound.pause = true;
    });
  }

  void _resume() {
    _scanSounds();
    _sounds.forEach((sound) {
      sound.pause = false;
    });
  }

  /** Stop the source. Affects all playing and scheduled sounds. */
  void stop() {
    _sounds.forEach((sound) {
      sound.stop();
    });
    _scanSounds();
  }

  /** X position of the source. */
  num get x => _x;
  /** Y position of the source. */
  num get y => _y;
  /** Z position of the source. */
  num get z => _z;
  /** X forward direction of the source. */
  num get xForward => _xForward;
  /** Y forward direction of the source. */
  num get yForward => _yForward;
  /** Z forward direction of the source. */
  num get zForward => _zForward;
  /** X upward direction of the source. */
  num get xUp => _xUp;
  /** Y upward direction of the source. */
  num get yUp => _yUp;
  /** Z upward direction of the source. */
  num get zUp => _zUp;

  /** Set forward and up direction vectors of the source. Forward and up must
   * be orthogonal to each other.
   */
  void setOrientation(num xForward, num yForward, num zForward,
                      num xUp, num yUp, num zUp) {
    _xForward = xForward;
    _yForward = yForward;
    _zForward = zForward;
    _xUp = xUp;
    _yUp = yUp;
    _zUp = zUp;
    _panNode.setOrientation(xForward, yForward, zForward);
  }

  /**
   * Set the position of the source.
   */
  void setPosition(num x, num y, num z) {
    _x = x;
    _y = y;
    _z = z;
    _panNode.setPosition(x, y, z);
  }

  /**
   * Set the linear velocity of the source.
   */
  void setVelocity(num x, num y, num z) {
    _panNode.setVelocity(x, y, z);
  }
}
