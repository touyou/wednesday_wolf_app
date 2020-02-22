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

  WolfUser get me => searchWolf(currentUser);

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.asset('videos/ed.mp4')
      ..initialize().then((value) {
        _videoPlayerController.play();
        _videoPlayerController.setVolume(0);
        _videoPlayerController.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as FirebaseUser;

    return Scaffold(
      body: Stack(children: [
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
              height: 360,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(221, 224, 227, 1),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  height: 5,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(196, 196, 196, 1),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Container(
                  height: 260,
                  child: _layoutListBody(context),
                ),
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
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
    );
  }

  Widget _layoutProfileBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Users')
          .where('email', isEqualTo: me.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final myUser = WolfUser.fromSnapshot(snapshot.data.documents.first);

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
              child: Image.asset(
                iconFiles[myUser.id][myUser.imageId],
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 36),
            Image.asset('images/prof_user.png', height: 36),
            Text(myUser.name),
            const SizedBox(width: 8),
            Image.asset('images/prof_course.png', height: 36),
            Text(myUser.course),
            const Spacer(),
          ],
        );
      },
    );
  }

  Widget _layoutListBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final children = <Widget>[];
    for (final data in snapshot) {
      final user = WolfUser.fromSnapshot(data);
      if (!isOsuzu(user, me)) {
        continue;
      }
      children.add(_buildListItem(context, data));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      scrollDirection: Axis.horizontal,
      children: children,
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final user = WolfUser.fromSnapshot(data);

    return Padding(
      key: ValueKey(user.id),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        child: Container(
          constraints: BoxConstraints.tight(const Size(150, 200)),
          child: Card(
            elevation: 5,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.asset(
              iconFiles[user.id][user.imageId],
              fit: BoxFit.cover,
            ),
          ),
        ),
        onTap: () => Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder: (_) => ChatPage(myId: me.id),
            settings: RouteSettings(
              name: '/chat',
              arguments: [
                me.id != 9
                    ? ChatId(fromId: me.id, toId: user.id, isSender: true)
                    : ChatId(fromId: user.id, toId: me.id, isSender: false)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
