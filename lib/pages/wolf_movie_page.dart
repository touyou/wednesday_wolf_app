import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';

class WolfMoviePage extends StatefulWidget {
  @override
  _WolfMoviePageState createState() => _WolfMoviePageState();
}

class _WolfMoviePageState extends State<WolfMoviePage> {
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(movieList["ed"])
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("水曜日のオオカミくんには騙されないムービーリスト"),
      ),
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      body: _layoutBody(context),
    );
  }

  Widget _layoutBody(BuildContext context) {
    return _videoPlayerController.value.initialized
        ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          )
        : Container();
  }
}
