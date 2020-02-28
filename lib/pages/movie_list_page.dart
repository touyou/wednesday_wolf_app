import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/components/card_widget.dart';
import 'package:wednesday_wolf_app/pages/watch_movie_page.dart';

enum SpecialContentType { Movie, WebLink, Playlist }

class SpecialContentModel {
  final String title;
  final String contentURL;
  final String thumbnailURL;
  final SpecialContentType contentType;

  const SpecialContentModel(
      {this.title, this.contentURL, this.thumbnailURL, this.contentType});
}

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  static const contents = <SpecialContentModel>[
    SpecialContentModel(
      title: "Season1公式サイト",
      contentURL: "https://wednesday-okamikun.netlify.com/",
      thumbnailURL: "images/season1.jpg",
      contentType: SpecialContentType.WebLink,
    ),
    SpecialContentModel(
      title: "Season2公式サイト",
      contentURL: "https://wednesday-okamikun2.netlify.com/",
      thumbnailURL: "images/season2.jpg",
      contentType: SpecialContentType.WebLink,
    ),
    SpecialContentModel(
      title: "オープニング",
      contentURL: "videos/op.mp4",
      thumbnailURL: "images/op_thumb.jpg",
      contentType: SpecialContentType.Movie,
    ),
    SpecialContentModel(
      title: "エンディング",
      contentURL: "videos/ed.mp4",
      thumbnailURL: "images/ed_thumb.jpg",
      contentType: SpecialContentType.Movie,
    ),
    SpecialContentModel(
      title: "AnotherStory #1",
      contentURL: "videos/another1.mov",
      thumbnailURL: "images/another1.jpg",
      contentType: SpecialContentType.Movie,
    ),
    SpecialContentModel(
      title: "AnotherStory #2",
      contentURL: "videos/another2.mov",
      thumbnailURL: "images/another2.jpg",
      contentType: SpecialContentType.Movie,
    ),
    SpecialContentModel(
      title: "AnotherStory #3",
      contentURL: "videos/another3.mov",
      thumbnailURL: "images/another3.jpg",
      contentType: SpecialContentType.Movie,
    ),
    SpecialContentModel(
        title: "音楽プレイリスト",
        contentURL:
            "https://music.apple.com/jp/playlist/%E6%B0%B4%E6%9B%9C%E6%97%A5%E3%81%AE%E3%82%AA%E3%82%AA%E3%82%AB%E3%83%9F%E3%81%8F%E3%82%93%E3%81%AB%E3%81%AF%E9%A8%99%E3%81%95%E3%82%8C%E3%81%AA%E3%81%84-all-season/pl.u-AkAm8XGUlo9M1Y",
        thumbnailURL: "images/music_thumb.jpg",
        contentType: SpecialContentType.Playlist),
  ];

  List<VideoPlayerController> _videoPlayerList = [];

  @override
  void initState() {
    super.initState();
    // 動画のみをフィルタ
    contents
        .where((content) => content.contentType == SpecialContentType.Movie)
        .map((content) => content.contentURL)
        .forEach((path) {
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
          itemCount: contents.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
              child: CardWidget(
                backImage: AssetImage(contents[index].thumbnailURL),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: 4,),
                        Text(contents[index].title, style: WolfTextStyle.gothicBlackTitle,),
                      ],
                    )
                  ],
                ),
                onTap: () {
                  switch (contents[index].contentType) {
                    case SpecialContentType.Movie:
                      Navigator.of(context)
                          .push<dynamic>(MaterialPageRoute<dynamic>(
                        settings: const RouteSettings(name: "/watch_movie"),
                        builder: (_) => WatchMoviePage(_videoPlayerList[index]),
                        fullscreenDialog: true,
                      ));
                      break;

                    case SpecialContentType.WebLink:
                      break;

                    case SpecialContentType.Playlist:
                      break;
                  }
                },
              ),
            );
          }),
    );
  }
}
