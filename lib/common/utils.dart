import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/entities/chat_room.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';

WolfUser searchWolf(FirebaseUser user) {
  return users.firstWhere((wolf) => wolf.email == user.email);
}

Future<bool> showDialogMessage(BuildContext context,
    {String title, String message, bool isOkOnly = false}) {
  return showDialog<bool>(
    context: context,
    builder: (context) =>
        _buildDialog(context, title, message, isOkOnly: isOkOnly),
  );
}

Widget _buildDialog(BuildContext context, String title, String message,
    {bool isOkOnly = false}) {
  if (title == null && message == null) {
    throw ArgumentError('titleとmessageのどちらかは指定してください。');
  }
  final actions = <Widget>[];
  if (!isOkOnly) {
    actions.add(FlatButton(
      child: const Text('Cancel'),
      onPressed: () {
        Navigator.pop(context, false);
      },
    ));
  }
  actions.add(FlatButton(
    child: const Text('OK'),
    onPressed: () {
      Navigator.pop(context, true);
    },
  ));
  return AlertDialog(
    title: title != null ? Text(title) : null,
    content: message != null ? Text(message) : null,
    actions: actions,
  );
}

bool isOsuzu(WolfUser user, WolfUser me) {
  return user.id == 9;
}

bool isOsuzuBy(ChatId chatId) {
  return chatId.toId == 9;
}
