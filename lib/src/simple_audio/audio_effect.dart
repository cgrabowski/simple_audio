part of simple_audio;

/**
 * Base class for audio effect that can be applied to sources.
 */
abstract class AudioEffect {
  AudioNode _apply(AudioNode inNode);
}