# simple_audio #
==============

## Introduction ##

A simple to use audio library for video games. Supports 3D positional audio.

## Features ##

* 3D positional sound emitters (AudioSource)
* Audio clips storing sound data (AudioClip)
* Looped music playback (AudioMusic)
* High level manager (AudioManager)
* Save and load snapshots which includes all settings, clips, and sources.

## Compared to Web Audio ##

The simple_audio library offers a simpler API that is targetted at video game
use cases. These use cases include games consisting of global sounds
(music, game state sound effects) and positional sounds (bullet hitting
a wall, etc).

Also, important features missing from Web Audio are present in simple_audio.
For example, simple_audio supports pausing and resuming playback of all sounds,
functionality that must be implemented on top of Web Audio.

The simple_audio library uses Web Audio internally but does not expose
the Web Audio API. This abstraction makes applications using the simple_audio
library portable to other low level audio APIs without changing the application.
Developers embedding Dart into a larger application can expose a low level audio
playback API and port simple_audio to it.

## Status: Beta ##

## Getting Started ##

1\. Add the following to your project's **pubspec.yaml** and run ```pub install```.

```yaml
dependencies:
  simple_audio:
    git: https://github.com/johnmccutchan/simpleaudio.git
```

2\. Add the correct import for your project. 

```dart
import 'package:simple_audio/simple_audio.dart';
```

# Documentation #

## API ##

[Reference Manual](http://johnmccutchan.github.com/simpleaudio/simple_audio.html)

## Samples ##

1\. audio.html

A basic sample application which plays music and a clip from a source.

2\. sound_scape.html

A demonstration of 3D positional audio. A clip can be played from any of
four sources positioned around the listener.

## Examples ##

1\. Initialize an AudioManager.

```dart
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
}
```

2\. Load a clip.

```dart
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
  // Make a clip named.
  AudioClip musicClip = audioManager.makeClip('music', '/music.mp3');
  // Load sound data into clip.
  musicClip.load();
}
```

3\. Play music

```dart
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
  // Make a clip.
  AudioClip musicClip = audioManager.makeClip('music', '/music.mp3');
  // Load sound data into clip.
  musicClip.load().then((_) {
   // Assign clip to music system.
   audioManager.music.clip = musicClip;
   // Play music.
   audioManager.music.play();
  });
}
```

4\. Create a source and place it in the scene.

```dart
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
  // Make a source called 'Source A'
  AudioSource source = audioManager.makeSource('Source A');
  // Place the source at (1, 0, 1).
  source.setPosition(1, 0, 1);
}
```

5\. Play a clip from a source.

```dart
main() {
  // Construct a new AudioManager.
  AudioManager audioManager = new AudioManager();
  // Set the base URL used when loading AudioClips.
  setBaseURL(audioManager);
  // Make a source called 'Source A'
  AudioSource source = audioManager.makeSource('Source A');
  // This source is not affected by the position of the listener.
  source.positional = false;
  
  // Make a clip.
  AudioClip clip = audioManager.makeClip('jump_sound', '/jump_sound.mp3');
  // Load sound data into clip.
  clip.load();
  
  // Play clip.
  audioManager.playClipFromSource('Source A', 'jump_sound');
}
```
