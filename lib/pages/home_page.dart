import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/common/utils.dart';
import 'package:wednesday_wolf_app/components/card_widget.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';
import 'package:wednesday_wolf_app/pages/appinfo_page.dart';
import 'package:wednesday_wolf_app/pages/chat_page.dart';
import 'package:wednesday_wolf_app/pages/setting_page.dart';
import 'package:wednesday_wolf_app/pages/special_contents_page.dart';

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
      backgroundColor: WolfColors.whiteBackground,
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
            child: Container(color: WolfColors.overlayBlack),
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
                        color: WolfColors.shadowBlack,
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
                              color: WolfColors.mediumGray,
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
                    child: _layoutProfileBody(context),
                  )
                ],
              ),
            ]),
          ]),
        ]),
      ),
    );
  }

  Widget _iconAndText(Widget image, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        image,
        Text(
          text,
          style: WolfTextStyle.gothicBlackSmall,
        )
      ],
    );
  }

  Widget _layoutButtons(WolfUser myUser) {
    var children = <Widget>[];
    if (myUser.id != 10) {
      children = [
        FlatButton(
            onPressed: () {
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  settings: const RouteSettings(name: '/settings'),
                  builder: (_) => SettingPage(me: myUser),
                  fullscreenDialog: true,
                ),
              );
            },
            child: _iconAndText(Icon(Icons.person_outline), '個人設定')),
      ];
    }
    children += [
      FlatButton(
          onPressed: () {
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              settings: const RouteSettings(name: '/another_story'),
              builder: (_) => SpecialContentsPage(),
              fullscreenDialog: true,
            ));
          },
          child: _iconAndText(Icon(Icons.redeem), 'スペシャル')),
      FlatButton(
          onPressed: () {
            Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                settings: const RouteSettings(name: '/appinfo'),
                builder: (_) => AppInfoPage(),
                fullscreenDialog: true,
              ),
            );
          },
          child: _iconAndText(Icon(Icons.info_outline), 'アプリ情報')),
    ];
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: children);
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

        return Column(
          children: isShowDetails
              ? [
                  _layoutProfileRow(myUser),
                  const SizedBox(height: 16),
                  _layoutButtons(myUser),
                ]
              : [_layoutProfileRow(myUser)],
        );
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
        Icon(Icons.person),
        const SizedBox(width: 4),
        Text(
          myUser?.name ?? 'ニックネーム',
          style: WolfTextStyle.gothicBlackSmall,
        ),
        const SizedBox(width: 8),
        Icon(Icons.flag),
        const SizedBox(width: 4),
        Text(
          myUser?.course ?? 'コース名',
          style: WolfTextStyle.gothicBlackSmall,
        ),
        const Spacer(),
      ],
    );
  }

  Widget _layoutListBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Users').orderBy('id').snapshots(),
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
      child: Hero(
        tag: 'chatHeader${user.id}',
        child: CardWidget(
          backImage: AssetImage(iconFiles[user.id][user.imageId]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: [
                  const SizedBox(width: 4),
                  Icon(Icons.person, size: 12, color: WolfColors.darkGray),
                  const SizedBox(width: 2),
                  Text(user.name, style: WolfTextStyle.gothicBlackName),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 4),
                  Icon(Icons.flag, size: 12, color: WolfColors.darkGray),
                  const SizedBox(width: 2),
                  Text(user.course, style: WolfTextStyle.gothicBlackName),
                ],
              ),
            ],
          ),
          onTap: () => Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
              builder: (_) => ChatPage(myId: myUser.id, opponent: user),
              settings: RouteSettings(
                name: '/chat',
                arguments: getChatList(user, myUser),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
