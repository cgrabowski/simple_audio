import 'dart:html';
import 'package:audio/simple_audio.dart';

AudioManager audioManager = new AudioManager();
AudioSound loopingSound = null;
String sourceName = 'Page';

String baseURL = null; // Automatically set.
String clipName = 'Wilhelm';
String clipURL = 'clips/wilhelm.ogg';
String musicClipName = 'Deeper';
String musicClipURL = 'clips/deeper.ogg';

List<AudioSource> globalSources = new List<AudioSource>();

void setBaseURL() {
  String location = window.location.href;
  location = location.substring(0, location.length-"sound_scape.html".length);
  baseURL = location;
}

String urlFor(String clip) {
  return '$baseURL/$clip';
}

void main() {
  setBaseURL();
  audioManager.makeClip(clipName);
  audioManager.makeClip(musicClipName);
  audioManager.findClip(clipName).loadFrom(urlFor(clipURL));
  audioManager.findClip(musicClipName).loadFrom(urlFor(musicClipURL));

  globalSources.add(audioManager.makeSource("front left"));
  globalSources.add(audioManager.makeSource("front right"));

  globalSources.add(audioManager.makeSource("rear left"));
  globalSources.add(audioManager.makeSource("rear right"));

  // Position sources.
  AudioSource source;
  source = audioManager.findSource("front left");
  source.setPosition(-1.0, 0.0, -1.0);
  source.setOrientation(1.0, 0.0, 1.0, 0.0, 1.0, 0.0);

  source = audioManager.findSource("front right");
  source.setPosition(1.0, 0.0, -1.0);
  source.setOrientation(-1.0, 0.0, 1.0, 0.0, 1.0, 0.0);

  source = audioManager.findSource("rear left");
  source.setPosition(-1.0, 0.0, 1.0);
  source.setOrientation(1.0, 0.0, -1.0, 0.0, 1.0, 0.0);

  source = audioManager.findSource("rear right");
  source.setPosition(1.0, 0.0, 1.0);
  source.setOrientation(-1.0, 0.0, -1.0, 0.0, 1.0, 0.0);

  query("#pause_sources")
    ..on.click.add(pauseLoop);

  query("#music_play")
    ..on.click.add(startMusic);
  query("#music_stop")
    ..on.click.add(stopMusic);
  query("#pause_music")
    ..on.click.add(pauseMusic);

  {
    InputElement ie;
    ie = query("#play0");
    ie.on.click.add((e) => playClipOn(ie.value));
  }
  {
    InputElement ie;
    ie = query("#play1");
    ie.on.click.add((e) => playClipOn(ie.value));
  }
  {
    InputElement ie;
    ie = query("#play2");
    ie.on.click.add((e) => playClipOn(ie.value));
  }
  {
    InputElement ie;
    ie = query("#play3");
    ie.on.click.add((e) => playClipOn(ie.value));
  }
  {
    InputElement ie;
    ie = query("#masterVolume");
    ie.on.change.add((e) => adjustVolume("master", ie));
  }
  {
    InputElement ie;
    ie = query("#musicVolume");
    ie.on.change.add((e) => adjustVolume("music", ie));
  }
  {
    InputElement ie;
    ie = query("#sourceVolume");
    ie.on.change.add((e) => adjustVolume("source", ie));
  }
  query("#mute")
    ..on.click.add(muteEverything);
  CanvasElement canvas = query("#stage");
  canvas.width = canvas.clientWidth;
  canvas.height = canvas.clientHeight;
  drawStage();
}

void drawStage() {
  CanvasElement canvas = query("#stage");
  CanvasRenderingContext2D context = canvas.getContext("2d");
  context.fillStyle = "#cccccc";
  context.rect(0.0, 0.0, canvas.width, canvas.height);
  context.fill();
  {
    context.strokeStyle = "#ff6600";
    num width = canvas.width;
    num step = width ~/ 20;
    num height = canvas.height;
    for (num i = 0; i <= width; i += step) {
      context.beginPath();
      context.moveTo(i, 0);
      context.lineTo(i, height);
      context.closePath();
      context.stroke();
    }
  }
  {
    context.strokeStyle = "#ff6600";
    num width = canvas.width;
    num height = canvas.height;
    num step = height ~/ 20;
    for (num i = 0; i <= height; i += step) {
      context.beginPath();
      context.moveTo(0, i);
      context.lineTo(width, i);
      context.closePath();
      context.stroke();
    }
  }
  drawListener(query("#stage"));
  drawSources(query("#stage"), globalSources);
}

void drawListener(CanvasElement canvas) {
  num width = canvas.width;
  num height = canvas.height;
  num centerWidth = width~/2;
  num centerHeight = height~/2;
  CanvasRenderingContext2D context = canvas.getContext("2d");
  context.strokeStyle = "#000000";
  context.fillStyle = "#ff6600";
  context.lineWidth = 2.0;
  context.beginPath();
  context.arc(centerWidth, centerHeight, width~/20.0, 0.0, 6.28318530, true);
  context.closePath();
  context.stroke();
  context.beginPath();
  context.arc(centerWidth, centerHeight, width~/20.0, 0.0, 6.28318530, false);
  context.closePath();
  context.fill();
}

void drawSource(CanvasElement canvas, num x, num y,
                num xForward, num yForward) {
  num width = canvas.width;
  num height = canvas.height;
  num centerWidth = width~/2;
  num centerHeight = height~/2;
  CanvasRenderingContext2D context = canvas.getContext("2d");

  context.strokeStyle = "#000000";
  context.fillStyle = "#ff6600";
  context.lineWidth = 2.0;
  context.beginPath();
  print('$x $y');
  context.arc(x+centerWidth, y+centerHeight, width~/20.0, 0.0, 6.28318530, true);
  context.closePath();
  context.stroke();
}

void drawSources(CanvasElement canvas, List<AudioSource> sources) {
  num minX, minZ, maxX, maxZ;
  sources.forEach((source) {
    if (minX == null) {
      minX = source.x;
      minZ = source.z;
      maxX = source.x;
      maxZ = source.z;
    } else {
      minX = source.x > minX ? minX : source.x;
      minZ = source.z > minZ ? minZ : source.z;
      maxX = source.x < maxX ? maxX : source.x;
      maxZ = source.z < maxZ ? maxZ : source.z;
    }
  });
  if (minX == null) {
    return;
  }

  num width = canvas.width;
  num height = canvas.height;
  num scaleX = width/(maxX-minX);
  num scaleZ = height/(maxZ-minZ);
  sources.forEach((source) {
    drawSource(canvas, source.x * scaleX, source.z * scaleZ,
        source.xForward, source.zForward);
  });
}


void playClipOn(String source) {
  audioManager.playClipFromSource(source, clipName);
}

void playOnce(Event event) {
  audioManager.playClipFromSourceIn(0.0, sourceName, clipName);
}

void playOnceDelay(Event event) {
  audioManager.playClipFromSourceIn(2.0, sourceName, clipName);
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
  audioManager.music.play(audioManager.findClip(musicClipName));
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