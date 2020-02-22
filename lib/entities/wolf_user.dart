import 'package:cloud_firestore/cloud_firestore.dart';

class WolfUser {
  WolfUser(this.id, this.name, this.email)
      : imageId = 0,
        course = 'none';

  WolfUser.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['email'] != null),
        assert(map['image_id'] != null),
        assert(map['course'] != null),
        id = map['id'] as int,
        name = map['name'] as String,
        email = map['email'] as String,
        imageId = map['image_id'] as int,
        course = map['course'] as String;

  WolfUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  final int id;
  final String name;
  final String email;
  final int imageId;
  final String course;
  DocumentReference reference;
}
