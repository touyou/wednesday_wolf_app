import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/components/card_widget.dart';
import 'package:wednesday_wolf_app/entities/special_content.dart';
import 'package:wednesday_wolf_app/pages/watch_movie_page.dart';

class SpecialContentsPage extends StatefulWidget {
  @override
  _SpecialContentsPageState createState() => _SpecialContentsPageState();
}

class _SpecialContentsPageState extends State<SpecialContentsPage> {
  static const contents = <SpecialContent>[
    SpecialContent(
      title: 'Season1公式サイト',
      contentURL: 'https://wednesday-okamikun.netlify.com/',
      thumbnailURL: 'images/season1.jpg',
      contentType: SpecialContentType.webLink,
    ),
    SpecialContent(
      title: 'Season2公式サイト',
      contentURL: 'https://wednesday-okamikun2.netlify.com/',
      thumbnailURL: 'images/season2.jpg',
      contentType: SpecialContentType.webLink,
    ),
    SpecialContent(
      title: 'オープニング',
      contentURL: 'https://wednesday-okamikun2.netlify.com/asset/video/op.mp4',
      thumbnailURL: 'images/op_thumb.jpg',
      contentType: SpecialContentType.networkMovie,
    ),
    SpecialContent(
      title: 'エンディング',
      contentURL:
          'https://firebasestorage.googleapis.com/v0/b/wednesday-wolf-app.appspot.com/o/videos%2Fed.mp4?alt=media&token=6abb2e88-c32d-4751-a093-8300b8ae23c7',
      thumbnailURL: 'images/ed_thumb.jpg',
      contentType: SpecialContentType.networkMovie,
    ),
    SpecialContent(
      title: 'AnotherStory #1',
      contentURL:
          'https://firebasestorage.googleapis.com/v0/b/wednesday-wolf-app.appspot.com/o/videos%2Fanother1.mp4?alt=media&token=027e0a52-8ee4-473d-93f2-5ada54dd8c42',
      thumbnailURL: 'images/another1.jpg',
      contentType: SpecialContentType.networkMovie,
    ),
    SpecialContent(
      title: 'AnotherStory #2',
      contentURL:
          'https://firebasestorage.googleapis.com/v0/b/wednesday-wolf-app.appspot.com/o/videos%2Fanother2.mp4?alt=media&token=ce9c4452-bf15-44f3-a317-2a0997c86389',
      thumbnailURL: 'images/another2.jpg',
      contentType: SpecialContentType.networkMovie,
    ),
    SpecialContent(
      title: 'AnotherStory #3',
      contentURL:
          'https://firebasestorage.googleapis.com/v0/b/wednesday-wolf-app.appspot.com/o/videos%2Fanother3.mp4?alt=media&token=cecff1e8-c7ae-4080-b3c0-b60b47d2bfd9',
      thumbnailURL: 'images/another3.jpg',
      contentType: SpecialContentType.networkMovie,
    ),
    SpecialContent(
      title: 'AnotherStory #4',
      contentURL:
          'https://firebasestorage.googleapis.com/v0/b/wednesday-wolf-app.appspot.com/o/videos%2Fanother4.mov?alt=media&token=22b3ffdd-02d3-4c3d-8f64-9964093772ac',
      thumbnailURL: 'images/another4.jpg',
      contentType: SpecialContentType.networkMovie,
    ),
    SpecialContent(
        title: '音楽プレイリスト',
        contentURL:
            'https://music.apple.com/jp/playlist/%E6%B0%B4%E6%9B%9C%E6%97%A5%E3%81%AE%E3%82%AA%E3%82%AA%E3%82%AB%E3%83%9F%E3%81%8F%E3%82%93%E3%81%AB%E3%81%AF%E9%A8%99%E3%81%95%E3%82%8C%E3%81%AA%E3%81%84-all-season/pl.u-AkAm8XGUlo9M1Y',
        thumbnailURL: 'images/music_thumb.jpg',
        contentType: SpecialContentType.playlist),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WolfColors.mainColor,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          scrollDirection: Axis.vertical,
          itemCount: contents.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: CardWidget(
                backImage: AssetImage(contents[index].thumbnailURL),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          contents[index].title,
                          style: WolfTextStyle.gothicBlackTitle,
                        ),
                      ],
                    )
                  ],
                ),
                onTap: () async {
                  switch (contents[index].contentType) {
                    case SpecialContentType.localMovie:
                      await Navigator.of(context)
                          .push<dynamic>(MaterialPageRoute<dynamic>(
                        settings: const RouteSettings(name: '/watchMovie'),
                        builder: (_) => WatchMoviePage(contents[index]),
                        fullscreenDialog: true,
                      ));
                      break;

                    case SpecialContentType.networkMovie:
                      await Navigator.of(context)
                          .push<dynamic>(MaterialPageRoute<dynamic>(
                        settings: const RouteSettings(name: '/watchMovie'),
                        builder: (_) => WatchMoviePage(contents[index]),
                        fullscreenDialog: true,
                      ));
                      break;

                    case SpecialContentType.webLink:
                      final url = contents[index].contentURL;
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                      break;

                    case SpecialContentType.playlist:
                      final url = contents[index].contentURL;
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                      break;
                  }
                },
              ),
            );
          }),
    );
  }
}
