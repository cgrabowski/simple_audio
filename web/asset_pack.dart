import 'dart:html';
import 'package:simple_audio/simple_audio.dart';
import 'package:simple_audio/simple_audio_asset_pack.dart';
import 'package:asset_pack/asset_pack.dart';
import 'common.dart';

// asset_pack AssetManager.
AssetManager assetManager = new AssetManager();
// simple_audio AudioManager.
AudioManager audioManager = new AudioManager();

AudioSound loopingSound = null;
String sourceName = 'Page';

String packName = 'clippack.pack';

void post_pack_loaded() {
  audioManager.music.clip = assetManager['clips.deeper'];
}

void main() {
  audioManager = new AudioManager(getDemoBaseURL());
  registerSimpleAudioWithAssetManager(audioManager, assetManager);
  assetManager.loadPack('clips', '${getDemoBaseURL()}/$packName').then((_) {
    post_pack_loaded();
    print('pack loaded.');
  });

  audioManager.makeSource(sourceName);

  query("#clip_once")
    ..onClick.listen(playOnce);
  query("#pause_all")
    ..onClick.listen(pauseAll);

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
  query("#mute")
    ..onClick.listen(muteEverything);
}

void playOnce(Event event) {
  AudioSource source = audioManager.findSource(sourceName);
  source.playOnce(assetManager['clips.wilhelm']);
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