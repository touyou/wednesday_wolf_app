import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null || map['photo_url'] != null),
        message = map['message'] as String,
        photoUrl = map['photo_url'] as Uri;

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  final String message;
  final Uri photoUrl;
  final DocumentReference reference;

  MessageType get type => message != null
      ? MessageType.message
      : photoUrl != null ? MessageType.photo : MessageType.unknown;
}

enum MessageType { message, photo, unknown }

class MessageRoom {
  MessageRoom.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['fromId'] != null),
        assert(map['toId'] != null),
        fromId = map['fromId'] as int,
        toId = map['toId'] as int;

  MessageRoom.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  final int fromId;
  final int toId;
  final DocumentReference reference;
}
