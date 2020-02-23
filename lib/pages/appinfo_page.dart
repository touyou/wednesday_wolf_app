import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wednesday_wolf_app/common/constant.dart';

class AppInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: WolfColors.mainColor),
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: _layoutBody(),
      ),
    );
  }

  Widget _layoutBody() {
    return SizedBox.expand(
      child: Container(
        color: WolfColors.baseBackground,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('水曜日のオオカミくんには騙されない', style: WolfTextStyle.minchoBlackTitleBig),
            SizedBox(height: 16),
            Text('企画・Web: 鈴木まりん a.k.a. おすず', style: WolfTextStyle.minchoBlack),
            Text('投票システム: 白鳥亜美 a.k.a. あみたん', style: WolfTextStyle.minchoBlack),
            Text('出演: 水曜スクールCMと愉快な仲間たち', style: WolfTextStyle.minchoBlack),
            Text('Special Thanks: 水曜スクールメンバー',
                style: WolfTextStyle.minchoBlack),
            SizedBox(height: 32),
            Text('アプリ水曜日のオオカミくん', style: WolfTextStyle.minchoBlackTitleBig),
            SizedBox(height: 16),
            Text('企画・実装: 藤井陽介 a.k.a. とうよう', style: WolfTextStyle.minchoBlack),
            Text('実装協力: 田中郁弥 a.k.a. ふみっち', style: WolfTextStyle.minchoBlack),
            Text('技術協力: 西村大河、秋田祥平', style: WolfTextStyle.minchoBlack),
            Text('素材提供: 鈴木まりん a.k.a. おすず', style: WolfTextStyle.minchoBlack),
          ],
        ),
      ),
    );
  }
}
