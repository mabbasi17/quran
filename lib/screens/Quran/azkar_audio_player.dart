import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AzkarAudioPlayer extends StatefulWidget {
  const AzkarAudioPlayer({Key? key}) : super(key: key);

  @override
  State<AzkarAudioPlayer> createState() => _AzkarAudioPlayerState();
}

class _AzkarAudioPlayerState extends State<AzkarAudioPlayer> {
  String? currentPath;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  List azkarList = [
    {
      "name": "Mathurat-Abends",
      "path": "assets/audio/masa.mpeg",
      "isPlaying": false
    },
    {
      "name": "Mathurat-Früh",
      "path": "assets/audio/sabah.mpeg",
      "isPlaying": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: azkarList
          .map((e) => ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
              onPressed: () {
                if (currentPath == e["path"]) {
                  if (e["isPlaying"]) {
                    _audioPlayer?.pause();
                  } else {
                    setState(() {
                      e["isPlaying"] = true;
                    });
                    _audioPlayer?.play().whenComplete(() {
                      setState(() {
                        e["isPlaying"] = false;
                      });
                    });
                  }
                } else {
                  setState(() {
                    e["isPlaying"] = true;
                    currentPath = e["path"];
                  });
                  _audioPlayer?.stop().then((_) => _audioPlayer
                      ?.setAsset(e["path"])
                      .then((v) => _audioPlayer?.play().whenComplete(() {
                            setState(() {
                              e["isPlaying"] = false;
                            });
                          })));
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e["name"], style: TextStyle(height: 2)),
                  Icon(currentPath == e["path"] && e["isPlaying"]
                      ? Icons.pause
                      : Icons.play_arrow),
                ],
              )))
          .toList(),
    );
  }
}
