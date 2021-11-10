import 'package:file_share/room/room_controller.dart';
import 'package:get/get.dart';

class RoomBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RoomController());

  }

}