import 'dart:html';
import 'package:audio/simple_audio.dart';

AudioManager audioManager = new AudioManager();
String sourceName = 'Page';
String clipName = 'http://127.0.0.1:3030/C:/workspace/audio/clips/wilhelm.ogg';

void main() {

  audioManager.loadClip(clipName);
  audioManager.makeSource(sourceName);
  audioManager.setSourceClip(sourceName,clipName);

  query("#play_once")
    ..on.click.add(playOnce);
  query("#loop_start")
    ..on.click.add(startLoop);
  query("#loop_stop")
    ..on.click.add(stopLoop);
  query("#loop_pause")
    ..on.click.add(pauseLoop);
}

void playOnce(Event event) {
  audioManager.playOneShotClipFromSource(sourceName, clipName);
}

void startLoop(Event event) {
  audioManager.sources[sourceName].loop = true;
  audioManager.playSource(sourceName);
}

void stopLoop(Event event) {
  audioManager.stopSource(sourceName);
}

void pauseLoop(Event event) {
  audioManager.pauseSource(sourceName);
}