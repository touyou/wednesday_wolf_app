import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message.newMessage({this.message, this.fromId})
      : photoUrl = null,
        reference = null,
        timestamp = null;

  Message.newImage({this.photoUrl, this.fromId})
      : message = null,
        reference = null,
        timestamp = null;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null || map['photo_url'] != null),
        assert(map['from_id'] != null),
        message = map['message'] as String,
        photoUrl = map['photo_url'] as String,
        fromId = map['from_id'] as int,
        timestamp = map['timestamp'] as Timestamp;

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  final String message;
  final String photoUrl;
  final int fromId;
  final Timestamp timestamp;
  final DocumentReference reference;

  MessageType get type => message != null
      ? MessageType.message
      : photoUrl != null ? MessageType.photo : MessageType.unknown;

  Map<String, dynamic> get map => <String, dynamic>{
        'message': message,
        'photo_url': photoUrl,
        'timestamp': Timestamp.now(),
        'from_id': fromId,
      };
}

enum MessageType { message, photo, unknown }
