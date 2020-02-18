import 'package:flutter/material.dart';
import 'package:wednesday_wolf_app/pages/chat_page.dart';
import 'package:wednesday_wolf_app/pages/home_page.dart';
import 'package:wednesday_wolf_app/pages/login_page.dart';
import 'package:wednesday_wolf_app/pages/splash_page.dart';

void main() => runApp(MaterialApp(
      title: '水曜日のオオカミくんには騙されない。',
      routes: <String, WidgetBuilder>{
        '/': (_) => SplashPage(),
        '/login': (_) => LoginPage(),
        '/home': (_) => HomePage(),
        '/chat': (_) => ChatPage(),
      },
    ));
