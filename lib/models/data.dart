import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import './data.dart';
import 'dart:io' as io;

class Data {
  static final AudioPlayer audioPlayer = AudioPlayer();
  static bool isPlaying = false;
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;
  static int currentSongIndex = -1;
  
  static Future listofFiles() async {
    var directory = (await getApplicationDocumentsDirectory())!.path;
    return io.Directory("$directory/music/").listSync();
  }
}
