part of simple_audio;

/** An [AudioSource] is analogous to a speaker in the game world.
 * It has a location and direction in the game world and can emit sound.
 * The location of the listener can be controlled with an [AudioManager].
 * You must play an [AudioClip] from the [AudioSource].
 */
class AudioSource {
  AudioManager _manager;
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

  AudioSource._internal(this._manager, GainNode output) {
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

  num get x => _x;
  num get y => _y;
  num get z => _z;
  num get xForward => _xForward;
  num get yForward => _yForward;
  num get zForward => _zForward;
  num get xUp => _xUp;
  num get yUp => _yUp;
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
