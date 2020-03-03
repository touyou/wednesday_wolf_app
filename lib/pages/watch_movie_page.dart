import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';

class WatchMoviePage extends StatefulWidget {
  const WatchMoviePage(this.playerController);

  final VideoPlayerController playerController;

  @override
  _WatchMoviePageState createState() => _WatchMoviePageState();
}

class _WatchMoviePageState extends State<WatchMoviePage> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.playerController,
      aspectRatio: 1280 / 720,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.playerController;

    return Scaffold(
      backgroundColor: WolfColors.baseBackground,
      appBar: AppBar(
        backgroundColor: WolfColors.mainColor,
      ),
      body: SafeArea(child: Chewie(controller: _chewieController)),
    );
  }

  @override
  void dispose() {
    widget.playerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
