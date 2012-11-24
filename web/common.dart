library common;
import 'dart:html';
import 'package:simple_audio/simple_audio.dart';

void setBaseURL(AudioManager manager) {
  String location = window.location.href;
  int slashIndex = location.lastIndexOf('/');
  if (slashIndex < 0) {
    manager.baseURL = '';
  } else {
    manager.baseURL = location.substring(0, slashIndex);
  }
}

