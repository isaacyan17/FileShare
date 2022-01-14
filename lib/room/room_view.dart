import 'dart:ui';

import 'package:file_share/room/room_controller.dart';
import 'package:file_share/utils/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:get_server/get_server.dart';

class Room extends GetView<RoomController> {
  RoomController get controller => Get.find();
  final String? serverAddress;
  final bool? freshMan;

  Room({Key? key, this.serverAddress, this.freshMan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    controller.init(
        freshMan: freshMan == null ? true : freshMan!, address: serverAddress);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ///聊天记录
          GestureDetector(
              child: Obx(() => ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    0,
                    kToolbarHeight + 20,
                    0,
                    120,
                  ),
                  itemCount: controller.chatRecords.length,
                  itemBuilder: (c, i) {
                    return controller.chatRecords[i];
                  }))),

          ///导航栏
          Align(
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: Container(
                  height: kToolbarHeight + 20,
                  color: Colors.red,
                  child: AppBar(
                    title: Text(
                      'FileShare',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    leading: Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        height: 48,
                        width: 48,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          ///底部
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaY: 8,
                  sigmaX: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 65,
                      child: sharedContainer(context),
                    ),
                    Obx(() => Offstage(
                          offstage: controller.collapse.value,
                          child: expandedWidget(),
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Material sharedContainer(BuildContext context) {
    return Material(
      color: Colors.grey[300]!.withOpacity(0.8),
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
          child: Row(
            children: [
              SizedBox(
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                  ),
                  onPressed: () {
                    controller.collapse.update((_) {
                      controller.collapse.value = !controller.collapse.value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  ///文本输入框
                  child: TextField(
                    focusNode: controller.focusNode,
                    controller: controller.editController,
                    autofocus: false,
                    maxLines: 8,
                    style: TextStyle(
                      textBaseline: TextBaseline.ideographic,
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {
                      controller.sendTextMessage();
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: TextButton(
                  onPressed: () {
                    controller.sendTextMessage(sendByUser: true);
                  },
                  child: Text(
                    '发送',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 可拓展的功能,
  /// 文件夹, 粘贴板
  Widget expandedWidget() {
    return Container(
      color: Colors.grey[300]!.withOpacity(0.8),
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          children: [
            if (GetPlatform.isMobile)
              SizedBox(
                child: IconButton(
                  icon: Icon(
                    Icons.file_copy,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    // print('copy');
                    controller.updateClipboardData();
                  },
                ),
              ),
            SizedBox(
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/images/directory.svg',
                  color: Colors.yellowAccent[700],
                ),
                onPressed: () {
                  print('文件夹');
                  controller.openDir();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
