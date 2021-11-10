import 'package:file_share/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:getsocket/getsocket.dart';

/// todo 这是一个shareRoom的controller，数据管理
///
class Server {
  late GetSocket socket;
  bool connectState = false;

  Future<void> init() async{
    ///打开websocket server
    print('init');
    socket = GetSocket('http://127.0.0.1:${Config.serverPort}/transfer');
    socket.onOpen(() {
      print('opened');
      connectState = true;
    });
    try {
      socket.connect();
      // await Future.delayed(Duration.zero);

    }catch(e){
      print(e.toString());
      connectState = false;
    }
    ///socket listener
    socketListener();
  }

  ///ws监听
  void socketListener(){
    socket.on('joined', (val) {
      print('joined: $val');
    });

    socket.onMessage((val) {
      print('message received: $val');
    });

    socket.onClose((close) {
      print('断连监听');

    });

    // socket.emit('event', 'you data');
    //
    socket.send('data');

  }



}
