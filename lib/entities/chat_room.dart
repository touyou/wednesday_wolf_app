import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> getMessageSnapshot(ChatId chatId) {
  return getRoomReference(chatId).snapshots();
}

CollectionReference getRoomReference(ChatId chatId) {
  return Firestore.instance
      .collection('Messages')
      .document(chatId.chatRoomId)
      .collection('messages');
}

class ChatId {
  ChatId({this.fromId, this.toId});

  final int fromId;
  final int toId;

  String get chatRoomId => '$toId-$fromId';
}
