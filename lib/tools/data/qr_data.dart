enum QrDataType { group, personal }

class QrData {
  static String code = "C2FC19F47B36C916212E5B4F63F408F8";

  static String generateData(bool isGroup, String id) {
    return "${isGroup ? QrDataType.group.toString() : QrDataType.personal.toString()},$id;;;${code * 3};;;${DateTime.now()}";
  }

  static bool isSelfCode(String qrData) {
    return qrData.contains(code);
  }

  /// 数组索引0为类型，1为id。
  static List<String> fetchData(String qrData) {
    return qrData.split(';;;')[0].split(',');
  }
}
