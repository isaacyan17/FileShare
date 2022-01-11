import 'package:file_share/server/model/message.dart';
import 'package:file_share/utils/log.dart';

///消息类型: 文件
class TemplateFile extends Message {
  String? fileName;
  String? path;
  String? fileSize;
  String? url;
  String? type;

  /// 构建文件类型的消息 , url为必传项
  TemplateFile(url, {this.fileName, this.path, this.fileSize, this.type})
      : super(type: type);

  /// 从json解析成TemplateFile 模板bean
  TemplateFile.fromJson(Map<String, dynamic> json) {
    try {
      fileName = json['fileName'];
      path = json['path'];
      fileSize = json['fileSize'];
      url = json['url'];
      type = json['type'];
    } catch (e) {
      Log.e('TemplateFile 解析异常 $e');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['fileName'] = fileName;
    map['path'] = path;
    map['fileSize'] = fileSize;
    map['url'] = url;
    return map;
  }
}
