import 'dart:collection';

import 'package:dim/pinyin/dict_data.dart';

/// Pinyin Resource.
class PinyinResource {
  static Map<String, String> getPinyinResource() {
    return getResource(PINYIN_DICT);
  }

  static Map<String, String> getChineseResource() {
    return getResource(CHINESE_DICT);
  }

  static Map<String, String> getMultiPinyinResource() {
    return getResource(MULTI_PINYIN_DICT);
  }

  static Map<String, String> getResource(List<String> list) {
    Map<String, String> map = new HashMap();
    List<MapEntry<String, String>> mapEntryList = new List();
    for (int i = 0, length = list.length; i < length; i++) {
      List<String> tokens = list[i].trim().split("=");
      MapEntry<String, String> mapEntry = new MapEntry(tokens[0], tokens[1]);
      mapEntryList.add(mapEntry);
    }
    map.addEntries(mapEntryList);
    return map;
  }
}
