[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/network)
[![GitHub issues](https://img.shields.io/github/issues/fluttercandies/wechat_flutter)](https://github.com/fluttercandies/wechat_flutter/issues) 

> 如果产生其他依赖无法编译的问题，可以尝试将`pubspec.yaml`中的`dependencies`中的所有依赖的"^"去掉或者插件版本号改为any，重新编译尝试。
> 还是出错的话在项目主目录执行`flutter clean`再重新运行。
> 如果出现插件版本不适配记得看`pubspec.yaml`文件介绍的插件flutter版本是否与自己本地Flutter适配。

# log

* 2021.01.16 新增支付页面，等待图标补全 【14:49】

* 2021.01.16 适配Flutter (Channel stable, 1.22.5)

* 2020.08.25 适配Flutter (Channel stable, 1.20.2)

* 2020.07.29 上传头像捕获错误【15:45】

* 2020.07.29 修复登录、退出登录、修改信息报状态管理监听错误；

* 2020.06.30 群成员大于20才显示查看全部群成员、群主则显示群管理item【下午】

* 2020.06.30 会话列表无会话消息判断显示、修复会话报错、群公告完整显示【上午】

* 2020.06.26 退出群聊和解散群聊功能、聊天成员页面、选择成员页面【下午】

* 2020.06.26 修改群聊名称页面、更换聊天背景页面、修复webView【上午】

* 2020.06.24 群公告、更改群公告消息体内容显示、新增群备注、新增群二维码页；

* 2020.06.23 群聊详情页面制作；

* 2020.06.21 会话列表聊天内容显示表情【10点】

* 2020.06.20 修复录制视频完成停止录制的时候报错【17点48分】

* 2020.06.20 去掉初始化拍一拍效果【17点】

* 2020.06.20 修复会话列表时而为空【12点】

* 2020.06.20 修复群聊消息不出现在会话列表【09点】

* 2020.06.18 新增微信拍一拍效果；

* 2020.06.17 新增发起群聊和群聊列表展示；

* 2020.06.16 新增表情聊天功能；

* 2020.06.15 修复打包闪退问题；

* 2020.02.14 适配 Flutter v1.17.3；

* 2020.02.16 适配flutter v1.12.13和Androidx，修复Android运行问题；

* 2019.12.30 取消extended_text_field；

# 介绍

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
* [x] 表情消息
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
* [x] 创建群聊
* [x] 退出群聊
* [x] 解散群聊
* [x] 群聊列表
* [x] 群聊公告
* [x] 修改群名
* [x] 群聊消息（文字）
* [ ] 扫一扫
* [ ] 设置备注

# 第三方框架
|  库   | 功能  |
|  ----  | ----  |
| dim  | 即时通讯 |
| shared_preferences  | 持久化存储 |
| provider  | 状态管理 |
| cached_network_image  | 图片缓存 |
| toast  | 消息提示 |
| webview_flutter  | web页面显示 |
| image_picker  | 图片和视频选择 |
| extended_text  | 扩展文本 |
| url_launcher  | 打开浏览器浏览 |
| connectivity  | 检查网络连接 |
| photo_view  | 图片放大显示 |
| dio  | 网络框架 |
| open_file  | 打开文件 |
| package_info  | 包信息 |
| flutter_sound  | 音频录制处理 |
| permission_handler  | 权限管理 |
| audioplayers  | 音频播放处理 |
| camera  | 相机 |
| video_player  | 视频播放 |
| extended_text_field  | 扩展文本输入 |
| flutter_image_compress  | 图片压缩 |
| lpinyin  | 获取中文的拼音 |
| azlistview  | 特殊列表滑动 |
| wechat_assets_picker  | 微信图库 |

# 使用教程

*  使用命令（拉取项目）：$ git clone https://github.com/fluttercandies/wechat_flutter.git
*  然后命令（获取依赖）：$ flutter packages get  (IOS执行IOS部分再执行下一步)
*  最后命令（运行）：$ flutter run

IOS
*  进入项目IOS目录：$ cd ios/
*  更新Pod（非必须）：$ pod update
*  安装Pod：$ pod install

如果出现`(Connection refused - connect(2) for "raw.githubusercontent.com" port 443)`，则表示还没设置国内源，
或者尝试下翻墙。

# 我的Flutter环境
```
q1deMacBook-Pro:~ q1$ flutter doctor -v
[✓] Flutter (Channel stable, 1.22.5, on macOS 11.0.1 20B50 darwin-x64, locale
    zh-Hans-CN)
    • Flutter version 1.22.5 at /Users/q1/flutter
    • Framework revision 7891006299 (5 weeks ago), 2020-12-10 11:54:40 -0800
    • Engine revision ae90085a84
    • Dart version 2.10.4
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn


[✓] Android toolchain - develop for Android devices (Android SDK version 30.0.1)
    • Android SDK at /Users/q1/Library/Android/sdk
    • Platform android-30, build-tools 30.0.1
    • ANDROID_HOME = /Users/q1/Library/Android/sdk
    • Java binary at: /Applications/Android
      Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build
      1.8.0_242-release-1644-b3-6915495)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 12.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 12.2, Build version 12B45b
    • CocoaPods version 1.10.0

[!] Android Studio (version 4.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
    • Java version OpenJDK Runtime Environment (build
      1.8.0_242-release-1644-b3-6915495)

[!] IntelliJ IDEA Community Edition (version 2020.2.3)
    • IntelliJ at /Applications/Applications/IntelliJ IDEA CE.app
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
    • For information about installing plugins, see
      https://flutter.dev/intellij-setup/#installing-the-plugins

[!] IntelliJ IDEA Community Edition (version 2020.2.3)
    • IntelliJ at /Applications/IntelliJ IDEA CE.app
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
    • For information about installing plugins, see
      https://flutter.dev/intellij-setup/#installing-the-plugins

[✓] VS Code (version 1.52.0)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.17.0

[✓] Connected device (1 available)
    • sdk gphone x86 arm (mobile) • emulator-5554 • android-x86 • Android 11
      (API 30) (emulator)

! Doctor found issues in 3 categories.
```

# 运行安卓androidx.core:core问题
##### 错误信息：
```
Android dependency 'androidx.core:core' has different version for 
the compile (1.0.0) and runtime (1.0.2) classpath. You should 
manually set the same version via DependencyResolution
```
##### 解决方案
项目最下方的`External Libraries` => `Flutter Plugins` => `image_picker-0.6.1+2`
=> `android` => `build.gradle` 然后最下方有`androidx.core:core:版本`。

直接改为`androidx.core:core:1.0.0`，
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
然后permission_handler也一样改下。

# 关于项目太久没更
最近工作太繁忙，基本没啥时间更新，然后之前是做其他开源项目，导致这个项目太久没实质性进展，
不好意思哈各位，从现在开始进入维护状态。
![](assets/git/cui.png)

# Future

*  后期会把项目里所遇到的问题及解决的思路写成博客给大家学习。
*  仿微信录制音频开源库：https://github.com/yxwandroid/flutter_plugin_record
*  微信图库：https://github.com/fluttercandies/flutter_wechat_assets_picker

# Flutter微信群

<img src="assets/git/left_group.png" height="200" width="210" style="zoom:30%;" />

[上图无法显示点我](http://www.flutterj.com/left_group.png)

Flutter教程网：www.flutterj.com

Flutter交流QQ群：[874592746](https://jq.qq.com/?_wv=1027&k=5coTYqE)

# 公众号
<img src="http://www.flutterj.com/public.jpg" height="200" width="200" style="zoom:30%;" />

关注公众号“`Flutter前线`”，各种Flutter项目实战经验技巧，干活知识，Flutter面试题答案，等你来领取。

### LICENSE
```
fluttercandies/wechat_flutter is licensed under the
Apache License 2.0

A permissive license whose main conditions require preservation of copyright and license notices. 
Contributors provide an express grant of patent rights. 
Licensed works, modifications, and larger works may be distributed under different terms and without source code.
```
