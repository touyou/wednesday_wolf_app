import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wednesday_wolf_app/common/utils.dart';
import 'package:wednesday_wolf_app/entities/chat_room.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;

  WolfUser get me => searchWolf(currentUser);

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as FirebaseUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('水曜日のオオカミくんには騙されない。'),
      ),
      body: _layoutBody(context),
    );
  }

  Widget _layoutBody(BuildContext context) {
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
      padding: const EdgeInsets.only(top: 20),
      children: children,
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final user = WolfUser.fromSnapshot(data);

    return Padding(
      key: ValueKey(user.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          title: Text(user.name),
          trailing: Text(user.email),
          onTap: () => Navigator.of(context).pushNamed('/chat',
              arguments: me.id == 9
                  ? ChatId(fromId: user.id, toId: me.id, isSender: false)
                  : ChatId(fromId: me.id, toId: user.id, isSender: true)),
        ),
      ),
    );
  }
}
