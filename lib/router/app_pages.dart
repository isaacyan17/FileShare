import 'package:file_share/config/config.dart';
import 'package:file_share/home/home.dart';
import 'package:file_share/room/room_binding.dart';
import 'package:file_share/room/room_view.dart';
import 'package:file_share/router/app_routes.dart';
import 'package:file_share/utils/document/document.dart';
import 'package:get/get.dart';

class AppPages {
  static final page = [
    GetPage(name: AppRoutes.home, page: ()=>Home()),

    GetPage(name: AppRoutes.Room, page: () {
      if(GetPlatform.isWeb){
        Uri uri = Uri.parse(url);
        return  Room(
          freshMan: false,
          serverAddress: 'http://${uri.host}:${Config.roomPort}',
        );
      }
      return Room(
        freshMan: true,
      );
    }, binding: RoomBinding()),
  ];
}
