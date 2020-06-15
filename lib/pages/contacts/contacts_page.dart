import 'package:wechat_flutter/config/dictionary.dart';
import 'package:wechat_flutter/im/model/contacts.dart';
import 'package:wechat_flutter/ui/item/contact_view.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/item/contact_item.dart';

class ContactsPage extends StatefulWidget {
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  var indexBarBg = Colors.transparent;
  var currentLetter = '';
  var isNull = false;

  ScrollController sC;
  List<Contact> _contacts = [];
  StreamSubscription<dynamic> _messageStreamSubscription;

  List<ContactItem> _functionButtons = [
    new ContactItem(
        avatar: contactAssets + 'ic_new_friend.webp', title: '新的朋友'),
    new ContactItem(avatar: contactAssets + 'ic_group.webp', title: '群聊'),
    new ContactItem(avatar: contactAssets + 'ic_tag.webp', title: '标签'),
    new ContactItem(avatar: contactAssets + 'ic_no_public.webp', title: '公众号'),
  ];
  final Map _letterPosMap = {INDEX_BAR_WORDS[0]: 0.0};

  Future getContacts() async {
    final str = await ContactsPageData().listFriend();
    isNull = await ContactsPageData().contactIsNull();

    List<Contact> listContact = str;
    _contacts.clear();
    _contacts..addAll(listContact);
    _contacts
        .sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
    sC = new ScrollController();

    /// 计算用于 IndexBar 进行定位的关键通讯录列表项的位置
    var _totalPos =
        _functionButtons.length * ContactItemState.heightItem(false);
    for (int i = 0; i < _contacts.length; i++) {
      bool _hasGroupTitle = true;
      if (i > 0 &&
          _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0)
        _hasGroupTitle = false;

      if (_hasGroupTitle) _letterPosMap[_contacts[i].nameIndex] = _totalPos;

      _totalPos += ContactItemState.heightItem(_hasGroupTitle);
    }
    if (mounted) setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    if (sC != null) sC.dispose();
    canCelListener();
  }

  String _getLetter(BuildContext context, double tileHeight, Offset globalPos) {
    RenderBox _box = context.findRenderObject();
    var local = _box.globalToLocal(globalPos);
    int index = (local.dy ~/ tileHeight).clamp(0, INDEX_BAR_WORDS.length - 1);
    return INDEX_BAR_WORDS[index];
  }

  void _jumpToIndex(String letter) {
    if (_letterPosMap.isNotEmpty) {
      final _pos = _letterPosMap[letter];
      if (_pos != null)
        sC.animateTo(_pos,
            curve: Curves.easeOut, duration: Duration(milliseconds: 200));
    }
  }

  Widget _buildIndexBar(BuildContext context, BoxConstraints constraints) {
    final List<Widget> _letters = INDEX_BAR_WORDS
        .map((String word) =>
            new Expanded(child: new Text(word, style: TextStyle(fontSize: 12))))
        .toList();

    final double _totalHeight = constraints.biggest.height;
    final double _tileHeight = _totalHeight / _letters.length;

    void jumpTo(details) {
      indexBarBg = Colors.black26;
      currentLetter = _getLetter(context, _tileHeight, details.globalPosition);
      _jumpToIndex(currentLetter);
      setState(() {});
    }

    void transparentMethod() {
      indexBarBg = Colors.transparent;
      currentLetter = null;
      setState(() {});
    }

    return new GestureDetector(
      onVerticalDragDown: (DragDownDetails details) => jumpTo(details),
      onVerticalDragEnd: (DragEndDetails details) => transparentMethod(),
      onVerticalDragUpdate: (DragUpdateDetails details) => jumpTo(details),
      child: new Column(children: _letters),
    );
  }

  @override
  void initState() {
    super.initState();
    getContacts();
    initPlatformState();
  }

  void canCelListener() {
    if (_messageStreamSubscription != null) _messageStreamSubscription.cancel();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    if (_messageStreamSubscription == null) {
      _messageStreamSubscription =
          im.onMessage.listen((dynamic onData) => getContacts());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<Widget> body = [
      new ContactView(
          sC: sC, functionButtons: _functionButtons, contacts: _contacts),
      new Positioned(
        width: Constants.IndexBarWidth,
        right: 0.0,
        top: 120.0,
        bottom: 120.0,
        child: new Container(
          color: indexBarBg,
          child: new LayoutBuilder(builder: _buildIndexBar),
        ),
      ),
    ];

    if (isNull) body.add(new HomeNullView(str: '无联系人'));

    if (currentLetter != null && currentLetter.isNotEmpty) {
      var row = [
        new Container(
            width: Constants.IndexLetterBoxSize,
            height: Constants.IndexLetterBoxSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.IndexLetterBoxBg,
              borderRadius: BorderRadius.all(
                  Radius.circular(Constants.IndexLetterBoxSize / 2)),
            ),
            child: new Text(currentLetter,
                style: AppStyles.IndexLetterBoxTextStyle)),
        new Icon(Icons.arrow_right),
        new Space(width: mainSpace * 5),
      ];
      body.add(
        new Container(
          width: winWidth(context),
          height: winHeight(context),
          child:
              new Row(mainAxisAlignment: MainAxisAlignment.end, children: row),
        ),
      );
    }
    return new Scaffold(body: new Stack(children: body));
  }
}
