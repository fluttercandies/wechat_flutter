[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/network)
[![GitHub issues](https://img.shields.io/github/issues/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/issues)
![star](https://gitcode.com/fluttercandies/wechat_flutter/star/badge.svg)
[![star](https://atomgit.com/fluttercandies/wechat_flutter/star/2025top.svg)](https://atomgit.com/fluttercandies/wechat_flutter)


> If there is a problem that other dependencies cannot be compiled, you can try to remove the "^" of all dependencies in `dependencies` in `pubspec.yaml` or change the plug-in version number to any, and try to compile again.
6
> If there is still an error, execute `flutter clean` in the main directory of the project and run again.
7
> If the plug-in version does not match, remember to check whether the plug-in flutter version introduced in the `pubspec.yaml` file is compatible with your local Flutter.

# Related documents
[List of problems and solutions](issues_list.md)

[中文文档 README_ZH.md](README_ZH.md)

# 课程说明
本项目出配套课程啦，耗时6个月打造，flutter3最新版本，从0到1实现微信，包含im聊天单聊群聊功能：https://edu.csdn.net/course/detail/39189

课程demo下载地址 https://wwpj.lanzouu.com/s/wechat-new-demo

商务合作联系微信【q1666655】，帮面试、出技术方案、解决Apple Store上架4.3等问题.

# log

* 2024.12.16 Compatible with flutter 3.24.3 [All plugin versions up-to-date]

* 2023.12.28 merge 3.0.5 of flutter version and Android sdk 33【android 13】.

* 2022.06.28 Replace the pure ui branch simulation picture address [12:00]
  
* 2022.06.28 create pure ui branch [10:00]
  
* 2022.05.28 Update environment information and post `problem list and solution` index
  
* 2022.05.26 Began to be compatible with flutter2.10.4

* 2022.05.26 List the errors and how to fix them

* 2022.05.15 Repair and supplement Android installation package link and QR code

* 2021.11.08 Adapt to flutter 2.5

* 2021.05.12 Adapt to iOS, solve running problems

* 2021.05.10 Adapt to Flutter2 stable branch [11:45]

* 2021.05.10 Fix im plugin example can not get dependencies, fix `lib/ui/flutter/my_cupertino_dialog.dart`

* 2021.01.16 Added a new payment page, waiting for the icon to be completed [14:49]

* 2021.01.16 Adapt to Flutter (Channel stable, 1.22.5)

* 2020.08.25 Adapt to Flutter (Channel stable, 1.20.2)

* 2020.07.29 Upload avatar capture error [15:45]

* 2020.07.29 Repair login, logout, and modify information reporting status management monitoring errors;

* 2020.06.30 Only when the group members are more than 20 will it display all group members, and the group owner will display the group management item [afternoon]

* 2020.06.30 Session list no session message judgment display, fix session error reporting, group announcement complete display [AM

* 2020.06.26 Quit group chat and disband group chat functions, chat member page, select member page [PM].

* 2020.06.26 Modify group chat name page, change chat background page, fix webView [AM].

* 2020.06.24 Group announcement, change group announcement message body content display, add group notes, add group QR code page;

* 2020.06.23 Group chat detail page creation;

* 2020.06.21 Session list chat content display expressions [10 points].

* 2020.06.20 Fix an error when recording video is finished [17:48].

* 2020.06.20 Remove the initialized tap effect [17 points

* 2020.06.20 Fix the empty session list [12:00].

* 2020.06.20 Fix group chat messages not appearing in the session list [09 points].

* 2020.06.18 Added WeChat tap effect;

* 2020.06.17 Added display of initiated group chat and group chat list;

* 2020.06.16 Added the function of chatting with expressions;

* 2020.06.15 Fix the package flashback problem;

* 2020.02.14 Adaptation of Flutter v1.17.3;

* 2020.02.16 adapt flutter v1.12.13 and Androidx, fix Android running problems;

* 2019.12.30 remove extended_text_field;

# Introduction

wechat_flutter is a flutter version of WeChat, currently has implemented the basic functions of instant messaging, support for Android and IOS, specific download experience.
Download it and experience it! 
![start.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/start.gif)

# Effect

|![1.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/1.jpg)| ![2.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/2.gif) | ![3.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/3.gif)|
| --- | --- | --- |
| ![4.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/4.gif) | ![5.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/5.gif) | ![6.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/6.gif) |
| ![7.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/7.gif) | ![8.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/8.gif) | ![9.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/9.gif) |

Download Experience(Android)
[Test account 166, login directly]: [https://wwc.lanzoul.com/iQlkj04vnhsj](https://wwc.lanzoul.com/iQlkj04vnhsj)


<img src="assets/git/qr_code.png" style="zoom:50%;" />

To prevent the QR code above from not displaying:

<img src="https://oss.shenmeniuma.com/images/app/qr_code.png" style="zoom:50%;" />



For IOS, just pull down the project and run it directly.

# Features

* [x] text message
* [x] Emotion messages
* [x] Image messages
* [x] Voice messages
* [x] Delete session
* [x] Language internationalization
* [x] Account registration
* [x] Account login
* [x] Auto-login
* [x] Session list
* [x] Address Book
* [x] Change avatar
* [x] Show avatar
* [x] Show nickname
* [x] Change nickname
* [x] Search for friends
* [x] Add a friend
* [x] Delete Friends
* [x] Video shooting
* [ ] Video message
* [ ] Location messages
* [x] Create a group chat
* [x] Quit group chat
* [x] Dismiss a group chat
* [x] Group chat list
* [x] Group chat announcement
* [x] Modify group name
* [x] Group chat message (text)
* [ ] Swipe
* [ ] Set notes

# Third Party Framework

| Library | Features |
| ---- | ---- |
| dim | instant messaging |
| shared_preferences | persistent_storage |
| provider | state management |
| cached_network_image | Image caching |
| toast | message alerts |
| webview_flutter | web page display |
| image_picker | image and video selection |
| extended_text | extended_text |
| url_launcher |open_browser_browse |
| connectivity | check network connection |
| photo_view | zoom in on images |
| dio | network_frame |
| open_file | open_file |
| package_info | package information |
| flutter_sound | Audio recording and processing |
| permission_handler | permission management |
| audioplayers | audio playback processing |
| camera | camera
| video_player | video_players |
| extended_text_field | extended_text_input |
| flutter_image_compress | image compression |
| lpinyin | Get Chinese pinyin |
| azlistview | Special list slider |
| wechat_assets_picker | WeChat image gallery |

# Tutorials for using

* Use the command (pull the project): $ git clone https://github.com/fluttercandies/wechat_flutter.git
* Then command (get dependencies): $ flutter packages get (IOS execute the IOS part and then execute the next step)
* Final command (run): $ flutter run

IOS

* Enter the project IOS directory: $ cd ios/
* Update Pod (not required): $ pod update
* Install Pod: $ pod install

If you get `(Connection refused - connect(2) for "raw.githubusercontent.com" port 443)`, then you haven't set up the domestic source.
Or try to go over the wall.

# My Flutter environment

```
flutter doctor -v
[✓] Flutter (Channel stable, 3.24.3, on macOS 14.0 23A344 darwin-arm64, locale
    en-CN)
    • Flutter version 3.24.3 on channel stable at
      /Users/zengyang/fvm/versions/3.24.3
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 2663184aa7 (3 months ago), 2024-09-11 16:27:48 -0500
    • Engine revision 36335019a8
    • Dart version 3.5.3
    • DevTools version 2.37.3
    • Flutter download mirror https://storage.flutter-io.cn

[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
    • Android SDK at /Users/zengyang/Library/Android/sdk
    • Platform android-34, build-tools 34.0.0
    • ANDROID_HOME = /Users/zengyang/Library/Android/sdk
    • Java binary at: /Applications/Android
      Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build
      17.0.10+0-17.0.10b1087.21-11609105)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 15.3)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 15E204a
    • CocoaPods version 1.15.2

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2024.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build
      17.0.10+0-17.0.10b1087.21-11609105)

[✓] VS Code (version 1.95.3)
    • VS Code at /Volumes/Extreme SSD/Visual Studio Code.app/Contents
    • Flutter extension version 3.102.0

[✓] Connected device (5 available)
    • aasaaaa 11 aaaa (mobile)        • 00008030-0019082236E2802E • ios
      • iOS 17.6.1 21G93
    • qqqqqqq1iPhone (mobile)         • 00008030-000171CE1168802E • ios
      • iOS 17.6.1 21G93
    • macOS (desktop)                 • macos                     • darwin-arm64
      • macOS 14.0 23A344 darwin-arm64
    • Mac Designed for iPad (desktop) • mac-designed-for-ipad     • darwin
      • macOS 14.0 23A344 darwin-arm64
    • Chrome (web)                    • chrome                    •
      web-javascript • Google Chrome 131.0.6778.140
    ! Error: Browsing on the local area network for iPhone 11 Pro Max. Ensure
      the device is unlocked and attached with a cable or associated with the
      same local area network as this Mac.
      The device must be opted into Developer Mode to connect wirelessly. (code
      -27)

[✓] Network resources
    • All expected network resources are available.

• No issues found!
```

# Problems running androidx.core:core

##### Error message:

```
Android dependency 'androidx.core:core' has different version for 
the compile (1.0.0) and runtime (1.0.2) classpath. 
manually set the same version via DependencyResolution
You should set the same version via DependencyResolution.
```

##### Solution

`External Libraries` => `Flutter Plugins` => `image_picker-0.6.1+2` at the bottom of the project
=> `android` => `build.gradle` then at the bottom there is `androidx.core:core:version`.

Change it directly to `androidx.core:core:1.0.0`.
![](assets/git/core.png)

```
android {
    compileSdkVersion 28

    defaultConfig {
        minSdkVersion 16
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
    lintOptions {
        disable 'InvalidPackage'
    }
    dependencies {
        implementation 'androidx.core:core:1.0.0'
        implementation 'androidx.annotation:annotation:1.0.0'
    }
}
```

And then change the permission_handler as well.

# About the project has not been updated for too long

I'm sorry guys, but from now on I'm in maintenance mode.
Sorry guys, from now on into maintenance. [](assets/git/cui.png)

# Future

* Later the problems encountered in the project and the solution to the idea of writing a blog for everyone to learn.
* Imitation WeChat recording audio open source library : https://github.com/yxwandroid/flutter_plugin_record
* WeChat image library : https://github.com/fluttercandies/flutter_wechat_assets_picker

# Flutter WeChat group

<img src="assets/git/left_group.png" height="200" width="210" style="zoom:30%;" />

[The above image cannot be displayed click me](http://www.shenmeniuma.com/mockImg/git/left_group.png)

Flutter tutorial website: www.flutterj.com

Flutter exchange QQ group: [874592746](https://jq.qq.com/?_wv=1027&k=5coTYqE)


### LICENSE

```
fluttercandies/wechat_flutter is licensed under the
Apache License 2.0

A permissive license whose main conditions require preservation of copyright and license notices. 
Contributors provide an express grant of patent rights. 
Licensed works, modifications, and larger works may be distributed under different terms and without source code.
```
