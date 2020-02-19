import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wednesday_wolf_app/entities/message.dart';

class SendMessagePage extends StatefulWidget {
  const SendMessagePage({this.reference});

  final CollectionReference reference;

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController messageInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規メッセージ'),
      ),
      body: _layoutBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (messageInputController.text.isNotEmpty) {
            widget.reference
                .add(Message.newMessage(message: messageInputController.text)
                    .map)
                .then((value) {
              Navigator.of(context).pop();
            });
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }

  Widget _layoutBody(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: messageInputController,
              minLines: 10,
              maxLines: 100,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
