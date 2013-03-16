import 'dart:html';
import 'package:simple_audio/simple_audio.dart';
import 'common.dart';

AudioManager audioManager = new AudioManager();
AudioSound loopingSound = null;
String sourceName = 'Page';

String clipName = 'Wilhelm';
String clipURL = 'clippack/clips/wilhelm.ogg';
String musicClipName = 'Deeper';
String musicClipURL = 'clippack/clips/deeper.ogg';
String sfxrName = 'fx';

void main() {
  audioManager = new AudioManager(getDemoBaseURL());
  audioManager.makeClip(clipName, clipURL).load();
  audioManager.makeClip(musicClipName, musicClipURL).load();
  audioManager.music.clip = audioManager.findClip(musicClipName);
  audioManager.makeSource(sourceName);

  query("#clip_once")
    ..onClick.listen(playOnce);
  query("#clip_once_delay")
    ..onClick.listen(playOnceDelay);
  query("#clip_loop_start")
    ..onClick.listen(startLoop);
  query("#clip_loop_stop")
    ..onClick.listen(stopLoop);
  query("#pause_sources")
    ..onClick.listen(pauseLoop);
  query("#pause_all")
    ..onClick.listen(pauseAll);
  query("#sfxr_once")
  ..onClick.listen(playSfxrOnce);
  query("#music_play")
    ..onClick.listen(startMusic);
  query("#music_stop")
    ..onClick.listen(stopMusic);
  query("#pause_music")
    ..onClick.listen(pauseMusic);

  {
    InputElement ie;
    ie = query("#masterVolume");
    ie.onChange.listen((e) => adjustVolume("master", ie));
  }
  {
    InputElement ie;
    ie = query("#musicVolume");
    ie.onChange.listen((e) => adjustVolume("music", ie));
  }
  {
    InputElement ie;
    ie = query("#sourceVolume");
    ie.onChange.listen((e) => adjustVolume("source", ie));
  }
  {
    InputElement ie;
    ie = query("#sfxr_data");
    ie.onBlur.listen((e) => updateSfxrClip(ie));
    updateSfxrClip(ie);
  }
  query("#mute")
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
  audioManager.makeClip(sfxrName, AudioClip.SFXR_PREFIX.concat(el.value)).load();
}
void playSfxrOnce(Event event) {
  audioManager.playClipFromSourceIn(0.0, sourceName, sfxrName);
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