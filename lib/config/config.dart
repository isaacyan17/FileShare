class Config {
  Config._();

  ///启动一个room聊天室的端口
  static int serverPort = 8007;
  static int roomPort = 7001;
  static int filePort = 8001;

  static String packageName = 'com.isaac.file_share';
  ///文件存储路径
///Android目录下:
 static String pathAndroid = '/sdcard/fileShare';
}
