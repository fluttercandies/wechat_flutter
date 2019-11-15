import 'package:flutter/material.dart';

OverlayEntry showDialogTipView(BuildContext context, int index, int type) {
   Widget img() {
    if (0 <= index && index <= 16) {
      return Image.asset('assets/images/chat/3.0x/dialog_audio_v1.png');
    } else if (16 < index && index <= 32) {
      return Image.asset('assets/images/chat/3.0x/dialog_audio_v2.png');
    } else if (32 < index && index <= 48) {
      return Image.asset('assets/images/chat/3.0x/dialog_audio_v3.png');
    } else if (48 < index && index <= 64) {
      return Image.asset('assets/images/chat/3.0x/dialog_audio_v4.png');
    } else if (64 < index && index <= 80) {
      return Image.asset('assets/images/chat/3.0x/dialog_audio_v5.png');
    } else if (80 < index && index <= 99) {
      return Image.asset('assets/images/chat/3.0x/dialog_audio_v6.png');
    }
  }

  OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.black54,
            ),
            width: 150.0,
            height: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                type == 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 80.0,
                            width: 60.0,
                            child: Image.asset(
                                'assets/images/chat/3.0x/diglog_audio_icon.png'),
                          ),
                          Container(height: 80.0, width: 60.0, child: img()),
                        ],
                      )
                    : Container(
                        child: Image.asset(
                          'assets/images/chat/3.0x/dialog_audio_cancel.webp',
                          height: 80.0,
                        ),
                      ),
                type == 1
                    ? Container(
                        child: Text(
                          '手指上滑，取消发送',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.redAccent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 2.0),
                        child: Text(
                          '松开手指，取消发送',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
              ],
            )),
      ),
    );
  });
  Overlay.of(context).insert(overlayEntry);

  return overlayEntry;
}
