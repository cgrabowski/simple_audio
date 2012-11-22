part of simple_audio;

/** An [AudioSource] is analogous to a speaker. It has a location and direction
 * in the world and can emit sounds. The [AudioSource] by itself does nothing,
 * you must play an [AudioClip] from the [AudioSource].
 */
class AudioSource {
  AudioManager _manager;
  GainNode _gainNode;
  PannerNode _panNode;
  List<AudioSound> _sounds;
  num _mutedVolume;
  bool _isPaused;

  AudioSource._internal(this._manager, GainNode output) {
    _gainNode = _manager._context.createGain();
    _gainNode.connect(output, 0, 0);
    _panNode = _manager._context.createPanner();
    _panNode.connect(_gainNode, 0, 0);
    _sounds = new List<AudioSound>();
    _isPaused = false;
  }

  /** Is the audio source currently paused? */
  bool get isPaused => _isPaused;

  /** Get the volume of this source. 0.0 <= volume <= 1.0. */
  num get volume => _gainNode.gain.value;

  /** Set the volume for this source. All sounds being played are affected. */
  void set volume(num v) {
    _gainNode.gain.value = v;
  }

  /** Is this source muted? */
  bool get mute {
    return _mutedVolume != null;
  }

  /** Mute or unmute this source. */
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

  /** Play [clip] from this [AudioSource]. */
  AudioSound playOnce(AudioClip clip) {
    AudioSound sound = new AudioSound._internal(this, clip, false);
    _sounds.add(sound);
    sound.play();
    if (isPaused) {
      sound.pause();
    }
    return sound;
  }

  /** Okay [clip] from this [AudioSource] in a loop. */
  AudioSound playLooped(AudioClip clip) {
    AudioSound sound = new AudioSound._internal(this, clip, true);
    _sounds.add(sound);
    sound.play();
    if (isPaused) {
      sound.pause();
    }
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
        sound.stop();
      }
    }
  }

  /** Pause all sounds currently playing from this source */
  void pause() {
    _scanSounds();
    _sounds.forEach((sound) {
      sound.pause();
    });
  }

  /** Resume all paused sounds currently playing from this source */
  void resume() {
    _scanSounds();
    _sounds.forEach((sound) {
      sound.resume();
    });
  }

  /** Stop all sounds currently playing from this source */
  void stop() {
    _sounds.forEach((sound) {
      sound.stop();
    });
    _scanSounds();
  }
}
