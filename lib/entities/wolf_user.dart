import 'package:cloud_firestore/cloud_firestore.dart';

class WolfUser {
  WolfUser(this.id, this.name, this.email);

  WolfUser.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['email'] != null),
        id = map['id'] as int,
        name = map['name'] as String,
        email = map['email'] as String;

  WolfUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  final int id;
  final String name;
  final String email;
  DocumentReference reference;
}
