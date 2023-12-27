import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_text_elem.dart';
import 'package:wechat_flutter/im/util/im_response_tip_util.dart';
import 'package:wechat_flutter/tools/chat/chat_memory.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

enum ButtonType { voice, more }

class ChatLogic extends GetxController {
  String? title;
  int? type = 1;
  String? id;

  List<V2TimMessage>? chatData = [];
  StreamSubscription<dynamic>? _msgStreamSubs;
  bool isVoice = false;
  bool isMore = false;
  bool emojiState = false;
  String? newGroupName;

  /// 最新消息id【可空】
  String? lastMsgID;

  TextEditingController textController = TextEditingController();
  FocusNode focusNode = new FocusNode();
  ScrollController sC = ScrollController();
  PageController pageC = new PageController();

  @override
  void onInit() {
    super.onInit();
    title = Get.arguments['title'];
    type = Get.arguments['type'];
    id = Get.arguments['id'];
    if (ChatMemory.chatData.containsKey(id)) {
      chatData = ChatMemory.chatData[id];
    }
  }

  @override
  void onReady() {
    super.onReady();

    getChatMsgData();

    /// 需要使用手势方式写，这种方式太卡了
    // sC.addListener(() => FocusScope.of(context).requestFocus(new FocusNode()));
    initPlatformState();
    Notice.addListener(WeChatActions.msg(), (v) {
      lastMsgID = null;
      getChatMsgData();
    });
    if (type == 2) {
      Notice.addListener(WeChatActions.groupName(), (v) {
        newGroupName = v;
        update();
      });
    }
    focusNode.addListener(() {
      if (focusNode.hasFocus) emojiState = false;
    });
  }

  Future getChatMsgData() async {
    if (type == 1) {
      chatData =
          (await ImMsgApi.getC2CHistoryMessageList(id!, lastMsgID)) ?? [];
      if (listNoEmpty(chatData)) {
        lastMsgID = chatData!.last.msgID;
      }
    } else {
      V2TimValueCallback<List<V2TimMessage>> result =
          await ImMsgApi.getGroupHistoryMessageList(id ?? title!);

      if (result.code != 200 && result.code != 0) {
        q1Toast(ImResponseTipUtil.getInfoOResultCode(result.code));
        return;
      }

      chatData = result.data;
      if (listNoEmpty(chatData)) {
        lastMsgID = chatData!.last.msgID;
      }
    }
    ChatMemory.chatData[id!] = chatData;
    update();
  }

  void insertText(String text) {
    var value = textController.value;
    var start = value.selection.baseOffset;
    var end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      textController.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      textController.value = TextEditingValue(
          text: text,
          selection:
              TextSelection.fromPosition(TextPosition(offset: text.length)));
    }

    /// 这里的SetState仅仅为了能显示和隐藏表情发送按钮
    update();
  }

  /// 删除表情等
  void deleteText() {
    var value = textController.value;
    var end = value.selection.extentOffset;

    if (value.selection.isValid) {
      String text = textController.value.text.endsWith("]") &&
              textController.value.text.contains("[")
          ? "[" + textController.value.text.split('[').last
          : textController.value.text.substring(
              textController.value.text.length - 1,
              textController.value.text.length);

      textController.value = value.copyWith(
          text: textController.value.text
              .substring(0, textController.value.text.length - text.length),
          selection: value.selection.copyWith(
              baseOffset: end - text.length, extentOffset: end - text.length));
    }

    /// 这里的SetState仅仅为了能显示和隐藏表情发送按钮
    update();
  }

  void canCelListener() {
    if (_msgStreamSubs != null) _msgStreamSubs!.cancel();
  }

  Future<void> initPlatformState() async {
    // if (!mounted) return;

    if (_msgStreamSubs == null) {
      // _msgStreamSubs =
      //     im.onMessage.listen((dynamic onData) => getChatMsgData());
    }
  }

  handleSubmittedData(BuildContext context) async {
    String text = textController.text;
    final model = Provider.of<GlobalModel>(context, listen: false);
    textController.clear();
    chatData!.insert(
      0,
      new V2TimMessage(
          textElem: V2TimTextElem(text: text),
          sender: strNoEmpty(Q1Data.user())
              ? Q1Data.user()
              : (await SharedUtil.instance!.getString(Keys.account)),
          id: '1',
          faceUrl: model.avatar,
          elemType: 9),
    );
    String senToUserId = '${id ?? title}';
    await ImMsgApi.sendTextMessage(
      text,
      receiver: type == 1 ? senToUserId : "",
      groupID: type != 1 ? senToUserId : "",
    );
    update();

    /// 事件总线发送，让其他地方同步消息
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      msgBus.fire(MsgBusModel(id));
    });
  }

  onTapHandle(ButtonType type) {
    if (type == ButtonType.voice) {
      focusNode.unfocus();
      isMore = false;
      isVoice = !isVoice;
    } else {
      isVoice = false;
      if (focusNode.hasFocus) {
        focusNode.unfocus();
        isMore = true;
      } else {
        isMore = !isMore;
      }
    }
    emojiState = false;
    update();
  }

  @override
  void onClose() {
    super.onClose();

    canCelListener();
    Notice.removeListenerByEvent(WeChatActions.msg());
    Notice.removeListenerByEvent(WeChatActions.groupName());
    sC.dispose();
  }
}
