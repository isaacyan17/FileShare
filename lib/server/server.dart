import 'dart:convert';

import 'package:file_share/config/config.dart';
import 'package:file_share/room/room_view.dart';
import 'package:file_share/utils/log.dart';
import 'package:file_share/utils/runtime_environment.dart';
// import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_server/get_server.dart' hide GetPlatform;


/// 这是一个服务端界面，启动一个服务，并应答所有连上这个server的client
/// 约定数据都以json格式发送
class Server {

  static late String home;

  static void createServerPage(){
    if(GetPlatform.isDesktop){
      home = RuntimeEnv.getInstance().getFilePath();
    }else{
      home = RuntimeEnv.getInstance().getFilePath();
    }
      runApp(
        GetServerApp(
          useLog: true,
          //home ,即'/',localhost访问时的根目录
          home: FolderWidget(home),
          port:Config.roomPort,
          getPages: [
            GetPage(name: '/room', page: ()=>ServerPage(),
            method: Method.dynamic
            ),
          ],
          onNotFound: NotFoundPage(),
        )
      );
    // Log.d('server down');
  }

}

class NotFoundPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      '请重试',
    );
  }

}


class ServerPage extends GetView{
  //连接列表
  final List<GetSocket> sockets = [];
  //历史消息
  final List<dynamic> msgs = [];
  final Map<int,String> deviceInfo = {};

  @override
  Widget build(BuildContext context) {
    return Socket(builder: (socket){
      sockets.add(socket);
      Log.d('Server监听');
      socket.onOpen((ws) {
        Log.d('${ws.id} 已连接');
      });
      ///连接监听
      socket.on('join', (val) {
        final join = socket.join(val);
        if (join) {
          socket.sendToRoom(val, 'socket: ${socket.hashCode} join to room');
        }
      });
      ///消息监听
      socket.onMessage((val) {
        //chrome 浏览器在不停发空白消息
        if(val.toString().isEmpty){
          return;
        }
        Log.d('收到client消息: $val');
        try{
          //todo 发送历史消息

          // client加入room的回馈
          Map<String, dynamic> jsonMap = json.decode(val);
          if(jsonMap.isNotEmpty){
            if(jsonMap['type']=='join'){
                deviceInfo[socket.id]=jsonMap['name'];
                socket.broadcast(json.encode({
                  'code':'200',
                  'msg':'${jsonMap['name']}加入房间',
                }));
                return;
            }
          }
        }catch(e){
          Log.e('e -> $e');
        }
        //收集消息
        msgs.add(val);
        socket.broadcast(val);

      });
      ///关闭连接监听
      socket.onClose((c) {
        sockets.remove(socket);
        //通知其他client
        sockets.forEach((e) {
          e.send(json.encode({
            'code': '201',
            'msg': '${deviceInfo[socket.id]} 退出房间',
          }));
        });
        print('$sockets socket has closed. Reason: ${c.message}');
      });
    });
  }

}
