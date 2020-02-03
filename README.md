# log
2019.12.30 取消extended_text_field，兼容所有版本Flutter

# wechat_flutter

wechat_flutter是flutter版微信，目前已实现即时通讯基本功能，支持安卓和IOS，具体下载体验。
![start.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/start.gif)

# 效果图
|![1.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/1.jpg)| ![2.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/2.gif) | ![3.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/3.gif)|
| --- | --- | --- |
| ![4.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/4.gif) | ![5.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/5.gif) | ![6.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/6.gif) |
| ![7.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/7.gif) | ![8.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/8.gif) | ![9.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/9.gif) |
下载体验(Android)：[点击下载](http://www.flutterj.com/app-release.apk)

<img src="http://www.flutterj.com/download.png" style="zoom:50%;" />

IOS的直接拉下项目直接跑即可,

# 特性

* [x] 文字消息
* [x] 图片消息
* [x] 语音消息
* [x] 删除会话
* [x] 语言国际化
* [x] 账号注册
* [x] 账号登陆
* [x] 自动登陆
* [x] 会话列表
* [x] 通讯录
* [x] 更改头像
* [x] 显示头像
* [x] 显示昵称
* [x] 更改昵称
* [x] 搜索好友
* [x] 添加好友
* [x] 删除好友
* [x] 视频拍摄
* [ ] 视频消息
* [ ] 位置消息
* [ ] 创建群聊
* [ ] 扫一扫
* [ ] 设置备注
* [ ] 发送表情


# 使用教程

*  使用命令（拉取项目）：$ git clone https://github.com/fluttercandies/wechat_flutter.git
*  然后命令（获取依赖）：$ flutter packages get  (IOS执行IOS部分再执行下一步)
*  最后命令（运行）：$ flutter run

IOS
*  进入项目IOS目录：$ cd ios/
*  更新Pod（非必须）：$ pod update
*  安装Pod：$ pod install

# 我的Flutter环境
```
q1deMacBook-Pro:~ q1$ flutter doctor -v
[✓] Flutter (Channel stable, v1.9.1+hotfix.6, on Mac OS X 10.14.5 18F2059,
    locale zh-Hans-CN)
    • Flutter version 1.9.1+hotfix.6 at /Users/q1/flutter
    • Framework revision 68587a0916 (10 weeks ago), 2019-09-13 19:46:58 -0700
    • Engine revision b863200c37
    • Dart version 2.5.0

 
[!] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
    • Android SDK at /Users/q1/Library/Android/sdk
    • Android NDK location not configured (optional; useful for native profiling
      support)
    • Platform android-29, build-tools 29.0.2
    • ANDROID_HOME = /Users/q1/Library/Android/sdk
    • Java binary at: /Applications/Android
      Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build
      1.8.0_152-release-1024-b01)
    ! Some Android licenses not accepted.  To resolve this, run: flutter doctor
      --android-licenses

[✓] Xcode - develop for iOS and macOS (Xcode 11.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 11.2, Build version 11B52
    • CocoaPods version 1.8.4

[✓] Android Studio (version 3.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin version 29.0.1
    • Dart plugin version 173.4700
    • Java version OpenJDK Runtime Environment (build
      1.8.0_152-release-1024-b01)

[✓] Connected device (2 available)
    • Android SDK built for x86 • emulator-5554                        •
      android-x86 • Android 10 (API 29) (emulator)
    • iPhone 11 Pro Max         • 1873AA1D-FC80-4074-9A7B-3C78C4D332F1 • ios
      • com.apple.CoreSimulator.SimRuntime.iOS-13-2 (simulator)

! Doctor found issues in 1 category.
```

# Future

*  后期会把项目里所遇到的问题及解决的思路写成博客给大家学习。
*  仿微信录制音频开源库：https://github.com/yxwandroid/flutter_plugin_record

# Flutter微信群

<img src="http://www.flutterj.com/content/uploadfile/201903/64821551854137.png" height="200" width="200" style="zoom:30%;" />

Flutter教程网：www.flutterj.com

Flutter交流QQ群：[874592746](https://jq.qq.com/?_wv=1027&k=5coTYqE)

# 公众号
<img src="http://www.flutterj.com/public.jpg" height="200" width="200" style="zoom:30%;" />

关注公众号“`Flutter前线`”，各种Flutter项目实战经验技巧，干活知识，Flutter面试题答案，等你来领取。

# 贡献者

<img src="http://www.flutterj.com/circle-cropped.png" height="150" width="150" style="zoom:30%;" />