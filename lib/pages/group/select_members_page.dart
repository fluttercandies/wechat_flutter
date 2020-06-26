import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:azlistview/azlistview.dart';

import 'package:lpinyin/lpinyin.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SelectMembersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SelectMembersPageState();
  }
}

class _SelectMembersPageState extends State<SelectMembersPage> {
  List<ContactInfoModel> _contacts = List();

  int _suspensionHeight = 30;
  int _itemHeight = 60;
  double _headHeight = 60;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List selects = [];

  void loadData() async {
    //加载联系人列表
    rootBundle.loadString('assets/data/contacts.json').then((value) {
      List list = json.decode(value);
      list.forEach((value) {
        _contacts.add(ContactInfoModel(name: value['name']));
      });
      _handleList(_contacts);
      setState(() {});
    });
  }

  void _handleList(List<ContactInfoModel> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(list);
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: _suspensionHeight.toDouble(),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      color: appBarColor,
      child: Text(
        '$susTag',
        textScaleFactor: 1.2,
        style: TextStyle(
          color: Color(0xff333333),
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildListItem(ContactInfoModel model) {
    String uFace = '';
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: new InkWell(
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.symmetric(horizontal: mainSpace * 1.5),
                  child: new Icon(
                    model.isSelect
                        ? CupertinoIcons.check_mark_circled_solid
                        : CupertinoIcons.check_mark_circled,
                    color: model.isSelect ? Colors.green : Colors.grey,
                  ),
                ),
                new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: !strNoEmpty(uFace)
                      ? new Image.asset(
                          defIcon,
                          height: 48.0,
                          width: 48.0,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: uFace,
                          height: 48.0,
                          width: 48.0,
                          cacheManager: cacheManager,
                          fit: BoxFit.cover,
                        ),
                ),
                new Space(),
                new Expanded(
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: 30),
                    height: _itemHeight.toDouble(),
                    decoration: BoxDecoration(
                      border: !model.isShowSuspension
                          ? Border(
                              top: BorderSide(color: lineColor, width: 0.2))
                          : null,
                    ),
                    child: new Text(
                      model.name,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              model.isSelect = !model.isSelect;
              if (model.isSelect) {
                selects.insert(0, model);
              } else {
                selects.remove(model);
              }
              setState(() {});
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(
        title: '选择联系人',
        rightDMActions: <Widget>[
          new ComMomButton(
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            onTap: () {
              if (!listNoEmpty(selects)) {
                showToast(context, '请选择要添加的成员');
              }
            },
            text: '确定',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: AzListView(
        data: _contacts,
        itemBuilder: (context, model) => _buildListItem(model),
        isUseRealIndex: true,
        itemHeight: _itemHeight,
        suspensionHeight: _suspensionHeight,
        header: AzListViewHeader(
          height: _headHeight.toInt(),
          builder: (context) {
            String uFace = '';

            if (!listNoEmpty(selects)) {
              return new Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: new Row(
                  children: <Widget>[
                    new Icon(
                      CupertinoIcons.search,
                      color: Colors.grey,
                    ),
                    new Space(),
                  ],
                ),
              );
            }
            return new ListView(
              scrollDirection: Axis.horizontal,
              children: selects.map((item) {
                return new UnconstrainedBox(
                  child: new Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: !strNoEmpty(uFace)
                          ? new Image.asset(
                        defIcon,
                        height: 48.0,
                        width: 48.0,
                        fit: BoxFit.cover,
                      )
                          : CachedNetworkImage(
                        imageUrl: uFace,
                        height: 48.0,
                        width: 48.0,
                        cacheManager: cacheManager,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class ContactInfoModel extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;
  bool isSelect;

  ContactInfoModel({
    this.name = 'aTest',
    this.tagIndex = 'A',
    this.namePinyin = 'A',
    this.isSelect = false,
  });

  ContactInfoModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] == null ? "" : json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'tagIndex': tagIndex,
        'namePinyin': namePinyin,
        'isShowSuspension': isShowSuspension,
        'isSelect': isSelect,
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => "CityBean {" + " \"name\":\"" + name + "\"" + '}';
}
