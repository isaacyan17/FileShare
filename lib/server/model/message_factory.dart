import 'package:file_share/room/message/message_text_view.dart';
import 'package:file_share/room/message/message_tip_view.dart';
import 'package:file_share/server/model/message.dart';
import 'package:file_share/server/model/template_message_text.dart';
import 'package:file_share/server/model/template_message_tip.dart';
import 'package:flutter/cupertino.dart';

class MessageFactory {
  //可选参数
  static Widget? getMessage(Message m, {bool? sendByServer}) {
    Widget? child;
    if (m is TemplateText) {
      child = MessageTextView(
        text: m.content,
        sendByServer: sendByServer,
      );
    }else if(m is TemplateTip){
      child = MessageTipView(text: m.content!);
    }
    return child;
  }
}
