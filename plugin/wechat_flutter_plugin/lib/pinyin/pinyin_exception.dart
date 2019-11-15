/// Pinyin Exception.
class PinyinException implements Exception {
  String message;

  PinyinException([this.message]);

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
