import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/pages/common/more/add_friend_details.dart';
import 'package:wechat_flutter/tools/entity/api_entity.dart';
import 'package:wechat_flutter/tools/http/api_v2.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class AddFriendLogic extends GetxController {
  bool isSearch = false;
  bool showBtn = false;
  bool isResult = false;

  String? currentUser;

  FocusNode searchF = new FocusNode();
  TextEditingController searchC = new TextEditingController();

  @override
  void onReady() {
    super.onReady();
    getUser();
  }

  getUser() async {
    currentUser = null;
    update();
  }

  unFocusMethod() {
    searchF.unfocus();
    isSearch = false;
    if (isResult) isResult = !isResult;
    update();
  }

  // 搜索好友
  Future search(String userName) async {

    final List<V2TimUserFullInfo>? data = await ImApi.getUsersInfo([userName]);
    if (!listNoEmpty(data)) {
      isResult = true;
      update();
      return;
    }

    final V2TimUserFullInfo value = data!.first;

    /// 如果是搜索自己的话直接提示出来
    if (value.userID == Q1Data.user()) {
      q1Toast('你不能添加自己到通讯录');
      return;
    }

    final List<V2TimUserFullInfo>? userInfoList =
        await ImApi.getUsersInfo([value.userID!]);

    /// 获取用户信息失败了
    if (!listNoEmpty(userInfoList)) {
      isResult = true;
      update();
      return;
    }

    V2TimUserFullInfo model = userInfoList![0];
    if (model.allowType != null) {
      Get.to(new AddFriendsDetails(
          'search', model.userID, model.faceUrl, model.nickName, model.gender));
    } else {
      isResult = true;
    }
    update();
  }

  void onChange(String txt) {
    if (strNoEmpty(searchC.text))
      showBtn = true;
    else
      showBtn = false;
    if (isResult) isResult = false;

    update();
  }
}
