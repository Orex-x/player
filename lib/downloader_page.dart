import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class DownloaderPage extends StatefulWidget {
  const DownloaderPage({super.key});

  @override
  State<DownloaderPage> createState() => _DownloaderPageState();
}

class _DownloaderPageState extends State<DownloaderPage> {
  String link = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        type: MaterialType.transparency,
        child: Container(
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    link = value;
                  });
                },
              ),
              IconButton(
                onPressed: () async {

                  final uri = Uri.https('56ae-62-217-191-21.eu.ngrok.io', '/YandexMusic/GetSongById/', {'idSong': '89287667'});
                  var response = await http.get(uri);
                  var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
                  var decode = utf8.decode(response.bodyBytes);

                  var name = decodedResponse["name"];
                  var data = decodedResponse["data"];
                  List<int> bytes = utf8.encode(data);

                  var appDocDir = await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;
                  var file = new File('$appDocPath\\test123.mp3');
                  file.writeAsBytes(bytes, flush: true);

                  /*List<int> dataB = utf8.encode(data);
                  Uint8List bytes = Uint8List.fromList(dataB);
                  ByteData byteData = ByteData.sublistView(bytes);
                  int value = byteData.getUint16(0, Endian.big);



                  var appDocDir = await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;
                  var file = new File('$appDocPath\\$name.mp3');
                  file.writeAsBytes(bytes);
                  var str = "";*/
                },
                icon: Icon(Icons.download),
              )
            ],
          ),
        ),
      ),
    );
  }
}
