# simple_audio #
==============

## Introduction ##

A simple to use audio library for video games. Supports 3D positional audio.

## Features ##

* 3D positional sound emitters (AudioSource)
* Audio clips storing sound data loaded from audio files (AudioClip)
* Looped music playback (AudioMusic)
* High level manager (AudioManager)
* Save and load snapshots which includes all settings, clips, and sources.

## Why simple_audio over Web Audio? ##

1\. simple_audio offers a much smaller API designed for games.

Web Audio is a powerful audio processing system. Web Audio has more than
20 classes with many properties and methods in each. Compare that with
the 6 classes in simple_audio. Because the API is targetting game applications
you'll end up writing far fewer lines of code with simple_audio.

2\. Pause and resume

Web Audio does not have the ability to pause and resume sounds. Don't spend 
time implementing pause and resume on top of Web Audio, just use simple_audio.

3\. Easy loading of sound data

Using Web Audio you need to write around 20 lines of code with multiple
callback functions to load a single MP3 file. With simple_audio you only
write two:

```dart
  // Make a clip named 'music'.
  AudioClip musicClip = audioManager.makeClip('music', '/music.mp3');
  // Load sound data into clip.
  musicClip.load();
```

4\. Snapshots

The simple_audio library supports saving its state in a snapshot. The
saved state includes all audio clips, sources, and other settings. This
snapshot can be loaded the next time the application starts.

5\. Portability

Web Audio is a low level sound API that is only available in the browser.
Embedded applications, console applications, and mobile applications do not
have access to the Web Audio API. By targetting simple_audio your game
can be more easily ported to other platforms.


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
  // Make a clip named 'music'.
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
