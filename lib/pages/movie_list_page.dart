import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/components/card_widget.dart';
import 'package:wednesday_wolf_app/pages/watch_movie_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  static const thumbnailPathList = [
    "images/another1.jpg",
    "images/another2.jpg",
    "images/another3.jpg",
    "images/ed_thumb.jpg"
  ];

  static const videoPathList = [
    "videos/another1.mov",
    "videos/another2.mov",
    "videos/another3.mov",
    "videos/ed.mp4"
  ];

  static const storyTitleList = [
    "AnotherStory #1",
    "AnotherStory #2",
    "AnotherStory #3",
    "エンディング"
  ];

  List<VideoPlayerController> _videoPlayerList = [];

  @override
  void initState() {
    super.initState();
    videoPathList.forEach((path) {
      final player = VideoPlayerController.asset(path)
        ..initialize().then((value) {
          setState(() {});
        });
      _videoPlayerList.add(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WolfColors.mainColor,
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: videoPathList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
              child: CardWidget(
                backImage: AssetImage(thumbnailPathList[index]),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Text(storyTitleList[index]),
                  ],
                ),
                onTap: () {
                  Navigator.of(context)
                      .push<dynamic>(MaterialPageRoute<dynamic>(
                    settings: const RouteSettings(name: "/watch_movie"),
                    builder: (_) => WatchMoviePage(_videoPlayerList[index]),
                    fullscreenDialog: true,
                  ));
                },
              ),
            );
          }),
    );
  }
}
