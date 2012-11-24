# simple_audio #
==============

## Introduction ##

A simple to use audio library for video games. Supports 3D directional audio.

## Features ##

* 3D positional sound emitters (AudioSource)
* Audio clips storing sound data (AudioClip)
* Looped music playback (AudioMusic)
* High level manager (AudioManager)
* Save and load snapshots which includes all settings, clips, and sources.

## Status: Beta ##

## Getting Started ##

1\. Add the following to your project's **pubspec.yaml** and run ```pub install```.

```
dependencies:
  simple_audio:
    git: https://github.com/johnmccutchan/simpleaudio.git
```

2\. Add the correct import for your project. 

```
import 'package:simple_audio/simple_audio.dart';
```

## Document ##

[API Document](http://johnmccutchan.github.com/simpleaudio/simple_audio.html)

## Samples ##

1\. audio.html

A basic sample application which plays music and a clip from a source.

2\. sound_scape.html

A demonstration of 3D positional audio. A clip can be played from any of
four sources positioned around the listener.

## Examples ##

1\. Initialize an AudioManager.

```
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
}
```

2\. Load a clip.

```
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
  // Make a clip named.
  AudioClip musicClip = audioManager.makeClip('music');
  // Load sound data into clip.
  musicClip.loadFrom('/music.mp3');
}
```

3\. Play music

```
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
  // Make a clip.
  AudioClip musicClip = audioManager.makeClip('music');
  // Load sound data into clip.
  musicClip.loadFrom('/music.mp3');
  // Music system uses musicClip.
  audioManager.music.clip = musicClip;
  // Play music.
  audioManager.music.play();
}
```

4\. Create a source and place it in the scene.

```
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
  // Make a source called 'Source A'
  AudioSource source = audioManager.makeSource('Source A');
  // Place the source at (1, 0, 1).
  source.setPosition(1, 0, 1);
  // Point the source at the origin.
  source.setOrientation(-1, 0, -1, 0, 1, 0);
}
```

5\. Play a clip from a source.

```
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
  // Make a source called 'Source A'
  AudioSource source = audioManager.makeSource('Source A');
  // Place the source at (1, 0, 1).
  source.setPosition(1, 0, 1);
  // Point the source at the origin.
  source.setOrientation(-1, 0, -1, 0, 1, 0);
  
  // Make a clip.
  AudioClip musicClip = audioManager.makeClip('jump_sound');
  // Load sound data into clip.
  musicClip.loadFrom('/jump_sound.mp3');
  
  // Play clip.
  audioManager.playClipFromSource('Source A', 'jump_sound');
}
```
