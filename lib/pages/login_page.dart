import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wednesday_wolf_app/common/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailInputController = TextEditingController();

  final TextEditingController passwordInputController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _layoutBody(),
    );
  }

  Widget _layoutBody() {
    return Center(
      child: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24),
              TextFormField(
                controller: emailInputController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: passwordInputController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RaisedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    final email = emailInputController.text;
                    final password = passwordInputController.text;
                    return _signIn(email, password).then((result) {
                      Navigator.of(context).pushReplacementNamed('/home',
                          arguments: result.user);
                    }).catchError(
                      (e) => showDialogMessage(
                        context,
                        title: 'ログインエラー',
                        message: e.toString(),
                        isOkOnly: true,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<AuthResult> _signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    print('User id is ${result.user.uid}');
    return result;
  }
}
