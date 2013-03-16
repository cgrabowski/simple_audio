/*
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

library simple_audio_asset_pack;
import 'dart:web_audio';
import 'dart:async';
import 'package:simple_audio/simple_audio.dart';
import 'package:asset_pack/asset_pack.dart';

class _AssetLoaderClip extends AssetLoader {
  final AudioManager audioManager;
  _AssetLoaderClip(this.audioManager);

  Future<dynamic> load(Asset asset) {
    AudioClip clip = new AudioClip.external(audioManager, asset.name,
                                            asset.url);
    return clip.load();
  }

  void delete(dynamic arg) {
  }
}

class _AssetImporterClip extends AssetImporter {
  void initialize(Asset asset) {
    asset.imported = null;
  }
  Future<Asset> import(dynamic payload, Asset asset) {
    asset.imported = payload;
    return new Future.immediate(asset);
  }
  void delete(dynamic imported) {
    if (imported != null) {
      // NO-OP. Handled in the loader.
    }
  }
}

/** Register the [simple_audio] audio manager with the [asset_pack]
 * asset manager. After calling this function, the asset manager
 * will be able to load clips.
 */
void registerSimpleAudioWithAssetManager(AudioManager audioManager,
                                         AssetManager assetManager) {
  assetManager.importers['audioclip'] = new _AssetImporterClip();
  assetManager.loaders['audioclip'] = new _AssetLoaderClip(audioManager);
}