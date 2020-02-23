import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/common/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OutlineInputBorder normalOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(style: BorderStyle.none),
  );
  final OutlineInputBorder errorOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(color: Color(0xffef9a9a)),
  );
  final FocusNode focus = FocusNode();
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();

    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      body: _layoutBody(),
    );
  }

  Widget _layoutBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 32),
            Image.asset('images/login_hero.png', height: 200),
            const SizedBox(height: 16),
            TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              controller: emailInputController,
              validator: (value) {
                return value.isEmpty ? '必須入力です。' : null;
              },
              decoration: InputDecoration(
                enabledBorder: normalOutlineBorder,
                focusedBorder: normalOutlineBorder,
                errorBorder: errorOutlineBorder,
                focusedErrorBorder: errorOutlineBorder,
                filled: true,
                fillColor: WolfColors.lightGray,
                hintText: 'nickname@okamikun.jp',
              ),
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(focus);
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              focusNode: focus,
              controller: passwordInputController,
              obscureText: passwordVisible,
              validator: (value) {
                return value.isEmpty ? '必須入力です。' : null;
              },
              decoration: InputDecoration(
                enabledBorder: normalOutlineBorder,
                focusedBorder: normalOutlineBorder,
                errorBorder: errorOutlineBorder,
                focusedErrorBorder: errorOutlineBorder,
                filled: true,
                fillColor: WolfColors.lightGray,
                hintText: 'password',
                suffixIcon: IconButton(
                  color: WolfColors.mainColor,
                  icon: passwordVisible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: RaisedButton(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Text(
                  'はじめる',
                  style: WolfTextStyle.minchoWhite,
                ),
                color: WolfColors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () {
                  final email = emailInputController.text;
                  final password = passwordInputController.text;
                  if (_formKey.currentState.validate()) {
                    return _signIn(email, password).then((result) {
                      Navigator.of(context).pushReplacementNamed('/home',
                          arguments: result.user);
                    });
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<AuthResult> _signIn(String email, String password) async {
    AuthResult result;
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('User id is ${result.user.uid}');
    } on PlatformException catch (error) {
      print('Auth Error: ${error.code}');
      await showDialogMessage(
        context,
        title: 'ログインエラー',
        message: _errorMessage(error.code),
        isOkOnly: true,
      );
    }
    return result;
  }

  String _errorMessage(String code) {
    switch (code) {
      case 'ERROR_INVALID_EMAIL':
        return '不正なメールアドレスです。';
      case 'ERROR_WRONG_PASSWORD':
        return 'パスワードが間違っています。';
      case 'ERROR_USER_NOT_FOUND':
        return 'ユーザーが見つかりません。';
      case 'ERROR_USER_DISABLED':
        return '無効なユーザーです。';
      case 'ERROR_TOO_MANY_REQUESTS':
        return 'リクエストが集中しています。しばらくしてからもう一度お試しください。';
      default:
        return '不明なエラーがおきました。';
    }
  }
}
