import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_share/config/config.dart';
import 'package:file_share/server/model/message_factory.dart';
import 'package:file_share/server/model/template_message_file.dart';
import 'package:file_share/server/model/template_message_text.dart';
import 'package:file_share/server/model/template_message_tip.dart';
import 'package:file_share/server/server.dart';
import 'package:file_share/utils/FileUtil.dart';
import 'package:file_share/utils/http/platform_utils.dart';
import 'package:file_share/utils/log.dart';
import 'package:file_share/utils/shelf/static_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf_io.dart' as shelfIo;

/// 对于Getx的状态管理和路由，详见 : https://juejin.cn/post/6997283367045562375
/// or https://github.com/jonataslaw/getx/blob/master/documentation/zh_CN/state_management.md
///TODO Android - web的平台差异大, 我们目前可以实现Android - Android的局域网传输
///TODO 现在需要实现Android - web的局域网传输, 这一步还需要: web的localAddress, web file 的部署路径
class RoomController extends GetxController {
  late GetSocket socket;
  bool connectState = false;
  FocusNode focusNode = FocusNode();
  TextEditingController editController = TextEditingController();
  ///页面控制元素
  final collapse = RxBool(true);

  ///保存本机IP地址集
  late List<String> mLocalAddress;

  //新加入的client
  // final freshMan = RxBool(true);

  ///存放room的消息记录
  List<dynamic> chatRecords = <dynamic>[].obs;

  Future<void> init({bool freshMan :false,String? address} ) async {
    ///打开websocket server
    print('init,fresh: $freshMan, address: $address');
    if (freshMan) {
      Server.createServerPage();
    }
    var adr;
    if(!GetPlatform.isWeb){
      adr = 'http://127.0.0.1:${Config.roomPort}/room';
    }else{
      adr = '$address/room';
    }
    socket = GetSocket(adr);
    socket.onOpen(() {
      Log.d('连接成功');
      //发送消息
      ///socket连接成功后，发送一个join动作。
      socket.send(jsonEncode({
        'type': "join",
        'name': GetPlatform.isWeb?'web':'android',
      }));
      connectState = true;
    });
    try {
      socket.connect();
      await Future.delayed(Duration.zero);
    } catch (e) {
      Log.d('connect e --> $e');
      connectState = false;
    }
    await sendInitialSuccess();

    ///socket listener
    socketListener();
  }

  ///ws监听
  void socketListener() {
    socket.on('join', (val) {
      print('join: $val');
    });

    socket.onMessage((val) async {
      Log.i('message received: $val');
      try {
        Map<String, dynamic> map = jsonDecode(val);
        if (map.isNotEmpty) {
          if (map['type'] == 'join') {
            chatRecords.add(MessageFactory.getMessage(
              TemplateTip(content: map['msg']),
            ));
          }else {
            var message = MessageFactory.getMessage(MessageFactory.fromJson(map));
            Log.i(message);

            chatRecords.add(message);
          }
        }
      } catch (e) {
        Log.d('e --> $e');
      }
    });

    socket.onClose((close) {
      print('断开与服务器的连接');
    });

    // socket.emit('event', 'you data');
    //
    // socket.send('data');

  }

  Future<void> sendInitialSuccess() async {
    String msg = '使用浏览器直接打开以下url，'
        '只有同局域网下的设备能打开';
    sendText(msg,byServer: true);
    PlatformUtil.localAddress().then((value) {
      Log.d(value);
      if (value.isEmpty) {
        sendText('未发现局域网IP',byServer: true);
      } else {
        mLocalAddress = value;
        sendText('http://${value.toString()}:${Config.roomPort}',byServer: true);
      }
    });

  }

  /// 发送消息
  Future<void> sendText(String content,{bool? byServer}) async {
    ///消息加入chatRecords,GetX会以观察者模式的方式通知view去做更新

    ///使用 ?? 可以为某个空值设置一个默认值 , 如果某个值没有获取到 ,
    ///或者获取到为空 , 可以为该变量或表达式设置一个默认值 ;

    TemplateText templateText = TemplateText(
      type: 'text',
      content: content,
    );
    chatRecords.add(MessageFactory.getMessage(
        templateText,
        sendByServer: byServer??false));

        // if(!(byServer??false)){
          socket.send(templateText.toString());
        // }
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
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    // init();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  ///发送输入框输入的文本信息
  void sendTextMessage({bool? sendByUser}){
    sendText(editController.text,byServer: sendByUser);
    editController.clear();

  }

  /// 获取粘贴板上的信息,并复制到输入框
  void updateClipboardData() async{
     ClipboardData? val =  await Clipboard.getData(Clipboard.kTextPlain);
     if(val!=null){
       //给val? 设置默认值 ''
       editController.text = val.text ?? '';
     }
  }

  Future<void> copyToClipboard(String s) async{
     Clipboard.setData(ClipboardData(text: s));
  }

  /// 选择文件: 打开文件夹
  Future<void> openDir() async{
   FilePickerResult? result =  await FilePicker.platform.pickFiles();
   if (result != null) {
     Log.d(result.files);
     List<PlatformFile> platFiles = result.files;
     for(var f in platFiles){
       prepareToDeployFile(f);
     }

     // List<File> files = result.paths.map((path) => File(path!)).toList();
     // Log.d(files);
   } else {
     // User canceled the picker
     Log.e('没有获取到文件');
   }

  }

  Future<TemplateFile> sendFileToChat(PlatformFile f,{bool sendBySelf = false}) async{
    String url = '';
    if(GetPlatform.isWeb){
      ///todo web的IP地址
      // url = 'http://127.0.0.1:7001';
    }else
      url = 'http://${mLocalAddress[0]}:${Config.roomPort}';

    TemplateFile templateFile = TemplateFile(url,
        fileName:f.name,
        fileSize: FileUtils.getFileSize(f.size),
        path: GetPlatform.isWeb? f.bytes.toString(): f.path,
       type: 'file'
      );
    chatRecords.add(MessageFactory.getMessage(
        templateFile,
        sendByServer: sendBySelf));
    return templateFile;
  }

  ///将文件部署到服务上,方便其他订阅者接收
  ///第一步, 将文件显示在聊天列表中
  ///第二步,将文件部署在一个对外服务中

  Future<void>prepareToDeployFile(PlatformFile f,{bool sendBySelf = false}) async{
    if(!GetPlatform.isWeb) {
      if (f.path == null) {
        return;
      }
    }
    ///web 端选择文件的问题: https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ
    if(!GetPlatform.isWeb)
      deployServer(f.path!);
    TemplateFile file = await sendFileToChat(f,sendBySelf: true);
    /// 将消息发送给其他正在room的客户端
    socket.send(file.toString());
  }

  ///开启服务部署这个文件
  Future<void> deployServer(String path) async {
    String filePath = path.replaceAll('\\', '/');
    filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
    filePath = filePath.replaceAll(RegExp('^/'), '');
    // Path
    String url = p.toUri(filePath).toString();
    Log.i('准备部署的url: $url');

    ///这里我们需要开一个本地服务,提供一个http链接,并且处理request和response
    ///我们要通过这个服务,将文件传输出去

    var handler = createFileHandler(path, url: url);
    shelfIo.serve(handler, InternetAddress.anyIPv4, Config.filePort,
        shared: true);
  }


}
