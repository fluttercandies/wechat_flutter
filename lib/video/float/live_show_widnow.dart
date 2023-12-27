import 'package:flutter/material.dart';
import 'package:wechat_flutter/video/pages/audio_multiple/view.dart';
import 'package:wechat_flutter/video/pages/audio_single/view.dart';
import 'package:wechat_flutter/video/pages/video_multiple/view.dart';
import 'package:wechat_flutter/video/pages/video_sigle/view.dart';

final imLiveRouteObserver = RouteObserver<Route<dynamic>>();

abstract class LivePageHandleInterface {
  Future<bool> popHandle();

  bool get mounted;

  BuildContext get context;
}

mixin LiveShowWindow
    on RouteAware, WidgetsBindingObserver, LivePageHandleInterface {
  void initStateHandle() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didPop() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      popHandle();
    });
    super.didPop();
  }

  void didChangeDependenciesHandle() {
    imLiveRouteObserver.subscribe(
        this, ModalRoute.of(context) as Route<dynamic>);
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  void disposeHandle() {
    imLiveRouteObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
  }
}

mixin VideoSinglePageHandle on State<VideoSinglePage>, LiveShowWindow {
  @override
  void initState() {
    super.initState();
    initStateHandle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    didChangeDependenciesHandle();
  }

  @override
  void dispose() {
    super.dispose();
    disposeHandle();
  }
}

mixin VideoMultiplePageHandle on State<VideoMultiplePage>, LiveShowWindow {
  @override
  void initState() {
    super.initState();
    initStateHandle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    didChangeDependenciesHandle();
  }

  @override
  void dispose() {
    super.dispose();
    disposeHandle();
  }
}
mixin VideoAudioPageHandle on State<AudioSinglePage>, LiveShowWindow {
  @override
  void initState() {
    super.initState();
    initStateHandle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    didChangeDependenciesHandle();
  }

  @override
  void dispose() {
    super.dispose();
    disposeHandle();
  }
}

mixin AudioSinglePageHandle on State<AudioSinglePage>, LiveShowWindow {
  @override
  void initState() {
    super.initState();
    initStateHandle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    didChangeDependenciesHandle();
  }

  @override
  void dispose() {
    super.dispose();
    disposeHandle();
  }
}


mixin AudioMultiplePageHandle on State<AudioMultiplePage>, LiveShowWindow {
  @override
  void initState() {
    super.initState();
    initStateHandle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    didChangeDependenciesHandle();
  }

  @override
  void dispose() {
    super.dispose();
    disposeHandle();
  }
}
