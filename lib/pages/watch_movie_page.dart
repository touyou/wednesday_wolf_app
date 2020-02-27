import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';

class WatchMoviePage extends StatefulWidget {
  final VideoPlayerController playerController;

  WatchMoviePage(this.playerController);

  @override
  _WatchMoviePageState createState() => _WatchMoviePageState();
}

class _WatchMoviePageState extends State<WatchMoviePage> {
  @override
  void initState() {
    super.initState();
    widget.playerController.play();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.playerController;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        left: false,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: player.value.aspectRatio ?? 0,
              child: SizedBox.expand(
                child: VideoPlayer(player),
              ),
            ),
            Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close),
                ),
                Spacer(),
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            player.value.isPlaying ? player.pause() : player.play();
                          });
                        },
                        child: player.value.isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                      ),
                    ),
                  ],
                ),
                Spacer()
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.playerController.pause();
    widget.playerController.seekTo(Duration.zero);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}
