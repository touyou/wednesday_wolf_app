import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wednesday_wolf_app/common/utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _auth = FirebaseAuth.instance;
  double _logoOpacity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNetwork();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 79, 131),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset('images/splash_title.png'),
              const Spacer(flex: 1),
              AnimatedOpacity(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 700),
                opacity: _logoOpacity,
                child: Image.asset(
                  'images/ookami-icon.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset('images/splash_loading.png'),
              const Spacer(flex: 2),
              Image.asset('images/splash_comment.png'),
            ],
          ),
        ),
      ),
    );
  }

  Future _checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await showDialogMessage(context,
              title: 'ネットワークエラー',
              message: 'このアプリはインターネット接続を利用します。接続を確認してからOKを押してください。',
              isOkOnly: true)
          .then((value) {
        if (value) {
          _checkNetwork();
        }
      });
    } else {
      final timer = Timer.periodic(const Duration(milliseconds: 700), (value) {
        setState(() {
          _logoOpacity = _logoOpacity == 1 ? 0.3 : 1.0;
        });
      });

      await Future<dynamic>.delayed(const Duration(seconds: 3))
          .then((dynamic value) {
        timer.cancel();
        _handleTimeout();
      });
    }
  }

  void _handleTimeout() {
    _auth.currentUser().then((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        Navigator.of(context).pushReplacementNamed('/home', arguments: user);
      }
    });
  }
}
