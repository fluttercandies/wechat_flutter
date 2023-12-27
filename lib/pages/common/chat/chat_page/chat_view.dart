import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/pages/common/chat/chat_info_page.dart';
import 'package:wechat_flutter/pages/common/chat/chat_more_page.dart';
import 'package:wechat_flutter/pages/common/group/group_details_page.dart';
import 'package:wechat_flutter/tools/config/q1_config.dart';
import 'package:wechat_flutter/tools/func/func.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/chat/chat_details_body.dart';
import 'package:wechat_flutter/ui/chat/chat_details_row.dart';
import 'package:wechat_flutter/ui/edit/emoji_text.dart';
import 'package:wechat_flutter/ui/edit/text_span_builder.dart';
import 'package:wechat_flutter/ui/item/chat_more_icon.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';
import 'package:wechat_flutter/ui_commom/bt/small_button.dart';

import 'chat_logic.dart';

class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>();

  Widget edit(context, size) {
    // 计算当前的文本需要占用的行数
    TextSpan _text = TextSpan(
        text: logic.textController.text, style: AppStyles.ChatBoxTextStyle);

    TextPainter _tp = TextPainter(
        text: _text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left);
    _tp.layout(maxWidth: size.maxWidth);

    return ExtendedTextField(
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      onTap: () {
        if (logic.focusNode.hasFocus) logic.emojiState = false;
        logic.update();
      },
      onChanged: (v) => logic.update(),
      decoration: InputDecoration(
          border: InputBorder.none, contentPadding: const EdgeInsets.all(5.0)),
      controller: logic.textController,
      focusNode: logic.focusNode,
      maxLines: 99,
      cursorColor: const Color(AppColors.ChatBoxCursorColor),
      style: AppStyles.ChatBoxTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget emojiWidget() {
      return Stack(
        children: [
          new GestureDetector(
            child: new Container(
              height: logic.emojiState ? AppConfig.keyboardHeight - 10 : 0,
              child: GridView.builder(
                padding:
                    EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return MyInkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.5),
                      child: Image.asset(
                          EmojiUitl.instance!.emojiMap["[${index + 1}]"]!),
                    ),
                    onTap: () {
                      logic.insertText("[${index + 1}]");
                    },
                  );
                },
                itemCount: EmojiUitl.instance!.emojiMap.length,
              ),
            ),
            onTap: () {},
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Color(AppColors.ChatBoxBg),
                boxShadow: [
                  BoxShadow(
                    color: Color(AppColors.ChatBoxBg),
                    blurRadius: 25,
                    spreadRadius: 30,
                  ),
                ],
              ),
              child: () {
                bool canClick = strNoEmpty(logic.textController.text);
                return ButtonBar(
                  children: [
                    SmallButton(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      width: 60,
                      isCanMultipleClick: true,
                      onPressed: () {
                        if (!canClick) {
                          return;
                        }
                        logic.deleteText();
                      },
                      color: Colors.white,
                      child: Icon(
                        Icons.delete_forever_rounded,
                        color: canClick
                            ? Colors.black
                            : Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Space(
                      width: 5,
                    ),
                    SmallButton(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      width: 60,
                      color: canClick ? null : Colors.white,
                      onPressed: () {
                        if (!canClick) {
                          return;
                        }
                        logic.handleSubmittedData(context);
                      },
                      child: Text(
                        '发送',
                        style: TextStyle(
                            color: canClick
                                ? Colors.white
                                : Colors.black.withOpacity(0.2)),
                      ),
                    ),
                  ],
                );
              }(),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: new ComMomBar(
        title: logic.newGroupName ?? logic.title,
        rightDMActions: [
          new InkWell(
            child: new Image.asset('assets/images/right_more.png'),
            onTap: () => Get.to(logic.type == 2
                ? new GroupDetailsPage(
                    logic.id ?? logic.title,
                    callBack: (v) {},
                  )
                : new ChatInfoPage(logic.id)),
          )
        ],
      ),
      body: GetBuilder<ChatLogic>(
        builder: (logic) {
          return new MainInputBody(
            onTap: () {
              logic.isMore = false;
              logic.emojiState = false;
              logic.update();
            },
            decoration: BoxDecoration(color: chatBg),
            child: new Column(
              children: [
                logic.chatData != null
                    ? new ChatDetailsBody(
                        sC: logic.sC, chatData: logic.chatData)
                    : new Spacer(),
                Container(
                  color: Color(AppColors.ChatBoxBg),
                  child: SafeArea(
                    bottom: !logic.emojiState,
                    child: Column(
                      children: [
                        new ChatDetailsRow(
                          voiceOnTap: () => logic.onTapHandle(ButtonType.voice),
                          onEmojio: () {
                            if (logic.isMore) {
                              logic.emojiState = true;
                            } else {
                              logic.emojiState = !logic.emojiState;
                            }
                            if (logic.emojiState) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              logic.isMore = false;
                            }
                            logic.update();
                          },
                          isVoice: logic.isVoice,
                          edit: edit,
                          more: new ChatMoreIcon(
                            value: logic.textController.text,
                            onTap: () => logic.handleSubmittedData(context),
                            moreTap: () => logic.onTapHandle(ButtonType.more),
                            isEmoji: logic.emojiState,
                          ),
                          id: logic.id,
                          type: logic.type,
                        ),
                        new Visibility(
                          visible: logic.emojiState,
                          child: emojiWidget(),
                        ),
                        new Container(
                          height: logic.isMore &&
                                  !logic.focusNode.hasFocus &&
                                  !logic.emojiState
                              ? AppConfig.keyboardHeight -
                                  Q1Config.chatRowHeight -
                                  30
                              : 0.0,
                          width: FrameSize.winWidth(),
                          color: Color(AppColors.ChatBoxBg),
                          child: new IndicatorPageView(
                            pageC: logic.pageC,
                            pages: List.generate(2, (index) {
                              return new ChatMorePage(
                                index: index,
                                id: logic.id,
                                type: logic.type,
                                keyboardHeight: AppConfig.keyboardHeight,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
