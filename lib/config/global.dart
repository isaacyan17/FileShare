import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_share/config/config.dart';
import 'package:file_share/utils/log.dart';
import 'package:file_share/utils/runtime_environment.dart';
import 'package:flutter/services.dart';

class Global{
  Future<void> initResource() async{
    unpackWebResource();
  }

  /// 解压web资源
  Future<void> unpackWebResource() async {
    ByteData byteData = await rootBundle.load(
      // '${Config.packageName}/assets/web.zip',
      'assets/web.zip',
    );
    final Uint8List list = byteData.buffer.asUint8List();
    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(list);
    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File wfile = File(RuntimeEnv.getInstance().getFilePath() + '/' + filename);
        // Log.i('${RuntimeEnv.getInstance().getFilePath()} / + $filename');
        await wfile.create(recursive: true);
        await wfile.writeAsBytes(data);
      } else {
        await Directory(RuntimeEnv.getInstance().getFilePath() + '/' + filename).create(
          recursive: true,
        );
      }
    }
  }
}