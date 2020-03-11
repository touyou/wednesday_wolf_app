import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wednesday_wolf_app/pages/home_page.dart';
import 'package:wednesday_wolf_app/pages/login_page.dart';
import 'package:wednesday_wolf_app/pages/splash_page.dart';

void main() => runApp(MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
      ],
      title: '水曜日のオオカミくんには騙されない。',
      routes: <String, WidgetBuilder>{
        '/': (_) => SplashPage(),
        '/login': (_) => LoginPage(),
        '/home': (_) => HomePage(),
      },
    ));
