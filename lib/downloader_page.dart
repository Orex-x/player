import 'dart:convert';
import 'dart:io';
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

  String getIdSongByLink(String link) {
    var mass = link.split('/');
    switch (mass.length) {
      case 5:
        return mass[4];
      case 7:
        return mass[6];
    }

    return "";
  }

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
                  final uri = Uri.https('32fd-62-217-191-21.eu.ngrok.io',
                      '/YandexMusic/GetSongById/', {'idSong': getIdSongByLink(link)});

                  var response = await http.get(uri);

                  var decodedResponse = jsonDecode(response.body);

                  var name = decodedResponse["name"];
                  var data = decodedResponse["data"];

                  var base64 = base64Decode(data);

                  var appDocDir = await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;
                  var file = new File('$appDocPath\\$name.mp3');

                  file.writeAsBytes(base64);
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
