import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';

class WatchMoviePage extends StatefulWidget {
  const WatchMoviePage(this.playerController);

  final VideoPlayerController playerController;

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
      backgroundColor: WolfColors.baseBackground,
      body: SafeArea(
        top: false,
        bottom: false,
        left: false,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: player.value.aspectRatio ?? 0,
              child: VideoPlayer(player),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                    color: WolfColors.darkGray,
                  ),
                ),
                const Spacer(),
                IconButton(
                  iconSize: 32,
                  onPressed: () {
                    setState(() {
                      player.value.isPlaying ? player.pause() : player.play();
                    });
                  },
                  icon: player.value.isPlaying
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                  color: WolfColors.darkGray,
                ),
                const Spacer()
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
