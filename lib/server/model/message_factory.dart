import 'package:file_share/room/message/message_text_view.dart';
import 'package:file_share/server/model/message.dart';
import 'package:file_share/server/model/template_message_text.dart';
import 'package:flutter/cupertino.dart';

class MessageFactory {
  static Widget? getMessage(Message m, bool sendByServer) {
    Widget? child;
    if (m is TemplateText) {
      child = MessageTextView(
        text: m.content,
        sendByServer: sendByServer,
      );
    }
    return child;
  }
}
