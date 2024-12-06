import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/dictionary.dart';
import '../../im/model/contacts.dart';
import '../../tools/event/im_event.dart';
import '../../tools/wechat_flutter.dart';
import '../../ui/item/contact_item.dart';
import '../../ui/item/contact_view.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  Color indexBarBg = Colors.transparent;
  String? currentLetter = '';
  bool isNull = false;

  ScrollController? sC;
  final List<Contact> _contacts = <Contact>[];
  StreamSubscription<dynamic>? _msgStreamSubs;

  final List<ContactItem> _functionButtons = <ContactItem>[
    ContactItem(avatar: '${contactAssets}ic_new_friend.webp', title: '新的朋友'),
    ContactItem(avatar: '${contactAssets}ic_group.webp', title: '群聊'),
    ContactItem(avatar: '${contactAssets}ic_tag.webp', title: '标签'),
    ContactItem(avatar: '${contactAssets}ic_no_public.webp', title: '公众号'),
  ];
  final Map<String, double> _letterPosMap = <String, double>{
    INDEX_BAR_WORDS[0]: 0.0
  };

  Future<void> getContacts() async {
    final List<Contact> str = await ContactsPageData().listFriend();
    isNull = await ContactsPageData().contactIsNull();

    final List<Contact> listContact = str;
    _contacts.clear();
    _contacts.addAll(listContact);
    _contacts
        .sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
    sC = ScrollController();

    /// 计算用于 IndexBar 进行定位的关键通讯录列表项的位置
    double totalPos =
        _functionButtons.length * ContactItemState.heightItem(false);
    for (int i = 0; i < _contacts.length; i++) {
      bool hasGroupTitle = true;
      if (i > 0 &&
          _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0) {
        hasGroupTitle = false;
      }

      if (hasGroupTitle) {
        _letterPosMap[_contacts[i].nameIndex] = totalPos;
      }

      totalPos += ContactItemState.heightItem(hasGroupTitle);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    if (sC != null) {
      sC!.dispose();
    }
    canCelListener();
  }

  String _getLetter(BuildContext context, double tileHeight, Offset globalPos) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset local = box.globalToLocal(globalPos);
    final int index =
        (local.dy ~/ tileHeight).clamp(0, INDEX_BAR_WORDS.length - 1);
    return INDEX_BAR_WORDS[index];
  }

  void _jumpToIndex(String letter) {
    if (_letterPosMap.isNotEmpty) {
      final double? pos = _letterPosMap[letter];
      if (pos != null) {
        sC!.animateTo(pos,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 200));
      }
    }
  }

  Widget _buildIndexBar(BuildContext context, BoxConstraints constraints) {
    final List<Widget> letters = INDEX_BAR_WORDS
        .map((String word) =>
            Expanded(child: Text(word, style: const TextStyle(fontSize: 12))))
        .toList();

    final double totalHeight = constraints.biggest.height;
    final double tileHeight = totalHeight / letters.length;

    void jumpTo(Offset globalPosition) {
      indexBarBg = Colors.black26;
      currentLetter = _getLetter(context, tileHeight, globalPosition);
      _jumpToIndex(currentLetter!);
      setState(() {});
    }

    void transparentMethod() {
      indexBarBg = Colors.transparent;
      currentLetter = null;
      setState(() {});
    }

    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) =>
          jumpTo(details.globalPosition),
      onVerticalDragEnd: (DragEndDetails details) => transparentMethod(),
      onVerticalDragUpdate: (DragUpdateDetails details) =>
          jumpTo(details.globalPosition),
      child: Column(children: letters),
    );
  }

  @override
  void initState() {
    super.initState();
    getContacts();
    initPlatformState();
  }

  void canCelListener() {
    if (_msgStreamSubs != null) {
      _msgStreamSubs!.cancel();
    }
  }

  Future<void> initPlatformState() async {
    if (!mounted) {
      return;
    }

    _msgStreamSubs ??= eventBusNewMsg.listen((EventBusNewMsg onData) {
      getContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<Widget> body = <Widget>[
      ContactView(
          sC: sC, functionButtons: _functionButtons, contacts: _contacts),
      Positioned(
        width: Constants.IndexBarWidth,
        right: 0.0,
        top: 120.0,
        bottom: 120.0,
        child: Container(
          color: indexBarBg,
          child: LayoutBuilder(builder: _buildIndexBar),
        ),
      ),
    ];

    if (isNull) {
      body.add(HomeNullView(str: '无联系人'));
    }

    if (currentLetter != null && currentLetter!.isNotEmpty) {
      final List<Widget> row = <Widget>[
        Container(
            width: Constants.IndexLetterBoxSize,
            height: Constants.IndexLetterBoxSize,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.IndexLetterBoxBg,
              borderRadius: BorderRadius.all(
                  Radius.circular(Constants.IndexLetterBoxSize / 2)),
            ),
            child:
                Text(currentLetter!, style: AppStyles.IndexLetterBoxTextStyle)),
        const Icon(Icons.arrow_right),
        const SizedBox(width: mainSpace * 5),
      ];
      body.add(
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: row),
        ),
      );
    }
    return Scaffold(body: Stack(children: body));
  }
}
