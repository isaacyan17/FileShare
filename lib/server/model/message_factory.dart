import 'package:file_share/room/message/message_file_view.dart';
import 'package:file_share/room/message/message_text_view.dart';
import 'package:file_share/room/message/message_tip_view.dart';
import 'package:file_share/server/model/message.dart';
import 'package:file_share/server/model/template_message_file.dart';
import 'package:file_share/server/model/template_message_text.dart';
import 'package:file_share/server/model/template_message_tip.dart';
import 'package:flutter/cupertino.dart';
/// 构建消息的工厂类, 通过*getMessage*将不同的消息类型转换成对应的view
class MessageFactory {
  //可选参数
  static Widget? getMessage(Message m, {bool? sendByServer}) {
    Widget? child;
    if (m is TemplateText) {
      child = MessageTextView(
        text: m.content,
        sendByServer: sendByServer??false,
      );
    }else if(m is TemplateTip){
      child = MessageTipView(text: m.content!);
    }else if(m is TemplateFile){
      child = MessageFileView(fileInfo: m,sendBySelf: sendByServer?? false);
    }
    return child;
  }

  /// 服务器解析过来的json格式
  static Message fromJson(Map<String, dynamic> json){
    String type = json['type'];
  switch(type){
    case 'text':
      return TemplateText.fromJson(json);
    case 'file':
      return TemplateFile.fromJson(json);
  }
    throw '解析异常';
  }
}
