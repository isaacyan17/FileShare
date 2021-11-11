import 'package:file_share/config/config.dart';
import 'package:file_share/server/model/message_factory.dart';
import 'package:file_share/server/model/template_message_text.dart';
import 'package:file_share/utils/http/platform_utils.dart';
import 'package:file_share/utils/log.dart';
import 'package:get/get.dart';
// import 'package:getsocket/getsocket.dart';

/// todo 这是一个shareRoom的controller，数据管理
/// 对于Getx的状态管理和路由，详见 : https://juejin.cn/post/6997283367045562375
/// or https://github.com/jonataslaw/getx/blob/master/documentation/zh_CN/state_management.md
///
class RoomController extends GetxController {
  late GetSocket socket;
  bool connectState = false;

  ///存放room的消息记录
  List<dynamic> chatRecords = <dynamic>[];

  Future<void> init() async {
    ///打开websocket server
    print('init');

    socket = GetSocket('http://127.0.0.1:${Config.serverPort}/transfer');
    socket.onOpen(() {
      Log.d('连接成功');
      connectState = true;
    });
    try {
      socket.connect();
      // await socket.connect();
      // await Future.delayed(Duration.zero);
      // await Future.delayed(Duration.zero);

    } catch (e) {
      Log.d(e.toString());
      connectState = false;
    }
    sendInitialSuccess();

    ///socket listener
    socketListener();
  }

  ///ws监听
  void socketListener() {
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
    // socket.send('data');
  }

  Future<void> sendInitialSuccess() async {
    String msg = '使用浏览器直接打开以下url，'
        '只有同局域网下的设备能打开';
    sendText(msg);
    PlatformUtil.localAddress().then((value) {
      Log.d(value);
      if (value.isEmpty) {
        sendText('未发现局域网IP');
      } else {
        sendText('http://$value:${Config.serverPort}');
      }
    });
  }

  /// 发送消息
  Future<void> sendText(String content) async {
    ///消息加入chatRecords,GetX会以观察者模式的方式通知view去做更新
    print('加入消息: $content');
    chatRecords.add(MessageFactory.getMessage(
        TemplateText(
          type: 'text',
          content: content,
        ),
        true));
    // socket.send(sendFileInfo.toString());
  }

  // Future<void> scroll() async {
  //   // 让listview滚动到底部
  //   await Future.delayed(Duration(milliseconds: 100));
  //   scrollController.animateTo(
  //     scrollController.position.maxScrollExtent,
  //     duration: Duration(milliseconds: 100),
  //     curve: Curves.ease,
  //   );
  // }

  ///生命周期
  @override
  void onInit() {
    // TODO: implement onInit
    init();
    Log.d('size: ${chatRecords.length}');
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
