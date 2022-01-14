import 'dart:math';

class FileUtils {
  static String getFileSize(int size) {
    String _human = '';
    if (size < 1024) {
      _human = '$size Byte';
    } else if (size >= 1024 && size < pow(1024, 2)) {
      size = (size / 10.24).round();
      _human = '${size / 100} KB';
    } else if (size >= pow(1024, 2) && size < pow(1024, 3)) {
      size = (size / (pow(1024, 2) * 0.01)).round();
      _human = '${size / 100} MB';
    } else if (size >= pow(1024, 3) && size < pow(1024, 4)) {
      size = (size / (pow(1024, 3) * 0.01)).round();
      _human = '${size / 100} GB';
    }
    return _human;
  }
}
