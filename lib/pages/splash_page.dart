import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3))
        .then((value) => _handleTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
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
