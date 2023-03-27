import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCEXSS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

//localhost
final emulatorIp = '10.0.2.2:3000'; //에뮬레이터 기준
final simulatorIp = '127.0.0.1:3000'; //시뮬레이터 기준

final ip = Platform.isAndroid ? emulatorIp : simulatorIp;