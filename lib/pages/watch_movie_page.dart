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
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    widget.playerController.initialize().then((value) {
      widget.playerController.play();
      widget.playerController.setLooping(true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.playerController;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        left: true,
        right: true,
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: widget.playerController.value.size?.width ?? 0,
                height: widget.playerController.value.size?.height ?? 0,
                child: VideoPlayer(player),
              ),
            ),
            const Spacer(),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                    color: WolfColors.lightGray,
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
                    color: WolfColors.lightGray,
                  ),
                  const Spacer()
                ],
              ),
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
