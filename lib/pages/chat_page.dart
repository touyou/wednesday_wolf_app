import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/common/utils.dart';
import 'package:wednesday_wolf_app/entities/chat_room.dart';
import 'package:wednesday_wolf_app/entities/message.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';
import 'package:wednesday_wolf_app/pages/send_message_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key, this.myId, this.opponent}) : super(key: key);

  final int myId;
  final WolfUser opponent;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatId> chatIds;

  @override
  Widget build(BuildContext context) {
    chatIds = ModalRoute.of(context).settings.arguments as List<ChatId>;

    return Scaffold(
      backgroundColor: WolfColors.baseBackground,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(color: WolfColors.baseBackground),
            child: _layoutBody(context),
          ),
          IconButton(
            padding: const EdgeInsets.only(top: 32),
            icon: Icon(Icons.arrow_back),
            color: WolfColors.whiteBackground,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]),
      ),
      floatingActionButton: chatIds.any((chatId) => chatId.isSender)
          ? FloatingActionButton(
              backgroundColor: WolfColors.mainColor,
              onPressed: () {
                showModalBottomSheet<dynamic>(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      bottom: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                              leading: Icon(Icons.chat_bubble),
                              title: const Text('メッセージ'),
                              onTap: () {
                                final progress = _makeSendingProgress()..show();
                                Navigator.of(context)
                                    .push<dynamic>(
                                  MaterialPageRoute<dynamic>(
                                    settings: const RouteSettings(
                                        name: '/sendMessage'),
                                    builder: (_) => SendMessagePage(
                                      reference: getRoomReference(chatIds[0]),
                                      fromId: widget.myId,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                )
                                    .then(
                                  (dynamic _) {
                                    progress.hide();
                                    Navigator.of(context).pop();
                                  },
                                );
                              }),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: const Text('画像'),
                            onTap: () {
                              final progress = _makeSendingProgress()..show();
                              _chooseFile().then((dynamic _) {
                                progress.hide();
                                Navigator.of(context).pop();
                              });
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  ProgressDialog _makeSendingProgress() {
    return ProgressDialog(context, type: ProgressDialogType.Normal)
      ..style(
        message: '送信中...',
        borderRadius: 10,
        backgroundColor: WolfColors.whiteBackground,
        progressWidget: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(WolfColors.mainColor),
        ),
      );
  }

  Widget _layoutBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getMessageSnapshot(chatIds[0]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildList(context, <Message>[]);
        }
        if (chatIds.length > 1) {
          final documents = snapshot.data.documents;
          return StreamBuilder<QuerySnapshot>(
            stream: getMessageSnapshot(chatIds[1]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildList(context, <Message>[]);
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
      padding: const EdgeInsets.only(top: 0, bottom: 60),
      children: <Widget>[
            Hero(
              tag: 'chatHeader${widget.opponent.id}',
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage(
                        iconFiles[widget.opponent.id][widget.opponent.imageId]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [
                          0.5,
                          0.8,
                          0.95
                        ],
                        colors: [
                          Colors.transparent,
                          WolfColors.baseBackground.withAlpha(80),
                          WolfColors.baseBackground
                        ]),
                  ),
                ),
              ),
            ),
          ] +
          (children.isEmpty
              ? <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Image.asset('images/nocontent.png'),
                  )
                ]
              : children),
    );
  }

  Widget _buildListItem(BuildContext context, Message message) {
    return Padding(
      key: ValueKey(message.reference.documentID),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _layoutMessageRow(message),
    );
  }

  Widget _layoutMessageRow(Message message) {
    final isMe = _isMyMessage(message.fromId);
    final fromUser = chatIds
        .firstWhere((element) => element.fromId == message.fromId)
        .fromUser;
    final icon = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.asset(iconFiles[fromUser.id][fromUser.imageId],
          fit: BoxFit.cover),
    );
    final contents = Container(
      constraints: const BoxConstraints(maxWidth: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: WolfColors.whiteBackground,
      ),
      child: message.type == MessageType.message
          ? GestureDetector(
              child: Text(
                message.message,
                style: WolfTextStyle.gothicBlackSmall,
              ),
              onTap: _isMyMessage(message.fromId)
                  ? () => Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                          settings: const RouteSettings(name: '/sendMessage'),
                          builder: (_) => SendMessagePage(message: message),
                          fullscreenDialog: true,
                        ),
                      )
                  : null,
              onLongPress: _isMyMessage(message.fromId)
                  ? () => showDialogMessage(context,
                              title: '投稿の削除', message: 'この投稿を削除しますか？')
                          .then((value) {
                        if (value) {
                          message.reference.delete();
                        }
                      })
                  : null,
            )
          : GestureDetector(
              child: FadeInImage.assetNetwork(
                placeholder: 'images/placeholder.png',
                image: message.photoUrl,
                fit: BoxFit.cover,
              ),
              onLongPress: _isMyMessage(message.fromId)
                  ? () => showDialogMessage(context,
                              title: '写真の削除', message: 'この写真を削除しますか？')
                          .then(
                        (value) {
                          if (value) {
                            FirebaseStorage.instance
                                .getReferenceFromUrl(message.photoUrl)
                                .then((ref) => ref.delete());
                            message.reference.delete();
                          }
                        },
                      )
                  : null,
            ),
    );
    const spacer = SizedBox(width: 16);

    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMe ? [contents, spacer, icon] : [icon, spacer, contents]);
  }

  Future _chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((imageFile) async {
      if (imageFile == null) {
        return;
      }
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

  bool _isMyMessage(int id) {
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
