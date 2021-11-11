import 'dart:io';

///运行平台的文件路径

class RuntimeEnv {
  static String _binKey = 'BIN';
  static String _tmpKey = 'TMP';
  static String _homeKey = 'HOME';
  static String _filesKey = 'FILES';
  static String _usrKey = 'USR';

// 在安卓端是沙盒路径
  static String _dataKey = 'DATA';
  static String _pathKey = 'PATH';

  static Map<String, String> _environment = {};
  static String? _packageName;
  static bool _init = false;

  static String? get packageName => _packageName;

//singleton
  static late final RuntimeEnv _instance;

  static get instance {
    if (_instance == null) {
      _instance = new RuntimeEnv._internal();
    }
    return _instance;
  }

  RuntimeEnv._internal();

  static void initEnvWithPackageName(String packageName) {
    if(_init){
      return;
    }
    _packageName = packageName;
    if (!Platform.isAndroid) {
      _initEnvForDesktop();
      return;
    }
    _environment[_dataKey] = '/data/data/$packageName';
    _environment[_filesKey] = '${_environment[_dataKey]}/files';
    _environment[_usrKey] = '${_environment[_filesKey]}/usr';
    _environment[_binKey] = '${_environment[_usrKey]}/bin';
    _environment[_homeKey] = '${_environment[_filesKey]}/home';
    _environment[_tmpKey] = '${_environment[_usrKey]}/tmp';
    _environment[_pathKey] =
        '${_environment[_binKey]}:' + Platform.environment['PATH']!;
    _init = true;
  }

  static void _initEnvForDesktop() {
    if (_init) {
      return;
    }
    String dataPath = FileSystemEntity.parentOf(Platform.resolvedExecutable) +
        Platform.pathSeparator +
        'data';
    Directory dataDir = Directory(dataPath);
    if (!dataDir.existsSync()) {
      dataDir.createSync();
    }
    _environment[_dataKey] = dataPath;
    _environment[_filesKey] = dataPath;
    _environment[_usrKey] = '$dataPath${Platform.pathSeparator}usr';
    _environment[_binKey] =
        '${_environment[_usrKey]}${Platform.pathSeparator}bin';
    _environment[_homeKey] = '$dataPath${Platform.pathSeparator}home';
    _environment[_tmpKey] =
        '${_environment[_usrKey]}${Platform.pathSeparator}tmp';

  }

  static void write(String key, String value) {
    _environment[key] = value;
  }

  static String getValue(String key) {
    if (_environment.containsKey(key)) {
      return _environment[key]!;
    }
    return '';
  }

  static String get binPath {
    if (_environment.containsKey(_binKey)) {
      return _environment[_binKey]!;
    }
    throw Exception();
  }

  /// 这是是 PATH 这个变量的值
  static String get path {
    if (_environment.containsKey(_pathKey)) {
      return _environment[_pathKey]!;
    }
    throw Exception();
  }

  static String get dataPath {
    if (_environment.containsKey(_dataKey)) {
      return _environment[_dataKey]!;
    }
    throw Exception();
  }

  static set binPath(String value) {
    _environment[_binKey] = value;
  }

  static String get usrPath {
    if (_environment.containsKey(_usrKey)) {
      return _environment[_usrKey]!;
    }
    throw Exception();
  }

  static set usrPath(String value) {
    _environment[_usrKey] = value;
  }

  static String get tmpPath {
    if (_environment.containsKey(_tmpKey)) {
      return _environment[_tmpKey]!;
    }
    throw Exception();
  }

  static set tmpPath(String value) {
    _environment[_tmpKey] = value;
  }

  static String get homePath {
    if (_environment.containsKey(_homeKey)) {
      return _environment[_homeKey]!;
    }
    throw Exception();
  }

  static set homePath(String value) {
    _environment[_homeKey] = value;
  }

  static String get filesPath {
    if (_environment.containsKey(_filesKey)) {
      return _environment[_filesKey]!;
    }
    throw Exception();
  }

  static set filesPath(String value) {
    _environment[_filesKey] = value;
  }
}
