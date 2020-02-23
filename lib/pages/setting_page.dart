import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/common/utils.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key, this.me}) : super(key: key);

  final WolfUser me;

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int imageId;

  @override
  void initState() {
    super.initState();
    imageId = widget.me.imageId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WolfColors.mainColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              showDialogMessage(context, title: 'ログアウト', message: 'ログアウトしますか？')
                  .then((value) {
                if (value) {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              });
            },
          )
        ],
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: _layoutBody(context),
      ),
    );
  }

  Widget _layoutBody(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: WolfColors.baseBackground,
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 32),
                Image.asset('images/login_hero.png', height: 200),
                const SizedBox(height: 16),
                Center(
                  child: Text('画像を選択', style: WolfTextStyle.gothicBlackTitle),
                ),
                _layoutImageRadio(),
                const SizedBox(height: 16),
                Center(
                  child: RaisedButton(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Text(
                      '保存',
                      style: WolfTextStyle.minchoWhite,
                    ),
                    color: WolfColors.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () {
                      widget.me.reference.updateData(
                        <String, dynamic>{'image_id': imageId},
                      );
                      Navigator.of(context).pop();
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _layoutImageRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
            value: 0,
            groupValue: imageId,
            onChanged: (int value) => setState(() {
                  imageId = value;
                })),
        Text('Season 1', style: WolfTextStyle.gothicBlackSmall),
        Radio(
            value: 1,
            groupValue: imageId,
            onChanged: (int value) => setState(() {
                  imageId = value;
                })),
        Text('Season 2', style: WolfTextStyle.gothicBlackSmall),
      ],
    );
  }
}
