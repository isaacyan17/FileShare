import 'package:file_share/room/room_binding.dart';
import 'package:file_share/room/room_view.dart';
import 'package:file_share/router/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final page = [
    GetPage(name: AppRoutes.Room, page: () => Room(), binding: RoomBinding()),
  ];
}
