import 'dart:typed_data';
import './Song.dart';

class Song{
  String name;
  String author;
  Uint8List data;
  
  Song(this.name, this.author, this.data);

}