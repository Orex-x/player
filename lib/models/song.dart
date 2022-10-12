import 'dart:typed_data';

class Song {
  String name;
  String author;
  Uint8List data;

  Song(this.name, this.author, this.data);
}
