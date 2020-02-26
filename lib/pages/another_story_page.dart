import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/pages/card_widget.dart';

class AnotherStoryPage extends StatefulWidget {
  static const thumbnailPathList = [
    "images/another1.jpg",
    "images/another2.jpg",
    "images/another3.jpg",
  ];

  static const videoPathList = [
    "videos/another1.mov",
    "videos/another2.mov",
    "videos/another3.mov",
  ];

  @override
  _AnotherStoryPageState createState() => _AnotherStoryPageState();
}

class _AnotherStoryPageState extends State<AnotherStoryPage> {
  List<VideoPlayerController> _videoPlayerList = [];

  StreamController<List<bool>> _activeMovieListController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    AnotherStoryPage.videoPathList.forEach((path) {
      final player = VideoPlayerController.asset(path)
        ..initialize().then((value) {
          setState(() {
          });
        });
      _videoPlayerList.add(player);
    });

    _activeMovieListController.stream.listen((event) {
      final activeMoviesIndex = event.where((element) => element).map((e) => event.indexOf(e)).toList();
      activeMoviesIndex.forEach((index) {
        _videoPlayerList[index].play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WolfColors.mainColor,
      ),
      body: StreamBuilder<List<bool>>(
        stream: _activeMovieListController.stream,
        initialData: [
          false,
          false,
          false
        ],
        builder: (context, snapshot) {
          var activeList = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: AnotherStoryPage.videoPathList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  activeList[index] = true;
                  _activeMovieListController.sink.add(activeList);
                },
                child: CardWidget(
                  tag: AnotherStoryPage.videoPathList[index],
                  backImage:
                  AssetImage(AnotherStoryPage.thumbnailPathList[index]),
                  child: snapshot.hasData && snapshot.data[index]
                      ? AspectRatio(
                      aspectRatio:
                      _videoPlayerList[index].value.aspectRatio,
                      child: VideoPlayer(_videoPlayerList[index]))
                      : Container(),
                  cardSize: Size(
                      MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.width * 0.8 *
                          (1 / _videoPlayerList[index].value.aspectRatio ??
                              500 / 1024)),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
