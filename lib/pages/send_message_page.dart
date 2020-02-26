import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wednesday_wolf_app/common/constant.dart';
import 'package:wednesday_wolf_app/entities/message.dart';

class SendMessagePage extends StatefulWidget {
  const SendMessagePage({
    Key key,
    this.reference,
    this.fromId,
    this.message,
  }) : super(key: key);

  final CollectionReference reference;
  final int fromId;
  final Message message;

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController messageInputController = TextEditingController();
  final OutlineInputBorder normalOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(style: BorderStyle.none),
  );
  final OutlineInputBorder errorOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(color: Color(0xffef9a9a)),
  );

  @override
  void initState() {
    super.initState();

    if (widget.message != null) {
      messageInputController.text = widget.message.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規メッセージ'),
        backgroundColor: WolfColors.mainColor,
      ),
      body: _layoutBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (messageInputController.text.isNotEmpty) {
            if (widget.message != null) {
              widget.message.reference.updateData(<String, dynamic>{
                'message': messageInputController.text
              }).then((value) => Navigator.of(context).pop());
            } else {
              widget.reference
                  .add(
                    Message.newMessage(
                      message: messageInputController.text,
                      fromId: widget.fromId,
                    ).map,
                  )
                  .then((value) => Navigator.of(context).pop());
            }
          }
        },
        child: Icon(Icons.send),
        backgroundColor: WolfColors.mainColor,
      ),
    );
  }

  Widget _layoutBody(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: WolfColors.baseBackground,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                controller: messageInputController,
                minLines: 10,
                maxLines: 100,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: WolfColors.whiteBackground,
                  enabledBorder: normalOutlineBorder,
                  focusedBorder: normalOutlineBorder,
                  errorBorder: errorOutlineBorder,
                  focusedErrorBorder: errorOutlineBorder,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
