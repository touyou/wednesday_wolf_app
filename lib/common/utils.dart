import 'package:firebase_auth/firebase_auth.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';

WolfUser searchWolf(FirebaseUser user) {
  return users.firstWhere((wolf) => wolf.email == user.email);
}
