import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wednesday_wolf_app/common/utils.dart';
import 'package:wednesday_wolf_app/entities/chat_room.dart';
import 'package:wednesday_wolf_app/entities/message.dart';
import 'package:wednesday_wolf_app/pages/send_message_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key, this.myId}) : super(key: key);

  final int myId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatId> chatIds;

  @override
  Widget build(BuildContext context) {
    chatIds = ModalRoute.of(context).settings.arguments as List<ChatId>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('水曜日のオオカミくんには騙されない。'),
      ),
      body: _layoutBody(context),
      floatingActionButton: chatIds.any((chatId) => chatId.isSender)
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<dynamic>(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.chat_bubble),
                          title: const Text('メッセージ'),
                          onTap: () => Navigator.of(context)
                              .push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                  settings:
                                      const RouteSettings(name: '/sendMessage'),
                                  builder: (_) => SendMessagePage(
                                    reference: getRoomReference(chatIds[0]),
                                    fromId: widget.myId,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              )
                              .then((dynamic _) => Navigator.of(context).pop()),
                        ),
                        ListTile(
                          leading: Icon(Icons.image),
                          title: const Text('画像'),
                          onTap: () => chooseFile()
                              .then((dynamic _) => Navigator.of(context).pop()),
                        )
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _layoutBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getMessageSnapshot(chatIds[0]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        if (chatIds.length > 1) {
          final documents = snapshot.data.documents;
          return StreamBuilder<QuerySnapshot>(
            stream: getMessageSnapshot(chatIds[1]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LinearProgressIndicator();
              }
              return _buildList(context,
                  _convertMessageList(documents + snapshot.data.documents));
            },
          );
        }
        return _buildList(
            context, _convertMessageList(snapshot.data.documents));
      },
    );
  }

  Widget _buildList(BuildContext context, List<Message> snapshot) {
    final children =
        snapshot.map((data) => _buildListItem(context, data)).toList();
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: children,
    );
  }

  Widget _buildListItem(BuildContext context, Message message) {
    return Padding(
      key: ValueKey(message.reference.documentID),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: isMyMessage(message.fromId)
              ? Border.all(color: Colors.grey)
              : Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(5),
        ),
        child: message.type == MessageType.message
            ? ListTile(
                title: Text(message.message),
                onTap: () => print(message),
                onLongPress: () {
                  if (isMyMessage(message.fromId)) {
                    showDialogMessage(context,
                            title: '投稿の削除', message: 'この投稿を削除しますか？')
                        .then((value) {
                      if (value) {
                        message.reference.delete();
                      }
                    });
                  }
                },
              )
            : GestureDetector(
                child: Image.network(message.photoUrl),
                onLongPress: () {
                  if (isMyMessage(message.fromId)) {
                    showDialogMessage(context,
                            title: '写真の削除', message: 'この写真を削除しますか？')
                        .then((value) {
                      if (value) {
                        FirebaseStorage.instance
                            .getReferenceFromUrl(message.photoUrl)
                            .then((ref) => ref.delete());
                        message.reference.delete();
                      }
                    });
                  }
                },
              ),
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((imageFile) async {
      final fileExtension = imageFile.path.split('.').last;
      final documentReference = getRoomReference(chatIds[0]).document();
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${documentReference.documentID}.$fileExtension');
      final uploadTask = storageReference.putFile(imageFile);
      await uploadTask.onComplete;
      await storageReference.getDownloadURL().then((dynamic fileURL) {
        documentReference.setData(Message.newImage(
          photoUrl: fileURL as String,
          fromId: widget.myId,
        ).map);
      });
    });
  }

  bool isMyMessage(int id) {
    return id == widget.myId;
  }

  List<Message> _convertMessageList(List<DocumentSnapshot> list) {
    final messageList = list
        .map((snapshot) => Message.fromSnapshot(snapshot))
        .toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messageList;
  }
}
