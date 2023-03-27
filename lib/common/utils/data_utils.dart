import 'dart:convert';

import 'package:flutter_studytwo/common/const/data.dart';

class DataUtils{
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain); //입력 받은 파라미터를 바꿀 것이다.

    return encoded;
  }
}