import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/entities/special_content.dart';

class WatchMoviePage extends StatefulWidget {
  const WatchMoviePage(this.content);

  final SpecialContent content;

  @override
  _WatchMoviePageState createState() => _WatchMoviePageState();
}

class _WatchMoviePageState extends State<WatchMoviePage> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.content.contentType == SpecialContentType.localMovie) {
      _controller = VideoPlayerController.asset(widget.content.contentURL);
    } else {
      _controller = VideoPlayerController.network(widget.content.contentURL);
    }
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 1280 / 720,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
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
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
