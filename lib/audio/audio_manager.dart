part of simple_audio;

class AudioManager {
  AudioContext _context;
  AudioDestinationNode _destination;
  AudioListener _listener;

  GainNode _masterGain;
  GainNode _musicGain;
  GainNode _fxGain;

  Map<String, AudioClip> _clips = new Map<String, AudioClip>();
  Map<String, AudioSource> _fx = new Map<String, AudioSource>();

  AudioSource _music;

  AudioListener get listener => _listener;

  AudioManager() {
    _context = new AudioContext();
    _destination = _context.destination;
    _listener = new AudioListener._internal();

    _masterGain = _context.createGain();
    _musicGain = _context.createGain();
    _fxGain = _context.createGain();

    _masterGain.connect(_destination, 0, 0);
    _musicGain.connect(_masterGain, 0, 0);
    _fxGain.connect(_masterGain, 0, 0);
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

  num get fxVolume => _fxGain.gain.value;
  void set fxVolume(num mv) {
    _fxGain.gain.value = mv;
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
    pauseFx();
    pauseMusic();
  }

  void unpauseAll() {
    unpauseFx();
    unpauseMusic();
  }

  void pauseMusic() {
    _music.pause();
  }

  void unpauseMusic() {
    _music.play();
  }

  void pauseFx() {
    _fx.forEach((k,v) {
      v.pause();
    });
  }

  void unpauseFx() {
    _fx.forEach((k,v) {
      v.play();
    });
  }

  Map<String, AudioClip> get clips => _clips;
  Map<String, AudioSource> get fxSources => _fx;
  AudioSource get musicSource => _music;

  void playfx(String fxName) {
    AudioSource source = fxSources[fxName];
    if (source == null) {
      return;
    }
    source.play();
  }

  AudioClip loadClip(String url) {
  }

  AudioSource makeSource(String name) {
  }

  void setSourceClip(String sourceName, String clipName) {
  }
}
