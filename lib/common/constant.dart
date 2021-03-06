import 'dart:ui';

import 'package:flutter/material.dart';
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
  WolfUser(10, '村人', 'murabito@okamikun.jp'),
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
  ['images/osuzu1.jpg', 'images/osuzu2.jpg'],
  ['images/murabito.jpg'],
];

class WolfColors {
  static const baseBackground = Color.fromRGBO(221, 224, 227, 1);
  static const whiteBackground = Color.fromRGBO(245, 245, 245, 1);
  static const lightGray = Color.fromRGBO(235, 235, 235, 1);
  static const mediumGray = Color.fromRGBO(196, 196, 196, 1);
  static const mainColor = Color.fromRGBO(43, 79, 131, 1);
  static const shadowBlack = Color.fromRGBO(46, 46, 46, 0.25);
  static const overlayBlack = Color.fromRGBO(39, 39, 39, 0.5);
  static const darkGray = Color.fromRGBO(30, 30, 30, 1);
}

class WolfTextStyle {
  static const TextStyle minchoWhite = TextStyle(
    fontFamily: 'NotoSerifJP',
    color: WolfColors.whiteBackground,
    fontSize: 18,
  );
  static const TextStyle minchoBlack = TextStyle(
    fontFamily: 'NotoSerifJP',
    color: WolfColors.mainColor,
    fontSize: 18,
  );
  static const TextStyle minchoBlackTitleBig = TextStyle(
    fontFamily: 'NotoSerifJP',
    color: WolfColors.mainColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle gothicBlackName = TextStyle(
    fontFamily: 'NotoSansJP',
    color: WolfColors.darkGray,
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle gothicBlackSmall = TextStyle(
    fontFamily: 'NotoSansJP',
    fontSize: 16,
  );
  static const TextStyle gothicBlackTitle = TextStyle(
    fontFamily: 'NotoSansJP',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}
