import 'dart:ui';

import 'package:file_share/room/room_controller.dart';
import 'package:file_share/utils/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class Room extends GetView<RoomController> {
  // RoomController get controller => Get.find();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
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
                    // Log.d('size: ${controller.chatRecords.length}');
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
                  height: kToolbarHeight+20,
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
                          borderRadius: BorderRadius.circular(20)
                        ),
                        height: 48,
                        width: 48,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                          onTap: (){
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
