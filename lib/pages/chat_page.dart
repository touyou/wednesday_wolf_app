import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wednesday_wolf_app/common/utils.dart';
import 'package:wednesday_wolf_app/entities/chat_room.dart';
import 'package:wednesday_wolf_app/entities/message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatId chatId;

  @override
  Widget build(BuildContext context) {
    chatId = ModalRoute.of(context).settings.arguments as ChatId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('水曜日のオオカミくんには騙されない。'),
      ),
      body: _layoutBody(context),
    );
  }

  Widget _layoutBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getMessageSnapshot(chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final children =
        snapshot.map((data) => _buildListItem(context, data)).toList();
    if (isOsuzuBy(chatId)) {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
            title: const Text('新しいメッセージを送信'),
            onTap: () => print('hello'),
          ),
        ),
      ));
    }
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: children,
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final message = Message.fromSnapshot(data);

    return Padding(
      key: ValueKey(message.reference.documentID),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          title: Text(message.message),
          onTap: () => print(message),
        ),
      ),
    );
  }
}
