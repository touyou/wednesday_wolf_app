import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message.newMessage({this.message})
      : photoUrl = null,
        reference = null;

  Message.newImage({this.photoUrl})
      : message = null,
        reference = null;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null || map['photo_url'] != null),
        message = map['message'] as String,
        photoUrl = map['photo_url'] as String;

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  final String message;
  final String photoUrl;
  final DocumentReference reference;

  MessageType get type => message != null
      ? MessageType.message
      : photoUrl != null ? MessageType.photo : MessageType.unknown;

  Map<String, dynamic> get map => {'message': message, 'photo_url': photoUrl};
}

enum MessageType { message, photo, unknown }
