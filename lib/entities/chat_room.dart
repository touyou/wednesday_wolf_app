import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';

Stream<QuerySnapshot> getMessageSnapshot(ChatId chatId) {
  return getRoomReference(chatId).orderBy('timestamp').snapshots();
}

CollectionReference getRoomReference(ChatId chatId) {
  return Firestore.instance
      .collection('Messages')
      .document(chatId.chatRoomId)
      .collection('messages');
}

class ChatId {
  ChatId({this.fromUser, this.toUser, this.isSender});

  final WolfUser fromUser;
  final WolfUser toUser;
  final bool isSender;

  int get toId => toUser.id;
  int get fromId => fromUser.id;

  String get chatRoomId => '$toId-$fromId';
}
