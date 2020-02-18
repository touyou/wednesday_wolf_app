import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as FirebaseUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('水曜日のオオカミくんには騙されない。'),
      ),
      body: _layoutBody(),
    );
  }

  Widget _layoutBody() {
    return Center(
      child: Text('${currentUser.email}'),
    );
  }
}
