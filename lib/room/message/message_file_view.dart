import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_share/config/config.dart';
import 'package:file_share/server/model/template_message_file.dart';
import 'package:file_share/utils/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageFileView extends StatelessWidget {
  final bool? sendBySelf;
  late TemplateFile? fileInfo;
  bool hasDownload = false;
  Dio dio = Dio();

  MessageFileView({Key? key, this.fileInfo, this.sendBySelf})
      : super(key: key) {
    if (sendBySelf != null) {
      hasDownload = hasDownload | sendBySelf!;
    }
  }

  @override
  Widget build(BuildContext context) {
    ///界面view
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          sendBySelf! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.cyan[50], borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ///显示文件名,大小,类型
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: Text(
                              fileInfo!.fileName!,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: Text(
                              fileInfo!.fileSize!,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Center(
                          child: Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.yellowAccent,
                      )),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 0.2,
                    width: 200,
                    child: Container(
                      color: Colors.grey[400],
                    ),
                  )),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //todo 状态, 下载进度
                  InkWell(
                    onTap: (){
                      Log.i('${fileInfo?.url}${fileInfo?.path}');
                      String url = '${fileInfo?.url}${fileInfo?.path}';
                      // downloadFile(url, Config.pathAndroid, fileInfo!.fileName!);
                    },
                    child:  Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            hasDownload ? '查看' : '点击下载',
                            style: TextStyle(
                                color: hasDownload
                                    ? Colors.lightBlue
                                    : Colors.grey[400],
                                fontSize: 11),
                          ),
                        )),
                  ),

                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Future<void> downloadFile(String url,String localPath,String fileName) async{
    if(await Permission.storage.request().isGranted) {
      try {
        Directory directory = Directory(localPath);
        if (!directory.existsSync()) {
          directory.createSync();
        }
        String filePath = '$localPath/$fileName';
        // File f = File(filePath);
        await dio.download(url, filePath, onReceiveProgress: (count, total) {
          Log.i(count / total);
        });
      } catch (e) {
        Log.e(e);
      }
    }else{
      Fluttertoast.showToast(msg: '请先允许存储权限!');
    }
  }

}
