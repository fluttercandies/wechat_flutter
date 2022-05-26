class Manger {
  static final Manger _singleton = new Manger._internal();

  factory Manger() {
    return _singleton;
  }

  Manger._internal() {
    // initialization logic here
  }
// rest of the class
}

abstract class MessageListener {
  void makePeopleLaugh();
}
