import 'package:file_share/server/model/message.dart';

/// 消息类型:文本
class TemplateText extends Message{
  String? content;
  String? type;
  TemplateText({this.type,this.content}):super(type:type);

  TemplateText.fromJson(Map<String, dynamic> json)  {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['type'] = type;
    map['content'] = content;
    return map;
  }

}