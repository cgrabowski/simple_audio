import 'dart:html';
import 'package:simple_audio/simple_audio.dart';
import 'common.dart';

AudioManager audioManager = new AudioManager();
AudioSound loopingSound = null;
List<AudioEffect> effects;
String sourceName = 'Page';

String clipName = 'Wilhelm';
String clipURL = 'clippack/clips/wilhelm.ogg';
String effectName = 'Dungeon';
String effectURL = 'clippack/clips/dungeon_effect.ogg';
String musicClipName = 'Deeper';
String musicClipURL = 'clippack/clips/deeper.ogg';
String musicClip2Name = 'Dark Knight';
String musicClip2URL = 'clippack/clips/dark_knight.ogg';
String currentMusicClip;
String sfxrName = 'fx';

void main() {
  audioManager = new AudioManager(getDemoBaseURL());
  audioManager.makeClip(clipName, clipURL).load();
  audioManager.makeClip(musicClipName, musicClipURL).load();
  audioManager.makeClip(musicClip2Name, musicClip2URL).load();
  audioManager.music.clip = audioManager.findClip(musicClipName);
  currentMusicClip = musicClipName;

  effects = [
    new LowpassAudioEffect(audioManager, cutoffFrequency: 100.0),
    new HighpassAudioEffect(audioManager),
    new BandpassAudioEffect(audioManager),
    new LowshelfAudioEffect(audioManager, upperFrequency: 100.0, boost: 2.0),
    new HighshelfAudioEffect(audioManager, boost: 2.0),
    new PeakingAudioEffect(audioManager, boost: 2.0),
    new NotchAudioEffect(audioManager, frequency: 150),
    new AllpassAudioEffect(audioManager, centerFrequency: 400),
  ];

  audioManager.makeClip(effectName, effectURL).load().then((clip) {
    effects.add(new ConvolverAudioEffect(audioManager, clip));
  });

  audioManager.makeSource(sourceName);

  querySelector("#clip_once")
    ..onClick.listen(playOnce);
  querySelector("#clip_once_delay")
    ..onClick.listen(playOnceDelay);
  querySelector("#clip_loop_start")
    ..onClick.listen(startLoop);
  querySelector("#clip_loop_stop")
    ..onClick.listen(stopLoop);
  querySelector("#pause_sources")
    ..onClick.listen(pauseLoop);
  querySelector("#pause_all")
    ..onClick.listen(pauseAll);
  querySelector("#sfxr_once")
  ..onClick.listen(playSfxrOnce);
  querySelector("#music_play")
    ..onClick.listen(startMusic);
  querySelector("#music_stop")
    ..onClick.listen(stopMusic);
  querySelector("#pause_music")
    ..onClick.listen(pauseMusic);
  querySelector("#music_cross")
  ..onClick.listen(crossFadeLinearMusic);

  {
    InputElement ie;
    ie = querySelector("#masterVolume");
    ie.onChange.listen((e) => adjustVolume("master", ie));
  }
  {
    InputElement ie;
    ie = querySelector("#musicVolume");
    ie.onChange.listen((e) => adjustVolume("music", ie));
  }
  {
    InputElement ie;
    ie = querySelector("#sourceVolume");
    ie.onChange.listen((e) => adjustVolume("source", ie));
  }
  {
    InputElement ie;
    ie = querySelector("#sfxr_data");
    ie.onBlur.listen((e) => updateSfxrClip(ie));
    updateSfxrClip(ie);
  }
  {
    SelectElement ie;
    ie = querySelector("#filter");
    ie.onChange.listen((e) => updateFilter(ie));
  }
  querySelector("#mute")
    ..onClick.listen(muteEverything);
}

void playOnce(Event event) {
  audioManager.playClipFromSourceIn(0.0, sourceName, clipName);
}

void playOnceDelay(Event event) {
  audioManager.playClipFromSourceIn(2.0, sourceName, clipName);
}

void updateSfxrClip(InputElement el) {
  audioManager.removeClip(sfxrName);
  audioManager.makeClip(sfxrName, AudioClip.SFXR_PREFIX + el.value).load();
}

void playSfxrOnce(Event event) {
  audioManager.playClipFromSourceIn(0.0, sourceName, sfxrName);
}


void updateFilter(SelectElement el) {
  if(el.selectedIndex == 0) {
    audioManager.findSource(sourceName).clearEffects();
  } else {
    audioManager.findSource(sourceName).applyEffect(effects[el.selectedIndex - 1]);
  }
}

void startLoop(Event event) {
  if (loopingSound != null) {
    loopingSound.stop();
  }
  loopingSound = audioManager.playClipFromSource(sourceName, clipName, true);
}

void stopLoop(Event event) {
  loopingSound.stop();
}

void pauseLoop(Event event) {
  audioManager.findSource(sourceName).pause = !audioManager.findSource(sourceName).pause;
}

void startMusic(Event event) {
  audioManager.music.play();
}

bool _allPaused = false;
void pauseAll(Event event) {
  if (_allPaused) {
    audioManager.resumeAll();
    _allPaused = false;
  } else {
    audioManager.pauseAll();
    _allPaused = true;
  }
}

void stopMusic(Event event) {
  audioManager.music.stop();
}

void crossFadeLinearMusic(Event event) {

  String nextClipName;
  if(currentMusicClip == musicClipName) {
    nextClipName = musicClip2Name;
  } else {
    nextClipName = musicClipName;
  }
  print("crossfade to $nextClipName");
  AudioClip nextClip = audioManager.findClip(nextClipName);
  audioManager.music.crossFadeLinear(1, 6, nextClip);
  currentMusicClip = nextClipName;
}

void pauseMusic(Event event) {
  audioManager.music.pause = !audioManager.music.pause;
}

void adjustVolume(String volume, InputElement el) {
  num val = el.valueAsNumber;
  if (volume == "master") {
    audioManager.masterVolume = val;
  } else if (volume == "music") {
    audioManager.musicVolume = val;
  } else if (volume == "source") {
    audioManager.sourceVolume = val;
  }
  print('$volume -> $val');
}

void muteEverything(Event event) {
  audioManager.mute = !audioManager.mute;
}