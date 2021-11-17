import 'dart:convert';

/// 消息的bean类
class Message {
   String? type;
  Message({this.type});


   Map<String, dynamic> toJson() {
     final map = <String, dynamic>{};
     map['type'] = type;
     return map;
   }

   @override
   String toString() {
     return json.encode(this);
   }
}
