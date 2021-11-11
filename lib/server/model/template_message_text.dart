import 'package:file_share/server/model/message.dart';

class TemplateText extends Message{
  String? content;
  String? type;
  TemplateText({this.type,this.content}):super(type:type);

  TemplateText.fromJson(Map<String, dynamic> json)  {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map={};
    map['content'] = content;
    return map;
  }

}