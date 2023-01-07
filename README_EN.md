[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/network)
[![GitHub issues](https://img.shields.io/github/issues/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/issues)

> If there is a problem that other dependencies cannot be compiled, you can try to remove the "^" of all dependencies in `dependencies` in `pubspec.yaml` or change the plug-in version number to any, and try to compile again.
> If there is still an error, execute `flutter clean` in the main directory of the project and run again.
> If the plug-in version does not match, remember to check whether the plug-in flutter version introduced in the `pubspec.yaml` file is compatible with your local Flutter.

# Related documents

[List of problems and solutions](issues_list.md)

# Notice

Currently being refactored with flutter2.10.4, check the `refactor` branch for specific progress.
The `dim` plugin will be abandoned and the `tencent_im_sdk_plugin` will be connected to solve all
plug-in compatibility issues. After merging the master, it may also be compatible with empty
security and overall code specifications.

# log

* 2022.06.28 Replace the pure ui branch simulation picture address 【12:00】

* 2022.06.28 Create a pure ui branch【10:00】

* 2022.05.28 Update environmental information and post `problem list and solution` index

* Compatible with flutter2.10.4 from 2022.05.26

* 2022.05.26 list of errors and fixes

* 2022.05.15 Repair and supplement Android installation package link and QR code

* 2021.11.08 Adapt to flutter 2.5

* 2021.05.12 Adapt to iOS and solve running problems

* 2021.05.10 Adapt to Flutter2 stable branch 【11:45】

* 2021.05.10 Fix im plugin example cannot get dependencies,
  fix `lib/ui/flutter/my_cupertino_dialog.dart`【】

* 2021.01.16 Added a new payment page, waiting for the icon to be completed 【14:49】

* 2021.01.16 Adapt to Flutter (Channel stable, 1.22.5)

* 2020.08.25 Adapt to Flutter (Channel stable, 1.20.2)

* 2020.07.29 Capture error when uploading avatar【15:45】

* 2020.07.29 Repair login, logout, and modify information report status management monitoring
  errors;

* 2020.06.30 Only when the number of group members is more than 20 can all group members be
  displayed, and the group owner will display the group management item [afternoon]

* 2020.06.30 The conversation list has no conversation message judgment display, repairs the
  conversation error report, and the group announcement is fully displayed [morning]

* 2020.06.26 Exit group chat and disband group chat functions, chat member page, select member
  page [afternoon]

* 2020.06.26 Modify the group chat name page, change the chat background page, and repair the
  webView [morning]

* 2020.06.24 Group announcement, change the content display of the group announcement message body,
  add a group note, add a group QR code page;

* 2020.06.23 Creation of group chat details page;

* 2020.06.21 Emoticons will be displayed in the chat content of the conversation list [10 points]

* 2020.06.20 Fix the error when the recording video is finished and stop recording [17:48]

* 2020.06.20 Remove the initialization take a shot effect [17 points]

* 2020.06.20 Fix session list is sometimes empty [12:00]

* 2020.06.20 Fix group chat messages not appearing in the conversation list [09:00]

* 2020.06.18 Added the effect of taking pictures on WeChat;

* 2020.06.17 Added group chat initiation and group chat list display;

* 2020.06.16 Added emoticon chat function;

* 2020.06.15 Fix the packaging flashback problem;

* 2020.02.14 Adapted to Flutter v1.17.3;

* 2020.02.16 Adapt to flutter v1.12.13 and Androidx, fix Android running problems;

* 2019.12.30 cancel extended_text_field;

# introduce

wechat_flutter is the flutter version of WeChat. Currently, it has realized the basic functions of
instant messaging, supports Android and IOS, and has a specific download experience.
![start.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/start.gif)

# rendering

|![1.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/1.jpg)| ![2.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/2.gif) | ![3.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/3.gif)|
| --- | --- | --- |
| ![4.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/4.gif) | ![5.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/5.gif) | ![6.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/6.gif) |
| ![7.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/7.gif) | ![8.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/8.gif) | ![9.gif](https://github.com/fluttercandies/wechat_flutter/blob/master/assets/git/9.gif) |

Download experience (Android)
[Test account 166, log in directly]: [https://wwc.lanzoul.com/iQlkj04vnhsj](https://wwc.lanzoul.com/iQlkj04vnhsj)


<img src="assets/git/qr_code.png" style="zoom:50%;" />

Prevent the above QR code from being displayed:

<img src="https://oss.shenmeniuma.com/images/app/qr_code.png" style="zoom:50%;" />



IOS can directly pull down the project and run it directly,

# Features

* [x] text message
* [x] emoticon message
* [x] Picture message
* [x] Voice message
* [x] delete session
* [x] language internationalization
* [x] account registration
* [x] account login
* [x] autologin
* [x] session list
* [x] Contacts
* [x] Change avatar
* [x] Show avatar
* [x] Show nickname
* [x] Change nickname
* [x] search for friends
* [x] add friend
* [x] delete friend
* [x] video capture
* [ ] Video message
* [ ] Location message
* [x] Create a group chat
* [x] Exit group chat
* [x] Dismiss group chat
* [x] Group chat list
* [x] Group chat announcement
* [x] Modify group name
* [x] Group chat message (text)
* [ ] scan it
* [ ] set remarks

# Third-party framework

| Libraries | Features |
| ---- | ---- |
| dim | instant messaging |
| shared_preferences | persistent storage |
| provider | state management |
| cached_network_image | image caching |
| toast | message prompt |
| webview_flutter | web page display |
| image_picker | Image and Video Picker |
| extended_text | extended text |
| url_launcher | Open browser to browse |
| connectivity | Check network connection |
| photo_view | Enlarged image display |
| dio | web framework |
| open_file | open file |
| package_info | package info |
| flutter_sound | Audio recording processing |
| permission_handler | permission management |
| audioplayers | audio player processing |
| camera | camera |
| video_player | video player |
| extended_text_field | extended text input |
| flutter_image_compress | image compression |
| lpinyin | Get Chinese pinyin |
| azlistview | special list swipe |
| wechat_assets_picker | WeChat Gallery |

# Use tutorial

* Use command (pull project): $ git clone https://github.com/fluttercandies/wechat_flutter.git
* Then command (get dependencies): $ flutter packages get (IOS executes the IOS part and then
  executes the next step)
* Final command (run): $ flutter run

IOS

* Enter the project IOS directory: $ cd ios/
* Update Pod (not required): $ pod update
* Install Pods: $ pod install

If `(Connection refused - connect(2) for "raw.githubusercontent.com" port 443)` appears, it means
that the domestic source has not been set. Or try to climb over the wall.

# My Flutter environment

```q1@q1deMacBook-Pro  ~/Documents/git/wechat_flutter   master  flutter doctor -v
[✓] Flutter (Channel unknown, 2.10.4, on macOS 12.2.1 21D62 darwin-x64, locale en-CN)
    • Flutter version 2.10.4 at /opt/fvm/versions/2.10.4
    • Upstream repository unknown
    • Framework revision c860cba910 (9 weeks ago), 2022-03-25 00:23:12 -0500
    • Engine revision 57d3bac3dd
    • Dart version 2.16.2
    • DevTools version 2.9.2
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn

[✓] Android toolchain - develop for Android devices (Android SDK version 31.0.0-rc1)
    • Android SDK at /Users/q1/android-sdk-macosx
    • Platform android-31, build-tools 31.0.0-rc1
    • Java binary at: /Applications/Android Studio.app/Contents/jre/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.11+0-b60-7590822)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 13.3.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • CocoaPods version 1.11.3

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2021.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 11.0.11+0-b60-7590822)

[✓] VS Code (version 1.66.2)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.38.1

[✓] Connected device (3 available)
    • SEA AL10 (mobile) • 6HJ4C20219007098 • android-arm64  • Android 10 (API 29)
    • macOS (desktop)   • macos            • darwin-x64     • macOS 12.2.1 21D62 darwin-x64
    • Chrome (web)      • chrome           • web-javascript • Google Chrome 102.0.5005.61

[!] HTTP Host Availability
    ✗ HTTP host https://maven.google.com/ is not reachable. Reason: An error occurred while checking the HTTP host: Operation timed out

! Doctor found issues in 1 category.
```

# Run Android androidx.core:core problem

##### Error message:

```
Android dependency 'androidx.core:core' has different version for
the compile (1.0.0) and runtime (1.0.2) classpath. You should
manually set the same version via DependencyResolution
```

##### solution

`External Libraries` at the bottom of the project => `Flutter Plugins` => `image_picker-0.6.1+2`
=> `android` => `build.gradle` and there is `androidx.core:core:version` at the bottom.

Directly change to `androidx.core:core:1.0.0`,
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

Then change the permission_handler as well.

# About the project has not been updated for too long

Recently, I have been too busy with work, and basically have no time to update. Then, I was working
on other open source projects before, which caused this project to have no substantial progress for
a long time. Sorry everyone, it will enter the maintenance state from now on.
![](assets/git/cui.png)

# Future

* In the later stage, the problems encountered in the project and the ideas for solving them will be
  written into a blog for everyone to learn.
* Imitation of WeChat recording audio open source
  library: https://github.com/yxwandroid/flutter_plugin_record
* WeChat Gallery: https://github.com/fluttercandies/flutter_wechat_assets_picker

# Flutter WeChat group

<img src="assets/git/left_group.png" height="200" width="210" style="zoom:30%;" />

[The above picture cannot display click me](http://www.shenmeniuma.com/mockImg/git/left_group.png)

Flutter Tutorial Network: www.flutterj.com

Flutter exchange QQ group: [874592746](https://jq.qq.com/?_wv=1027&k=5coTYqE)

# No public

<img src="http://www.flutterj.com/public.jpg" height="200" width="200" style="zoom:30%;" />

Pay attention to the official account "`Flutter Frontline`", various Flutter project practical
experience skills, working knowledge, answers to Flutter interview questions, waiting for you to
collect.

### LICENSE

```
fluttercandies/wechat_flutter is licensed under the
Apache License 2.0

A permissive license whose main conditions require preservation of copyright and license notices. 
Contributors provide an express grant of patent rights. 
Licensed works, modifications, and larger works may be distributed under different terms and without source code.
```
