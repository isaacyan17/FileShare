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
            child: GetBuilder<RoomController>(
              // initState: (_) => controller.init(),
              builder: (context) {
                return ListView.builder(
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
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
