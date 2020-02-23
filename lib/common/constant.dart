import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';

final List<WolfUser> users = [
  WolfUser(0, 'ゴディバ', 'godiva@okamikun.jp'),
  WolfUser(1, 'ふみっち', 'fumicchi@okamikun.jp'),
  WolfUser(2, 'とうよう', 'touyou@okamikun.jp'),
  WolfUser(3, 'りゅーじん', 'ryujin@okamikun.jp'),
  WolfUser(4, 'あみたん', 'amitan@okamikun.jp'),
  WolfUser(5, 'おやぶん', 'oyabun@okamikun.jp'),
  WolfUser(6, 'れんれん', 'renren@okamikun.jp'),
  WolfUser(7, 'ジーニー', 'genie@okamikun.jp'),
  WolfUser(8, 'あっぷる', 'apple@okamikun.jp'),
  WolfUser(9, 'おすず', 'osuzu@okamikun.jp'),
];

final List<List<String>> iconFiles = [
  ['images/godiva1.jpg', 'images/godiva2.jpg'],
  ['images/fumiya1.jpg', 'images/fumiya2.jpg'],
  ['images/touyou1.jpg', 'images/touyou2.jpg'],
  ['images/ryujin1.jpg', 'images/ryujin2.jpg'],
  ['images/amitan1.jpg', 'images/amitan2.jpg'],
  ['images/oyabun1.jpg', 'images/oyabun2.jpg'],
  ['images/renren1.jpg', 'images/renren2.jpg'],
  ['images/genei1.jpg', 'images/genei2.jpg'],
  ['images/apple1.jpg', 'images/apple2.jpg'],
  ['images/godiva1.jpg', 'images/godiva2.jpg'],
];

class WolfColors {
  static const baseBackground = Color.fromRGBO(221, 224, 227, 1);
  static const whiteBackground = Color.fromRGBO(245, 245, 245, 1);
  static const lightGray = Color.fromRGBO(235, 235, 235, 1);
  static const mainColor = Color.fromRGBO(43, 79, 131, 1);
}

// ignore: avoid_classes_with_only_static_members
class WolfTextStyle {
  static final TextStyle minchoWhite = GoogleFonts.sawarabiMincho(
    color: WolfColors.whiteBackground,
    fontSize: 18,
  );
  static final TextStyle gothicBlackSmall = GoogleFonts.notoSans(fontSize: 16);
}
