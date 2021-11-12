import 'package:file_share/server/model/message.dart';

class TemplateTip extends Message{
  String? content;
  String? type;
  TemplateTip({this.type,this.content}):super(type:type);

  TemplateTip.fromJson(Map<String, dynamic> json)  {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map={};
    map['content'] = content;
    return map;
  }

}