import 'package:file_share/room/room_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class Room extends GetView<RoomController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    controller.init();

    return Container(
      color: Colors.grey,
    );

  }

}