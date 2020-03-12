import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/common/secret_constant.dart';
import 'package:wednesday_wolf_app/entities/chat_room.dart';
import 'package:wednesday_wolf_app/entities/wolf_user.dart';

final DateTime graduateDate = DateTime(2020, DateTime.march, 11, 21, 0, 0);

String checkUserProp(WolfUser user) {
  if (graduateIds.contains(user.id)) {
    return 'graduate';
  }
  if (caIds.contains(user.id)) {
    return 'ca';
  }
  if (user.id == 10) {
    return 'member';
  }
  return 'normal';
}

String checkUserPropById(int id) {
  return checkUserProp(users.firstWhere((user) => user.id == id));
}

bool isListedUser(WolfUser user, WolfUser me) {
  if (user.id == me.id) {
    return false;
  }

  final userProp = checkUserProp(user);
  final meProp = checkUserProp(me);

  final now = DateTime.now();

  if (now.isBefore(graduateDate)) {
    return (meProp == 'graduate' && ['ca', 'member'].contains(userProp)) ||
        (meProp == 'ca' && ['graduate', 'member'].contains(userProp)) ||
        (meProp == 'normal' && userProp != 'normal') ||
        meProp == 'member';
  } else {
    return meProp == 'graduate' ||
        meProp == 'ca' ||
        meProp == 'member' ||
        (meProp == 'normal' && userProp != 'normal');
  }
}

bool canSendMessage(WolfUser user, WolfUser me) {
  final userProp = checkUserPropById(user.id);
  final meProp = checkUserPropById(me.id);

  if (meProp == 'member') {
    return false;
  }

  return (meProp == 'graduate' && ['ca', 'member'].contains(userProp)) ||
      (meProp == 'ca' && ['graduate', 'member'].contains(userProp)) ||
      (meProp == 'normal' && userProp != 'normal');
}

List<ChatId> getChatIds(WolfUser user, WolfUser me) {
  final now = DateTime.now();
  if (now.isBefore(graduateDate)) {
    return [
      canSendMessage(user, me)
          ? ChatId(fromUser: me, toUser: user, isSender: true)
          : ChatId(fromUser: user, toUser: me, isSender: false)
    ];
  } else {
    return me.id != 10
        ? [
            ChatId(fromUser: me, toUser: user, isSender: true),
            ChatId(fromUser: user, toUser: me, isSender: true)
          ]
        : [
            ChatId(fromUser: user, toUser: me, isSender: false),
          ];
  }
}
