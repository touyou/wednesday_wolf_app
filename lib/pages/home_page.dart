import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/common/utils.dart';
import 'package:wednesday_wolf_app/entities/chat_room.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';
import 'package:wednesday_wolf_app/pages/chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  VideoPlayerController _videoPlayerController;
  bool isShowDetails;

  WolfUser get me => searchWolf(currentUser);

  @override
  void initState() {
    super.initState();

    isShowDetails = false;
    _videoPlayerController = VideoPlayerController.asset('videos/ed.mp4')
      ..initialize().then((value) {
        _videoPlayerController
          ..play()
          ..setVolume(0)
          ..setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as FirebaseUser;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoPlayerController.value.size?.width ?? 0,
                height: _videoPlayerController.value.size?.height ?? 0,
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
          SizedBox.expand(
            child: Container(color: const Color.fromRGBO(39, 39, 39, 0.5)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Image.asset('images/splash_title.png'),
          ),
          Column(children: [
            const Spacer(),
            Stack(children: [
              Container(
                height: isShowDetails ? 440 : 360,
                decoration: const BoxDecoration(
                    color: WolfColors.baseBackground,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(46, 46, 46, 0.25),
                        offset: Offset(0, -4),
                        blurRadius: 12,
                        spreadRadius: 3,
                      )
                    ]),
              ),
              Column(
                children: [
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        isShowDetails = !isShowDetails;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 2),
                          Container(
                            height: 5,
                            width: 120,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(196, 196, 196, 1),
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 260,
                    child: _layoutListBody(context),
                  ),
                  Container(
                    height: isShowDetails ? 180 : 100,
                    padding: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      color: WolfColors.whiteBackground,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: isShowDetails
                          ? [
                              _layoutProfileBody(context),
                              const SizedBox(height: 16),
                              _layoutButtons(),
                            ]
                          : [_layoutProfileBody(context)],
                    ),
                  )
                ],
              ),
            ]),
          ]),
        ]),
      ),
    );
  }

  Widget iconAndText(Image image, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [image, Text(text)],
    );
  }

  Widget _layoutButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      FlatButton(
          onPressed: () {},
          child: iconAndText(Image.asset('images/user_icon.png'), '個人設定')),
      FlatButton(
          onPressed: () {},
          child: iconAndText(Image.asset('images/gift_icon.png'), 'スペシャル')),
      FlatButton(
          onPressed: () {},
          child: iconAndText(Image.asset('images/info_icon.png'), 'アプリ情報')),
    ]);
  }

  Widget _layoutProfileBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Users')
          .where('email', isEqualTo: me.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _layoutProfileRow(null);
        }

        final myUser = WolfUser.fromSnapshot(snapshot.data.documents.first);

        return _layoutProfileRow(myUser);
      },
    );
  }

  Widget _layoutProfileRow(WolfUser myUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 36),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: myUser != null
              ? Image.asset(
                  iconFiles[myUser.id][myUser.imageId],
                  fit: BoxFit.cover,
                )
              : AnimatedOpacity(
                  duration: const Duration(milliseconds: 700),
                  opacity: 0.5,
                  child: Image.asset(
                    'images/ookami-icon.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
        ),
        const SizedBox(width: 36),
        Image.asset('images/prof_user.png', height: 36),
        Text(myUser?.name ?? 'ニックネーム'),
        const SizedBox(width: 8),
        Image.asset('images/prof_course.png', height: 36),
        Text(myUser?.course ?? 'コース名'),
        const Spacer(),
      ],
    );
  }

  Widget _layoutListBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 700),
            opacity: 0.5,
            child: Image.asset(
              'images/ookami-icon.png',
              fit: BoxFit.fitHeight,
            ),
          );
        }

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final children = <Widget>[];
    WolfUser myUser;
    for (final data in snapshot) {
      final user = WolfUser.fromSnapshot(data);
      if (user.id == me.id) {
        myUser = user;
        break;
      }
    }
    for (final data in snapshot) {
      final user = WolfUser.fromSnapshot(data);
      if (!isOsuzu(user, me)) {
        continue;
      }
      children.add(_buildListItem(context, data, myUser));
    }

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      scrollDirection: Axis.horizontal,
      children: children,
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, WolfUser myUser) {
    final user = WolfUser.fromSnapshot(data);

    return Padding(
      key: ValueKey(user.id),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        child: Hero(
          tag: 'chatHeader${user.id}',
          child: Card(
            elevation: 5,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(iconFiles[user.id][user.imageId]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        onTap: () => Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder: (_) => ChatPage(myId: myUser.id, opponent: user),
            settings: RouteSettings(
              name: '/chat',
              arguments: [
                me.id != 9
                    ? ChatId(fromUser: myUser, toUser: user, isSender: true)
                    : ChatId(fromUser: user, toUser: myUser, isSender: false)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
