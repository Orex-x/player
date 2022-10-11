import 'dart:ffi';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'models/data.dart';

class ListSongs extends StatefulWidget {
  const ListSongs({super.key});

  @override
  State<ListSongs> createState() => _ListSongsState();
}

class _ListSongsState extends State<ListSongs> {
  List<io.FileSystemEntity> listSongs = [];

  @override
  void initState() {
    super.initState();

    Data.audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        Data.isPlaying = state == PlayerState.playing;
      });
    });
    Data.audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() {
        Data.duration = newDuration;
      });
    });
    Data.audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() {
        Data.position = newPosition;
      });
    });

    setList();
  }

  void setList() async {
    var data = await Data.listofFiles();
    setState(() {
      listSongs = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        type: MaterialType.transparency,
        child: _buildMainColumn(listSongs),
      ),
    );
  }
}

Widget _buildMainColumn(List<io.FileSystemEntity> list) => ListView.builder(
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      var file = list[index];
      var path = file.path;
      var filename = path.split("/").last;
      return _buildSongItem(filename, filename, Colors.deepOrange, path, index);
    });

Widget _buildSongItem(String title, String description, Color color,
        String path, int index) =>
    Container(
      padding: EdgeInsets.only(
        top: 10,
        left: 30,
        right: 30,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: new BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.circular(15),
            ),
            child: new TextButton(
              onPressed: () async {
                await Data.audioPlayer.setSourceUrl(path);
                if (Data.currentSongIndex != index) {
                  await Data.audioPlayer.resume();
                } else {
                  if (Data.isPlaying) {
                    await Data.audioPlayer.pause();
                  } else {
                    await Data.audioPlayer.resume();
                  }
                }
                Data.currentSongIndex = index;
              },
              child: index != Data.currentSongIndex
                  ? Icon(Icons.play_arrow)
                  : Data.isPlaying
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 30,
            alignment: Alignment.centerRight,
            child: Icon(Icons.menu),
          ),
        ],
      ),
    );
