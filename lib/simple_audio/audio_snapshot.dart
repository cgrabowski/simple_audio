part of simple_audio;

class AudioSnapshot {
  final AudioManager manager;

  AudioSnapshot(this.manager);

  /** Batch setup [AudioSource] and [AudioClip] */
  /** Description:
   *
   *
   * {
   *  '
   * }
   *
   */
  String takeSnapshot() {
    return JSON.stringify(manager);
  }

  void loadSnapshot(String snapshot) {
    Map map = JSON.parse(snapshot);
    manager.fromMap(map);
  }
}
