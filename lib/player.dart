import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'models/data.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void dispose() {
    //Data.audioPlayer.dispose();
    super.dispose();
  }

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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://avatarko.ru/img/kartinka/1/avatarko_anonim.jpg',
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Test song',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'autor',
                style: TextStyle(fontSize: 20),
              ),
              Slider(
                min: 0,
                max: Data.duration.inSeconds.toDouble(),
                value: Data.position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  if (!mounted) return;
                  await Data.audioPlayer.seek(position);
                  await Data.audioPlayer.resume();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(Data.position)),
                    Text(formatTime(Data.duration - Data.position)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon: Data.isPlaying
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                  iconSize: 50,
                  onPressed: () async {
                    if (!mounted) return;
                    if (Data.isPlaying) {
                      await Data.audioPlayer.pause();
                    } else {
                      await Data.audioPlayer.resume();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatTime(Duration duration) {
  String twoDigids(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigids(duration.inHours);
  final minutes = twoDigids(duration.inMinutes.remainder(60));
  final seconds = twoDigids(duration.inSeconds.remainder(60));

  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}
