part of simple_audio;

class AudioSnapshot {
  final AudioManager manager;

  AudioSnapshot(this.manager);

  /** Take a snapshot of the manager. Snapshot includes:
   * Loaded clips
   * Sources
   * Volume
   */
  String takeSnapshot() {
    return JSON.stringify(manager);
  }

  /** Load a snapshot of the manager.
   */
  void loadSnapshot(String snapshot) {
    Map map = JSON.parse(snapshot);
    manager.fromMap(map);
  }
}
