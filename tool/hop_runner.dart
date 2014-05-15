library hop_runner;

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

//import '../test/test_dump_render_tree.dart' as test_dump_render_tree;

void main(List<String> args) {

  //
  // Analyzer
  //
  addTask('analyze_libs', createAnalyzerTask(['lib/simple_audio.dart',
                                                 'lib/simple_audio_asset_pack.dart']));

  addTask('analyze_web', createAnalyzerTask(['web/asset_pack.dart', 'web/audio.dart',
                                             'web/sound_scape.dart']));

  //
  // Unit test headless browser
  //
  //addTask('headless_test', createUnitTestTask(test_dump_render_tree.testCore));

  runHop(args);
}
