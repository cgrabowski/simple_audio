import 'dart:html';
import 'package:audio/simple_audio.dart';

var clip;
AudioSource source;

void main() {
  clip = new AudioClip.load('http://127.0.0.1:3030/C:/workspace/audio/clips/wilhelm.ogg');
  source = new AudioSource();
  source.clip = clip;
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
  source.playOneShot(clip);
}

void startLoop(Event event) {
  source.loop = true;
  source.play();
}

void stopLoop(Event event) {
  source.stop();
}

void pauseLoop(Event event) {
  source.pause();
}