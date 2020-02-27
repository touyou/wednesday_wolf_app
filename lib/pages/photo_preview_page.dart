import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/common/utils.dart';

class PhotoPreviewPage extends StatelessWidget {
  const PhotoPreviewPage({this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WolfColors.mainColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () async {
              final response = await http.get(photoUrl);
              print(response);
              if (response.statusCode >= 200 && response.statusCode < 300) {
                print(response.statusCode);
                await showDialogMessage(context,
                    title: '画像保存', message: '画像を保存しました。', isOkOnly: true);
                await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
              } else {
                await showDialogMessage(context,
                    title: 'エラー',
                    message: '画像のダウンロード時にエラーが発生しました。通信状況をご確認ください。',
                    isOkOnly: true);
              }
            },
          )
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          color: Colors.black,
          child: FadeInImage.assetNetwork(
            placeholder: 'images/placeholder.png',
            image: photoUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
