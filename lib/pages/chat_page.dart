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
      floatingActionButton: isOsuzuBy(chatId)
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.chat_bubble),
                          title: const Text('メッセージ'),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            settings: const RouteSettings(name: '/sendMessage'),
                            builder: (_) => SendMessagePage(
                                reference: getRoomReference(chatId)),
                            fullscreenDialog: true,
                          )),
                        ),
                        ListTile(
                          leading: Icon(Icons.image),
                          title: const Text('画像'),
                          onTap: () => chooseFile()
                              .then((value) => Navigator.of(context).pop()),
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
        child: message.type == MessageType.message
            ? ListTile(
                title: Text(message.message),
                onTap: () => print(message),
              )
            : Image.network(message.photoUrl),
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((imageFile) async {
      final fileExtension = imageFile.path.split('.').last;
      final documentReference = getRoomReference(chatId).document();
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${documentReference.documentID}.$fileExtension');
      final uploadTask = storageReference.putFile(imageFile);
      await uploadTask.onComplete;
      await storageReference.getDownloadURL().then((fileURL) {
        documentReference
            .setData(Message.newImage(photoUrl: fileURL as String).map);
      });
    });
  }
}
