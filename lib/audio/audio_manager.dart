part of simple_audio;

class AudioManager {
  AudioContext _context;
  AudioDestinationNode _destination;
  AudioListener _listener;

  GainNode _masterGain;
  GainNode _musicGain;
  GainNode _sourceGain;

  Map<String, AudioClip> _clips = new Map<String, AudioClip>();
  Map<String, AudioSource> _sources = new Map<String, AudioSource>();
  List<AudioSource> _playOnceSources = new List<AudioSource>();
  AudioSource _music;

  AudioListener get listener => _listener;

  AudioManager() {
    _context = new AudioContext();
    _destination = _context.destination;
    _listener = _context.listener;

    _masterGain = _context.createGain();
    _musicGain = _context.createGain();
    _sourceGain = _context.createGain();

    _masterGain.connect(_destination, 0, 0);
    _musicGain.connect(_masterGain, 0, 0);
    _sourceGain.connect(_masterGain, 0, 0);
  }

  num get sampleRate => _context.sampleRate;

  num get musicVolume => _musicGain.gain.value;
  void set musicVolume(num mv) {
    _musicGain.gain.value = mv;
  }

  num get masterVolume => _masterGain.gain.value;
  void set masterVolume(num mv) {
    _masterGain.gain.value = mv;
  }

  num get sourceVolume => _sourceGain.gain.value;
  void set fxVolume(num mv) {
    _sourceGain.gain.value = mv;
  }

  num _mutedVolume;
  void mute() {
    _mutedVolume = _masterGain.gain.value;
  }

  void unmute() {
    if (_mutedVolume != null) {
      _masterGain.gain.value = _mutedVolume;
      _mutedVolume = null;
    }
  }

  void pauseAll() {
    pauseSources();
    pauseMusic();
  }

  void unpauseAll() {
    unpauseSources();
    unpauseMusic();
  }

  void pauseMusic() {
    _music.pause();
  }

  void unpauseMusic() {
    _music.play();
  }

  void pauseSources() {
    _sources.forEach((k,v) {
      v.pause();
    });
  }

  void unpauseSources() {
    _sources.forEach((k,v) {
      v.play();
    });
  }

  Map<String, AudioClip> get clips => _clips;
  Map<String, AudioSource> get sources => _sources;
  AudioSource get musicSource => _music;

  AudioClip loadClip(String url, [bool forceReload=false]) {
    AudioClip clip = _clips[url];
    if (clip != null && forceReload == false) {
      return clip;
    }
    clip = new AudioClip._load(this, url);
    _clips[url] = clip;
    return clip;
  }

  AudioSource makeSource(String name) {
    AudioSource source = _sources[name];
    if (source != null) {
      return source;
    }
    source = new AudioSource._internal(this, _sourceGain);
    _sources[name] = source;
    return source;
  }

  void setSourceClip(String sourceName, String clipName) {
    AudioSource source = _sources[sourceName];
    if (source == null) {
      // TODO(johnmccutchan): Determine error route.
      print('Could not find source $sourceName');
      return;
    }
    AudioClip clip = _clips[clipName];
    if (clip == null) {
      // TODO(johnmccutchan): Determine error route.
      print('Could not find clip $clipName');
      return;
    }
    source.clip = clip;
  }

  void playSource(String sourceName) {
    AudioSource source = _sources[sourceName];
    if (source == null) {
      // TODO(johnmccutchan): Determine error route.
      print('Could not find source $sourceName');
      return;
    }
    source.play();
  }

  void playOneShotClipFromSource(String sourceName, String clipName) {
    AudioSource source = _sources[sourceName];
    if (source == null) {
      // TODO(johnmccutchan): Determine error route.
      print('Could not find source $sourceName');
      return;
    }
    AudioClip clip = _clips[clipName];
    if (clip == null) {
      // TODO(johnmccutchan): Determine error route.
      print('Could not find clip $clipName');
      return;
    }
    AudioSource oneShotSource = new AudioSource._cloneForOneShot(source);
    oneShotSource.clip = clip;
    oneShotSource.play();
  }

  void stopSource(String sourceName) {
    AudioSource source = _sources[sourceName];
    if (source == null) {
      // TODO(johnmccutchan): Determine error route.
      print('Could not find source $sourceName');
      return;
    }
    source.stop();
  }

  void pauseSource(String sourceName) {
    AudioSource source = _sources[sourceName];
    if (source == null) {
      // TODO(johnmccutchan): Determine error route.
      print('Could not find source $sourceName');
      return;
    }
    source.pause();
  }


}
