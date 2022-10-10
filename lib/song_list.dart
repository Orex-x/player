import 'dart:ffi';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ListSongs extends StatefulWidget {
  const ListSongs({super.key});

  @override
  State<ListSongs> createState() => _ListSongsState();
}

class _ListSongsState extends State<ListSongs> {
  void _listofFiles() async {
    var directory = (await getExternalStorageDirectory())!.path;
    setState(() {
      var file = io.Directory("$directory/music/").listSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        type: MaterialType.transparency,
        child: Container(
          child: SizedBox(
            child: _buildMainColumn(),
          ),
        ),
      ),
    );
  }
}

Widget _buildMainColumn() => ListView(
      children: [
        _buildSongItem('Sweet Memories', 'December 29 Pre-Launch',
            Color.fromARGB(255, 47, 128, 23)),
        _buildSongItem('A Day Dream', 'December 29 Pre-Launch',
            Color.fromARGB(255, 3, 158, 162)),
        _buildSongItem('Mind Explore', 'December 29 Pre-Launch',
            Color.fromARGB(255, 240, 146, 53)),
      ],
    );

Widget _buildSongItem(String title, String description, Color color) =>
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
              onPressed: null,
              child: Icon(Icons.play_arrow_outlined),
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
