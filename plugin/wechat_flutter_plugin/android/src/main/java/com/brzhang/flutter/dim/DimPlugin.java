package com.brzhang.flutter.dim;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tencent.imsdk.TIMCallBack;
import com.tencent.imsdk.TIMConnListener;
import com.tencent.imsdk.TIMConversation;
import com.tencent.imsdk.TIMConversationType;
import com.tencent.imsdk.TIMElem;
import com.tencent.imsdk.TIMFriendAllowType;
import com.tencent.imsdk.TIMFriendGenderType;
import com.tencent.imsdk.TIMFriendshipManager;
import com.tencent.imsdk.TIMGroupEventListener;
import com.tencent.imsdk.TIMGroupManager;
import com.tencent.imsdk.TIMGroupMemberInfo;
import com.tencent.imsdk.TIMGroupReceiveMessageOpt;
import com.tencent.imsdk.TIMGroupTipsElem;
import com.tencent.imsdk.TIMImageElem;
import com.tencent.imsdk.TIMLocationElem;
import com.tencent.imsdk.TIMLogLevel;
import com.tencent.imsdk.TIMManager;
import com.tencent.imsdk.TIMMessage;
import com.tencent.imsdk.TIMMessageListener;
import com.tencent.imsdk.TIMRefreshListener;
import com.tencent.imsdk.TIMSdkConfig;
import com.tencent.imsdk.TIMSnapshot;
import com.tencent.imsdk.TIMSoundElem;
import com.tencent.imsdk.TIMTextElem;
import com.tencent.imsdk.TIMUserConfig;
import com.tencent.imsdk.TIMUserProfile;
import com.tencent.imsdk.TIMUserStatusListener;
import com.tencent.imsdk.TIMValueCallBack;
import com.tencent.imsdk.TIMVideo;
import com.tencent.imsdk.TIMVideoElem;
import com.tencent.imsdk.ext.group.TIMGroupBaseInfo;
import com.tencent.imsdk.ext.group.TIMGroupDetailInfoResult;
import com.tencent.imsdk.ext.group.TIMGroupMemberResult;
import com.tencent.imsdk.ext.group.TIMGroupSelfInfo;
import com.tencent.imsdk.ext.message.TIMConversationExt;
import com.tencent.imsdk.ext.message.TIMManagerExt;
import com.tencent.imsdk.ext.message.TIMMessageLocator;
import com.tencent.imsdk.ext.message.TIMUserConfigMsgExt;
import com.tencent.imsdk.friendship.TIMDelFriendType;
import com.tencent.imsdk.friendship.TIMFriend;
import com.tencent.imsdk.friendship.TIMFriendPendencyItem;
import com.tencent.imsdk.friendship.TIMFriendPendencyRequest;
import com.tencent.imsdk.friendship.TIMFriendPendencyResponse;
import com.tencent.imsdk.friendship.TIMFriendRequest;
import com.tencent.imsdk.friendship.TIMFriendResponse;
import com.tencent.imsdk.friendship.TIMFriendResult;
import com.tencent.imsdk.friendship.TIMPendencyType;
import com.tencent.imsdk.session.SessionWrapper;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * DimPlugin
 */
public class DimPlugin implements MethodCallHandler, EventChannel.StreamHandler {
    private static final String TAG = "DimPlugin";
    private Registrar registrar;
    private EventChannel.EventSink eventSink;
    private TIMMessageListener timMessageListener;
    private TIMRefreshListener timRefreshListener;

    public DimPlugin(Registrar registrar) {
        this.registrar = registrar;
        //消息监听器
        timMessageListener = new TIMMessageListener() {
            @Override
            public boolean onNewMessages(List<TIMMessage> list) {
                if (list != null && list.size() > 0) {
                    List<Message> messages = new ArrayList<>();
                    for (TIMMessage timMessage : list) {
                        messages.add(new Message(timMessage));
                    }
                    eventSink.success(new Gson().toJson(messages, new TypeToken<Collection<Message>>() {
                    }.getType()));
                }
                return false;
            }
        };
        //会话监听器
        timRefreshListener = new TIMRefreshListener() {
            @Override
            public void onRefresh() {
                eventSink.success("[]");
            }

            @Override
            public void onRefreshConversation(List<TIMConversation> conversations) {
//                if (conversations != null && conversations.size() > 0) {
//                    eventSink.success(new Gson().toJson(conversations, new TypeToken<Collection<TIMConversation>>() {
//                    }.getType()));
//                }
            }
        };
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel =
                new MethodChannel(registrar.messenger(), "dim_method");
        final EventChannel eventChannel =
                new EventChannel(registrar.messenger(), "dim_event");
        final DimPlugin dimPlugin = new DimPlugin(registrar);
        channel.setMethodCallHandler(dimPlugin);
        eventChannel.setStreamHandler(dimPlugin);
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("init")) {
            int appid = call.argument("appid");
            //初始化 IM SDK 基本配置
            //判断是否是在主线程
            if (SessionWrapper.isMainProcess(registrar.context())) {
                TIMSdkConfig config = new TIMSdkConfig(appid)
                        .enableLogPrint(true)
                        .setLogLevel(TIMLogLevel.DEBUG)
                        .setLogPath(Environment.getExternalStorageDirectory().getPath() + "/justfortest/");

                //初始化 SDK
                TIMManager.getInstance().init(registrar.context(), config);


                //基本用户配置,在登录前，通过通讯管理器 TIMManager 的接口 setUserConfig 将用户配置与当前通讯管理器进行绑定
                TIMUserConfig userConfig = new TIMUserConfig()
                        //设置用户状态变更事件监听器
                        .setUserStatusListener(new TIMUserStatusListener() {
                            @Override
                            public void onForceOffline() {
                                //被其他终端踢下线
                                Log.i(TAG, "onForceOffline");
                            }

                            @Override
                            public void onUserSigExpired() {
                                //用户签名过期了，需要刷新 userSig 重新登录 IM SDK
                                Log.i(TAG, "onUserSigExpired");
                            }
                        })
                        //设置连接状态事件监听器
                        .setConnectionListener(new TIMConnListener() {
                            @Override
                            public void onConnected() {
                                Log.i(TAG, "onConnected");
                            }

                            @Override
                            public void onDisconnected(int code, String desc) {
                                Log.i(TAG, "onDisconnected");
                            }

                            @Override
                            public void onWifiNeedAuth(String name) {
                                Log.i(TAG, "onWifiNeedAuth");
                            }
                        })
                        //设置群组事件监听器
                        .setGroupEventListener(new TIMGroupEventListener() {
                            @Override
                            public void onGroupTipsEvent(TIMGroupTipsElem elem) {
                                Log.i(TAG, "onGroupTipsEvent, type: " + elem.getTipsType());
                            }
                        })
                        //设置会话刷新监听器
                        .setRefreshListener(timRefreshListener);

                //消息扩展用户配置
                userConfig = new TIMUserConfigMsgExt(userConfig)
                        .enableAutoReport(true)
                        //开启消息已读回执
                        .enableReadReceipt(true);
                //将用户配置与通讯管理器进行绑定
                TIMManager.getInstance().setUserConfig(userConfig);

                TIMManager.getInstance().removeMessageListener(timMessageListener);
                TIMManager.getInstance().addMessageListener(timMessageListener);

                result.success("init succ");
            } else {
                result.success("init failed ,not in main process");
            }
        } else if (call.method.equals("im_login")) {
            if (!TextUtils.isEmpty(TIMManager.getInstance().getLoginUser())) {
                result.error("login failed. ", "user is login", "user is already login ,you should login out first");
                return;
            }
            String identifier = call.argument("identifier");
            String userSig = call.argument("userSig");
            if (userSig == null) {
                userSig = GenerateTestUserSig.genTestUserSig(identifier);
            }
            // identifier为用户名，userSig 为用户登录凭证
            TIMManager.getInstance().login(identifier, userSig, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess() {
                    result.success("login succ");
                }
            });
        } else if (call.method.equals("im_logout")) {
            TIMManager.getInstance().logout(new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess() {
                    result.success("logout success");
                }
            });
        } else if (call.method.equals("sdkLogout")) {
            //登出
            TIMManager.getInstance().logout(new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.d(TAG, "logout failed. code: " + code + " errmsg: " + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess() {
                    //登出成功
                    result.success("logout success");
                }
            });
        } else if (call.method.equals("getConversations")) {
            List<TIMConversation> list = TIMManagerExt.getInstance().getConversationList();
            if (list != null && list.size() > 0) {
                result.success(new Gson().toJson(list, new TypeToken<Collection<TIMConversation>>() {
                }.getType()));
            } else {
                result.success("[]");
            }
        } else if (call.method.equals("delConversation")) {
            String identifier = call.argument("identifier");
            int type = call.argument("type");
            TIMManagerExt.getInstance().deleteConversation(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group, identifier);
            result.success("delConversation success");
        } else if (call.method.equals("getMessages")) {
            String identifier = call.argument("identifier");
            int count = call.argument("count");
            Log.e(TAG, "获取" + count + "条数据");
            int type = call.argument("ctype");
//            TIMMessage lastMsg = call.argument("lastMsg");
            //获取会话扩展实例
            TIMConversation con = TIMManager.getInstance().getConversation(type == 2 ? TIMConversationType.Group : TIMConversationType.C2C, identifier);
            TIMConversationExt conExt = new TIMConversationExt(con);

//获取此会话的消息
            conExt.getMessage(count, //获取此会话最近的 100 条消息
                    null, //不指定从哪条消息开始获取 - 等同于从最新的消息开始往前
                    new TIMValueCallBack<List<TIMMessage>>() {//回调接口
                        @Override
                        public void onError(int code, String desc) {//获取消息失败
                            Log.d(TAG, "get message failed. code: " + code + " errmsg: " + desc);
                            result.error(desc, String.valueOf(code), null);
                        }

                        @Override
                        public void onSuccess(List<TIMMessage> msgs) {//获取消息成功
                            //遍历取得的消息
                            if (msgs != null && msgs.size() > 0) {
                                List<Message> messages = new ArrayList<>();
                                for (TIMMessage timMessage : msgs) {
                                    messages.add(new Message(timMessage));
                                }
                                result.success(new Gson().toJson(messages, new TypeToken<Collection<Message>>() {
                                }.getType()));
                            } else {
                                result.success("[]");
                            }
                        }
                    });
        } else if (call.method.equals("sendTextMessages")) {
            String identifier = call.argument("identifier");
            String content = call.argument("content");
            int type = call.argument("type");
            TIMMessage msg = new TIMMessage();
            msg.setTimestamp(System.currentTimeMillis());

            //添加文本内容
            TIMTextElem elem = new TIMTextElem();
            elem.setText(content);

            //将elem添加到消息
            if (msg.addElement(elem) != 0) {
                Log.d(TAG, "addElement failed");
                return;
            }
            TIMConversation conversation = TIMManager.getInstance().getConversation(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group, identifier);

            //发送消息
            conversation.sendMessage(msg, new TIMValueCallBack<TIMMessage>() {//发送消息回调
                @Override
                public void onError(int code, String desc) {//发送消息失败
                    Log.d(TAG, "send message failed. code: " + code + " errmsg: " + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(TIMMessage msg) {//发送消息成功
                    Log.e(TAG, "sendTextMessages ok");
                    result.success("sendTextMessages ok");
                }
            });
        } else if (call.method.equals("sendImageMessages")) {
            String identifier = call.argument("identifier");
            String iamgePath = call.argument("image_path");
            int type = call.argument("type");

            //构造一条消息
            TIMMessage msg = new TIMMessage();
            msg.setTimestamp(System.currentTimeMillis());

//添加图片
            TIMImageElem elem = new TIMImageElem();
//            elem.setPath(Environment.getExternalStorageDirectory() + "/DCIM/Camera/1.jpg");
            elem.setPath(iamgePath);
//将 elem 添加到消息
            if (msg.addElement(elem) != 0) {
                Log.d(TAG, "addElement failed");
                return;
            }
            TIMConversation conversation = TIMManager.getInstance().getConversation(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group, identifier);
//发送消息
            conversation.sendMessage(msg, new TIMValueCallBack<TIMMessage>() {//发送消息回调
                @Override
                public void onError(int code, String desc) {//发送消息失败
                    Log.d(TAG, "send message failed. code: " + code + " errmsg: " + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(TIMMessage msg) {//发送消息成功
                    Log.e(TAG, "SendMsg ok");
                    result.success("SendMsg ok");
                }
            });
        } else if (call.method.equals("sendSoundMessages")) {
            String identifier = call.argument("identifier");
            String sound_path = call.argument("sound_path");
            int duration = call.argument("duration");
            int type = call.argument("type");

            //构造一条消息
            TIMMessage msg = new TIMMessage();
            msg.setTimestamp(System.currentTimeMillis());

//添加图片
            TIMSoundElem elem = new TIMSoundElem();
            elem.setPath(sound_path);
            elem.setDuration(duration);
//将 elem 添加到消息
            if (msg.addElement(elem) != 0) {
                Log.d(TAG, "addElement failed");
                return;
            }
            TIMConversation conversation = TIMManager.getInstance().getConversation(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group, identifier);

//发送消息
            conversation.sendMessage(msg, new TIMValueCallBack<TIMMessage>() {//发送消息回调
                @Override
                public void onError(int code, String desc) {//发送消息失败
                    Log.d(TAG, "send message failed. code: " + code + " errmsg: " + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(TIMMessage msg) {//发送消息成功
                    Log.e(TAG, "sendSoundMessages ok");
                    result.success("sendSoundMessages ok");
                }
            });
        } else if (call.method.equals("buildVideoMessage")) {

            String identifier = call.argument("identifier");

            String videoPath = call.argument("videoPath");

            int width = call.argument("width");
            int height = call.argument("height");
            int duration = call.argument("duration");
            int type = call.argument("type");

            //构造一条消息
            TIMMessage msg = new TIMMessage();
            msg.setTimestamp(System.currentTimeMillis());

            TIMVideoElem ele = new TIMVideoElem();

            TIMVideo video = new TIMVideo();
            video.setDuaration(duration / 1000);
            video.setType("mp4");
            TIMSnapshot snapshot = new TIMSnapshot();

            MediaMetadataRetriever media = new MediaMetadataRetriever();
            media.setDataSource(videoPath);

            snapshot.setWidth(width);
            snapshot.setHeight(height);

            ele.setSnapshot(snapshot);
            ele.setVideo(video);
            ele.setVideoPath(videoPath);
            Bitmap bitmap = media.getFrameAtTime();
            File file = new File(Environment.getExternalStorageDirectory() + "/mfw.png");
            try {
                //文件输出流
                FileOutputStream fileOutputStream = new FileOutputStream(file);
                //压缩图片，如果要保存png，就用Bitmap.CompressFormat.PNG，要保存jpg就用Bitmap.CompressFormat.JPEG,质量是100%，表示不压缩
                bitmap.compress(Bitmap.CompressFormat.PNG, 50, fileOutputStream);
                //写入，这里会卡顿，因为图片较大
                fileOutputStream.flush();
                //记得要关闭写入流
                fileOutputStream.close();
                //成功的提示，写入成功后，请在对应目录中找保存的图片
                ele.setSnapshotPath(Environment.getExternalStorageDirectory() + "/mfw.png");
                Log.d(TAG, "视频封面地址 " + Environment.getExternalStorageDirectory() + "/mfw.png");
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                Log.d(TAG, e.getMessage());
            } catch (IOException e) {
                e.printStackTrace();
                Log.d(TAG, e.getMessage());
            }

            msg.addElement(ele);
            if (msg.addElement(ele) != 0) {
                Log.d(TAG, "addElement failed");
                return;
            }

            TIMConversation conversation = TIMManager.getInstance().getConversation(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group, identifier);

//发送消息
            conversation.sendMessage(msg, new TIMValueCallBack<TIMMessage>() {//发送视频消息回调
                @Override
                public void onError(int code, String desc) {//发送视频消息失败
                    Log.d(TAG, "send buildVideoMessage failed. code: " + code + " errmsg: " + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(TIMMessage msg) { //发送视频消息成功
                    Log.e(TAG, "buildVideoMessage ok");
                    result.success("buildVideoMessage ok");
                }
            });

        } else if (call.method.equals("sendLocation")) {

            String identifier = call.argument("identifier");
            double lat = call.argument("lat");
            double lng = call.argument("lng");
            String desc = call.argument("desc");

            TIMConversation conversation = TIMManager.getInstance().getConversation(TIMConversationType.C2C, identifier);
            //构造一条消息
            TIMMessage msg = new TIMMessage();

//添加位置信息
            TIMLocationElem elem = new TIMLocationElem();
            elem.setLatitude(lat);   //设置纬度
            elem.setLongitude(lng);   //设置经度
            elem.setDesc(desc);

//将elem添加到消息
            if (msg.addElement(elem) != 0) {
                Log.d(TAG, "addElement failed");
                return;
            }
//发送消息
            conversation.sendMessage(msg, new TIMValueCallBack<TIMMessage>() {//发送消息回调
                @Override
                public void onError(int code, String desc) {//发送消息失败
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(TIMMessage msg) {//发送消息成功
                    Log.e(TAG, "Send location ok");
                    result.success("sendLocation ok");
                }
            });

        } else if (call.method.equals("post_data_test")) {
            Log.e(TAG, "onMethodCall() called with: call = [" + call + "], result = [" + result + "]");
            eventSink.success("hahahahha  I am from listener");
        } else if (call.method.equals("addFriend")) {
            //创建请求列表
            //添加好友请求
            String identifier = call.argument("identifier");
            TIMFriendRequest timFriendRequest = new TIMFriendRequest(identifier);
            timFriendRequest.setAddWording("请添加我!");
            timFriendRequest.setAddSource("android");
            TIMFriendshipManager.getInstance().addFriend(timFriendRequest, new TIMValueCallBack<TIMFriendResult>() {
                @Override
                public void onError(int code, String desc) {
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(TIMFriendResult timFriendResult) {
                    result.success("addFriend success");
                }
            });
        } else if (call.method.equals("delFriend")) {
            //双向删除好友 test_user
            String identifier = call.argument("identifier");

            List<String> identifiers = new ArrayList<>();
            identifiers.add(identifier);
            TIMFriendshipManager.getInstance().deleteFriends(identifiers, TIMDelFriendType.TIM_FRIEND_DEL_BOTH, new TIMValueCallBack<List<TIMFriendResult>>() {
                @Override
                public void onError(int code, String desc) {
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(List<TIMFriendResult> timUserProfiles) {
                    result.success("deleteFriends success");
                }
            });
        } else if (call.method.equals("listFriends")) {
            TIMFriendshipManager.getInstance().getFriendList(new TIMValueCallBack<List<TIMFriend>>() {
                @Override
                public void onError(int code, String desc) {
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(List<TIMFriend> timFriends) {
                    List<TIMUserProfile> userList = new ArrayList<>();
                    for (TIMFriend timFriend : timFriends) {
                        userList.add(timFriend.getTimUserProfile());
                    }
                    result.success(new Gson().toJson(userList, new TypeToken<Collection<TIMUserProfile>>() {
                    }.getType()));
                }
            });
        } else if (call.method.equals("opFriend")) {//好友申请
            //获取好友列表
            String identifier = call.argument("identifier");
            String opTypeStr = call.argument("opTypeStr");
            TIMFriendResponse timFriendAddResponse = new TIMFriendResponse();
            timFriendAddResponse.setIdentifier(identifier);
            if (opTypeStr.toUpperCase().trim().equals("Y")) {
                timFriendAddResponse.setResponseType(TIMFriendResponse.TIM_FRIEND_RESPONSE_AGREE_AND_ADD);
            } else {
                timFriendAddResponse.setResponseType(TIMFriendResponse.TIM_FRIEND_RESPONSE_REJECT);
            }
            TIMFriendshipManager.getInstance().doResponse(timFriendAddResponse, new TIMValueCallBack<TIMFriendResult>() {
                @Override
                public void onError(int i, String s) {
                    result.error(s, String.valueOf(i), null);
                }

                @Override
                public void onSuccess(TIMFriendResult timFriendResult) {
                    result.success(timFriendResult.getIdentifier());
                }
            });
        } else if (call.method.equals("getUsersProfile")) {
            List<String> users = call.argument("users");
            //获取用户资料
            TIMFriendshipManager.getInstance().getUsersProfile(users, true, new TIMValueCallBack<List<TIMUserProfile>>() {
                @Override
                public void onError(int code, String desc) {
                    //错误码 code 和错误描述 desc，可用于定位请求失败原因
                    //错误码 code 列表请参见错误码表
                    Log.e(TAG, "getUsersProfile failed: " + code + " desc");
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(List<TIMUserProfile> timUserProfiles) {
                    Log.e(TAG, "getUsersProfile succ");
                    if (timUserProfiles != null && timUserProfiles.size() > 0) {
                        result.success(new Gson().toJson(timUserProfiles, new TypeToken<Collection<TIMUserProfile>>() {
                        }.getType()));
                    } else {
                        result.success("[]");
                    }

                }
            });
        } else if (call.method.equals("setUsersProfile")) {

            String nick = call.argument("nick");
            int gender = call.argument("gender");
            String faceUrl = call.argument("faceUrl");
            HashMap<String, Object> profileMap = new HashMap<>();
            profileMap.put(TIMUserProfile.TIM_PROFILE_TYPE_KEY_NICK, nick);
            profileMap.put(TIMUserProfile.TIM_PROFILE_TYPE_KEY_GENDER, gender == 1 ? TIMFriendGenderType.GENDER_MALE : TIMFriendGenderType.GENDER_FEMALE);
            profileMap.put(TIMUserProfile.TIM_PROFILE_TYPE_KEY_FACEURL, faceUrl);
            TIMFriendshipManager.getInstance().modifySelfProfile(profileMap, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "modifySelfProfile failed: " + code + " desc" + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess() {
                    Log.e(TAG, "modifySelfProfile success");
                    result.success("setUsersProfile succ");
                }
            });
        } else if (call.method.equals("getCurrentLoginUser")) {
            result.success(TIMManager.getInstance().getLoginUser());
        } else if (call.method.equals("im_autoLogin")) {
            if (!TextUtils.isEmpty(TIMManager.getInstance().getLoginUser())) {
                result.error("login failed. ", "user is login", "user is already login ,you should login out first");
                return;
            }
            String identifier = call.argument("identifier");
            // identifier为用户名，userSig 为用户登录凭证
            TIMManager.getInstance().autoLogin(identifier, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "autoLogin failed: " + code + " desc" + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess() {
                    Log.e(TAG, "autoLogin succ");
                    result.success("autoLogin succ");
                }
            });
        } else if (call.method.equals("deleteConversationAndLocalMsg")) {

            int type = call.argument("type");
            String identifier = call.argument("identifier");

            TIMManager.getInstance().deleteConversationAndLocalMsgs(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group, identifier);
            result.success("删除会话：" + identifier);
        } else if (call.method.equals("getUnreadMessageNum")) {
            int type = call.argument("type");
            String identifier = call.argument("identifier");
            //获取会话扩展实例
            TIMConversation con = TIMManager.getInstance().getConversation(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group, identifier);
//获取会话未读数
            long num = con.getUnreadMessageNum();
            Log.d(TAG, "unread msg num: " + num);
            result.success(num);

        } else if (call.method.equals("setReadMessage")) {
            int type = call.argument("type");
            String identifier = call.argument("identifier");
            TIMConversation conversation = TIMManager.getInstance().getConversation(
                    type == 1 ? TIMConversationType.C2C : TIMConversationType.Group,    //会话类型：单聊
                    identifier);                      //会话对方用户帐号
//将此会话的所有消息标记为已读
            conversation.setReadMessage(null, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "setReadMessage failed, code: " + code + "|desc: " + desc);
                    result.error(desc, "error" + code, null);
                }

                @Override
                public void onSuccess() {
                    Log.d(TAG, "setReadMessage succ");
                    result.success("setReadMessage succ");
                }
            });
        } else if (call.method.equals("deleteGroup")) {
            String groupId = call.argument("groupId");

            //解散群组
            TIMGroupManager.getInstance().deleteGroup(groupId, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    //错误码 code 和错误描述 desc，可用于定位请求失败原因
                    //错误码 code 列表请参见错误码表
                    Log.d(TAG, "login failed. code: " + code + " errmsg: " + desc);
                    result.error(desc, "login failed. code: " + code + " errmsg: ", null);
                }

                @Override
                public void onSuccess() {
                    //解散群组成功
                    result.success("解散群组成功");
                }
            });
        } else if (call.method.equals("modifyGroupName")) {
            String groupId = call.argument("groupId");
            String setGroupName = call.argument("setGroupName");

            TIMGroupManager.ModifyGroupInfoParam param = new TIMGroupManager.ModifyGroupInfoParam(groupId);
            param.setGroupName(setGroupName);
            TIMGroupManager.getInstance().modifyGroupInfo(param, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "modify group info failed, code:" + code + "|desc:" + desc);
                    result.error(desc, "modify group info failed, code:" + code, null);
                }

                @Override
                public void onSuccess() {
                    Log.e(TAG, "modify group info succ");
                    result.success("modify group info succ");
                }
            });
        } else if (call.method.equals("modifyGroupIntroduction")) {
            String groupId = call.argument("groupId");
            String setIntroduction = call.argument("setIntroduction");

            TIMGroupManager.ModifyGroupInfoParam param = new TIMGroupManager.ModifyGroupInfoParam(groupId);
            param.setIntroduction(setIntroduction);
            TIMGroupManager.getInstance().modifyGroupInfo(param, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "modify group info failed, code:" + code + "|desc:" + desc);
                    result.error(desc, "modify group info failed, code:" + code, null);
                }

                @Override
                public void onSuccess() {
                    Log.e(TAG, "modify group info succ");
                    result.success("modify group info succ");
                }
            });
        } else if (call.method.equals("modifyGroupNotification")) {
            String groupId = call.argument("groupId");
            String notification = call.argument("notification");
            String time = call.argument("time");

            TIMGroupManager.ModifyGroupInfoParam param = new TIMGroupManager.ModifyGroupInfoParam(groupId);
            param.setNotification(notification);
            param.setIntroduction(time);
            TIMGroupManager.getInstance().modifyGroupInfo(param, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "modify group info failed, code:" + code + "|desc:" + desc);
                    result.error(desc, "modify group info failed, code:" + code, null);
                }

                @Override
                public void onSuccess() {
                    Log.e(TAG, "modify group info succ");
                    result.success("modify group info succ");
                }
            });
        } else if (call.method.equals("setReceiveMessageOption")) {
            String groupId = call.argument("groupId");
            String identifier = call.argument("identifier");
            int type = call.argument("type");

            TIMGroupManager.ModifyMemberInfoParam param = new TIMGroupManager.ModifyMemberInfoParam(groupId, identifier);
            param.setReceiveMessageOpt(type == 1 ? TIMGroupReceiveMessageOpt.ReceiveAndNotify : TIMGroupReceiveMessageOpt.ReceiveNotNotify);

            TIMGroupManager.getInstance().modifyMemberInfo(param, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "modifyMemberInfo failed, code:" + code + "|msg: " + desc);
                    result.error(desc, "modifyMemberInfo failed, code:" + code, null);
                }

                @Override
                public void onSuccess() {
                    Log.d(TAG, "modifyMemberInfo succ");
                    result.success("modifyMemberInfo succ");
                }
            });
        } else if (call.method.equals("getPendencyList")) {
            final TIMFriendPendencyRequest timFriendPendencyRequest = new TIMFriendPendencyRequest();
            timFriendPendencyRequest.setTimPendencyGetType(TIMPendencyType.TIM_PENDENCY_COME_IN);
            timFriendPendencyRequest.setSeq(0);
            timFriendPendencyRequest.setTimestamp(0);
            timFriendPendencyRequest.setNumPerPage(10);
            TIMFriendshipManager.getInstance().getPendencyList(timFriendPendencyRequest, new TIMValueCallBack<TIMFriendPendencyResponse>() {
                @Override
                public void onError(int i, String s) {
                    Log.e(TAG, "getPendencyList err code = " + i + ", desc = " + s);
                }

                @Override
                public void onSuccess(TIMFriendPendencyResponse timFriendPendencyResponse) {
                    List<TIMFriendPendencyItem> items = timFriendPendencyResponse.getItems();

                    List mData = new ArrayList<>();

                    Iterator var3 = items.iterator();

                    while (var3.hasNext()) {
                        TIMFriendPendencyItem timFriendPendencyItem = (TIMFriendPendencyItem) var3.next();
                        mData.add("{'id':'" + timFriendPendencyItem.getIdentifier() + "',"
                                + "'addSource':'" + timFriendPendencyItem.getAddSource() + "',"
                                + "'wording':'" + timFriendPendencyItem.getAddWording() + "',"
                                + "'nickname':'" + timFriendPendencyItem.getNickname() + "',"
                                + "'time':'" + timFriendPendencyItem.getAddTime() + "',"
                                + "'type':'" + timFriendPendencyItem.getType() + "',"
                                + "}"
                        );
                    }
                    Log.i(TAG, "getPendencyList success result = " + timFriendPendencyResponse.toString());
                    result.success(mData.toString());
                }
            });
        } else if (call.method.equals("getSelfProfile")) {
            //获取服务器保存的自己的资料
            TIMFriendshipManager.getInstance().getSelfProfile(new TIMValueCallBack<TIMUserProfile>() {
                @Override
                public void onError(int code, String desc) {
                    //错误码 code 和错误描述 desc，可用于定位请求失败原因
                    //错误码 code 列表请参见错误码表
                    Log.e(TAG, "getSelfProfile failed: " + code + " desc");
                    result.error(desc, "getSelfProfile failed, code:" + code, null);
                }

                @Override
                public void onSuccess(TIMUserProfile resultS) {
                    Log.e(TAG, "getSelfProfile succ");
                    Log.e(TAG, "identifier: " + resultS.getIdentifier() + " nickName: " + resultS.getNickName()
                            + " allow: " + resultS.getAllowType());
                    result.success("identifier: " + resultS.getIdentifier() + " nickName: " + resultS.getNickName()
                            + " allow: " + resultS.getAllowType());
                }
            });
        } else if (call.method.equals("setAddMyWay")) {
            int type = call.argument("type");
            HashMap<String, Object> profileMap = new HashMap<>();
            profileMap.put(TIMUserProfile.TIM_PROFILE_TYPE_KEY_ALLOWTYPE, type == 1 ? TIMFriendAllowType.TIM_FRIEND_NEED_CONFIRM : TIMFriendAllowType.TIM_FRIEND_ALLOW_ANY);
            TIMFriendshipManager.getInstance().modifySelfProfile(profileMap, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "modifySelfProfile failed: " + code + " desc" + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess() {
                    Log.e(TAG, "setAddMyWay success");
                    result.success("setsetAddMyWay succ");
                }
            });
        } else if (call.method.equals("im_autoLogin")) {
            if (!TextUtils.isEmpty(TIMManager.getInstance().getLoginUser())) {
                result.error("login failed. ", "user is login", "user is already login ,you should login out first");
                return;
            }
            String identifier = call.argument("identifier");
            // identifier为用户名，userSig 为用户登录凭证
            TIMManager.getInstance().autoLogin(identifier, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "autoLogin failed: " + code + " desc" + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess() {
                    Log.e(TAG, "autoLogin succ");
                    result.success("autoLogin succ");
                }
            });
        } else if (call.method.equals("getLoginUser")) {
            if (!TextUtils.isEmpty(TIMManager.getInstance().getLoginUser())) {
                result.error("login failed. ", "user is login", "user is already login ,you should login out first");
                return;
            }
            result.success(TIMManager.getInstance().getLoginUser());
        } else if (call.method.equals("initStorage")) {
            String identifier = call.argument("identifier");

            TIMManager.getInstance().initStorage(identifier, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.d(TAG, "initStorage failed. code: " + code + " errmsg: " + desc);
                    result.error("initStorage", " failed. code: " + code, null);
                }

                @Override
                public void onSuccess() {
                    result.success("initStorage success");
                }
            });
        } else if (call.method.equals("getSelfGroupNameCard")) {
            String groupId = call.argument("groupId");

            TIMGroupManager.getInstance().getSelfInfo(
                    groupId, new TIMValueCallBack<TIMGroupSelfInfo>() {
                        @Override
                        public void onError(int i, String s) {
                            Log.d(TAG, "getSelfGroupNameCard error. code: " + i + " errmsg: " + s);
                            result.error("获取自己群名片信息失败", "代码：" + i, s);
                        }

                        @Override
                        public void onSuccess(TIMGroupSelfInfo timGroupSelfInfo) {
                            Log.d(TAG, "getSelfGroupNameCard success");
                            result.success(timGroupSelfInfo.getNameCard());
                        }
                    }
            );
        } else if (call.method.equals("setGroupNameCard")) {
            String groupId = call.argument("groupId");
            String identifier = call.argument("identifier");
            String name = call.argument("name");

            TIMGroupManager.ModifyMemberInfoParam param = new TIMGroupManager.ModifyMemberInfoParam(groupId, identifier);
            param.setNameCard(name);

            TIMGroupManager.getInstance().modifyMemberInfo(param, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "modifyMemberInfo failed, code:" + code + "|msg: " + desc);
                }

                @Override
                public void onSuccess() {
                    Log.d(TAG, "modifyMemberInfo succ");
                    result.success("modifyMemberInfo succ");
                }
            });
        } else if (call.method.equals("revokeMessage")) {
            int type = call.argument("type");
            String conversationId = call.argument("conversationId");

            TIMConversation timConversation = TIMManager.getInstance().getConversation(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group,
                    conversationId);
            TIMMessage msg = new TIMMessage();
//            msg.setCustomInt();
            timConversation.revokeMessage(msg, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.d(TAG, "revokeMessage failed. code: " + code + " errmsg: " + desc);
                    result.error("撤回失败", "代码：" + code, desc);
                }

                @Override
                public void onSuccess() {
                    Log.d(TAG, "撤回成功");
                    result.success("撤回成功");
                }
            });
        } else if (call.method.equals("findMessages")) {
            int type = call.argument("type");
            String conversationId = call.argument("conversationId");

            TIMConversation timConversation = TIMManager.getInstance().getConversation(type == 1 ? TIMConversationType.C2C : TIMConversationType.Group,
                    conversationId);
            List<TIMMessageLocator> locators = new ArrayList<>();
//            for(int i = 0;i< locators.size();i++) {
//                TIMMessageLocator timMessageLocator = locators.get(i);
//
//                timMessageLocator.toString();
//            }
            timConversation.findMessages(locators, new TIMValueCallBack<List<TIMMessage>>() {
                @Override
                public void onError(int i, String s) {

                }

                @Override
                public void onSuccess(List<TIMMessage> timMessages) {

                }
            });
        } else if (call.method.equals("getGroupMembersInfo")) {
            String groupId = call.argument("groupId");
            List<String> userIDs = call.argument("userIDs");

            TIMGroupManager.getInstance().getGroupMembersInfo(
                    groupId, userIDs, new TIMValueCallBack<List<TIMGroupMemberInfo>>() {
                        @Override
                        public void onError(int i, String s) {
                            Log.d(TAG, "failed. code: " + i + " errmsg: " + s);
                            result.error(null, "failed. code: ", i);
                        }

                        @Override
                        public void onSuccess(List<TIMGroupMemberInfo> timGroupMemberInfos) {
                            List<String> mData = new ArrayList<>();
                            for (TIMGroupMemberInfo infoIM : timGroupMemberInfos) {
                                mData.add("{'user':'" + infoIM.getUser() + "'," +
                                        "'joinTime':'" + infoIM.getJoinTime() + "'," +
                                        "'nameCard':'" + infoIM.getNameCard() + "'," +
                                        "'msgFlag':'" + infoIM.getMsgFlag() + "'," +
                                        "'msgSeq':'" + infoIM.getMsgSeq() + "'," +
                                        "'silenceSeconds':'" + infoIM.getSilenceSeconds() + "'," +
                                        "'tinyId':'" + infoIM.getTinyId() + "'," +
                                        "'role':'" + infoIM.getRole() + "'}");
                            }
                            result.success(mData.toString());
                        }
                    }
            );
        } else if (call.method.equals("getGroupInfoList")) {
            List<String> groupID = call.argument("groupID");

            TIMGroupManager.getInstance().getGroupInfo(groupID, new TIMValueCallBack<List<TIMGroupDetailInfoResult>>() {
                @Override
                public void onError(final int code, final String desc) {
                    Log.e(TAG, "loadGroupPublicInfo failed, code: " + code + "|desc: " + desc);
                    result.error(desc, "error Code" + code, null);
                }

                @Override
                public void onSuccess(final List<TIMGroupDetailInfoResult> timGroupDetailInfoResults) {
                    List<String> mData = new ArrayList<>();

                    if (timGroupDetailInfoResults.size() > 0) {
                        TIMGroupDetailInfoResult info = timGroupDetailInfoResults.get(0);
                        mData.add("{'faceUrl': " + "'" + info.getFaceUrl() + "'");
                        mData.add("'groupId': " + "'" + info.getGroupId() + "'");
                        mData.add("'groupIntroduction': " + "'" + info.getGroupIntroduction() + "'");
                        mData.add("'groupName': " + "'" + info.getGroupName() + "'");
                        mData.add("'groupNotification': " + "'" + info.getGroupNotification() + "'");
                        mData.add("'groupOwner': " + "'" + info.getGroupOwner() + "'");
                        mData.add("'groupType': " + "'" + info.getGroupType() + "'");
                        mData.add("'lastInfoTime': " + "'" + info.getLastInfoTime() + "'");
                        mData.add("'lastMsgTime': " + "'" + info.getLastMsgTime() + "'");
                        mData.add("'createTime': " + "'" + info.getCreateTime() + "'");
                        mData.add("'memberNum': " + "'" + info.getMemberNum() + "'");
                        mData.add("'maxMemberNum': " + "'" + info.getMaxMemberNum() + "'");
                        mData.add("'OnlineMemberNum': " + "'" + info.getOnlineMemberNum() + "'" + "}");
                    }
                    result.success(mData.toString());
                }
            });
        } else if (call.method.equals("getGroupList")) {
            //创建回调
            TIMValueCallBack<List<TIMGroupBaseInfo>> cb = new TIMValueCallBack<List<TIMGroupBaseInfo>>() {
                @Override
                public void onError(int code, String desc) {
                    //错误码 code 和错误描述 desc，可用于定位请求失败原因
                    //错误码 code 含义请参见错误码表·
                    Log.e(TAG, "get gruop list failed: " + code + " desc");
//                    result.error(desc, "error Code" + code, null);
                }

                @Override
                public void onSuccess(List<TIMGroupBaseInfo> timGroupInfos) {//参数返回各群组基本信息
                    Log.d(TAG, "get gruop list succ");
                    List<String> mData = new ArrayList<>();
                    for (TIMGroupBaseInfo info : timGroupInfos) {
                        mData.add("{'groupId':'" + info.getGroupId() + "',"
                                + "'groupName':'" + info.getGroupName() + "',"
                                + "'getFaceUrl':'" + info.getFaceUrl() + "'}");

                        Log.d(TAG, "group id: " + info.getGroupId() +
                                " group name: " + info.getGroupName() +
                                " getFaceUrl: " + info.getFaceUrl());

                    }
                    result.success(mData.toString());
                }
            };

//获取已加入的群组列表
            TIMGroupManager.getInstance().getGroupList(cb);
        } else if (call.method.equals("createGroupChat")) {
            String name = call.argument("name");
            List<String> personList = call.argument("personList");

            //创建公开群，且不自定义群 ID
            final TIMGroupManager.CreateGroupParam param = new TIMGroupManager.CreateGroupParam("Private", name);
            List<TIMGroupMemberInfo> infoS = new ArrayList<>();

            for (int i = 0; i < personList.size(); i++) {
                TIMGroupMemberInfo memberInfo = new TIMGroupMemberInfo(personList.get(i));
                infoS.add(memberInfo);
            }

            param.setMembers(infoS);
            param.setNotification("welcome to our group");

//            NineCellBitmapUtil nineCellBitmapUtil;
//
//            String[] urlArray = {
//                    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538451017&di=dd252d5e4594f786d34891fb6be826ff&imgtype=jpg&er=1&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201311%2F28%2F20131128101128_JZUaM.jpeg",
//                    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537856300317&di=e4aebfba49e34aa5bd8de8346b268229&imgtype=0&src=http%3A%2F%2Fs9.knowsky.com%2Fbizhi%2Fl%2F35001-45000%2F20095294542896291195.jpg",
//                    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537856300315&di=8def4a51ac362ffa7602ca768d76c982&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Ff9198618367adab44ce126ab8bd4b31c8701e420.jpg",
//                    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537345745067&di=d51264f2b354863c865a1da4b6672d90&imgtype=0&src=http%3A%2F%2Fpic40.nipic.com%2F20140426%2F6608733_175243397000_2.jpg",
//                    "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3394638573,2701566035&fm=26&gp=0.jpg",
//                    "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2758635669,3034136689&fm=26&gp=0.jpg",
//                    "http://t.cn/EvHONPF",
//                    "http://t.cn/EvHOTa9",
//                    "http://t.cn/EvHO38y",
//            };
//            List<String> imgList = new ArrayList<>();
//            // 实例化这个这个工具类，默认聚合的图片尺寸是1000像素，每张图的间距是20像素
//            nineCellBitmapUtil = NineCellBitmapUtil.with().setBitmapSize(1000)
//                    .setItemMargin(20).setPaddingSize(20).build();
//            imgList.add(urlArray[1]);
//            imgList.add(urlArray[2]);

//            nineCellBitmapUtil.collectBitmap(imgList, new NineCellBitmapUtil.BitmapCallBack() {
//                @Override
//                public void onLoadingFinish(Bitmap bitmap) {
//                }
//            });

//创建群组
            TIMGroupManager.getInstance().createGroup(param, new TIMValueCallBack<String>() {
                @Override
                public void onError(int code, String desc) {
                    Log.d(TAG, "create group failed. code: " + code + " errmsg: " + desc);
                    result.error(desc, String.valueOf(code), null);
                }

                @Override
                public void onSuccess(String s) {
                    Log.d(TAG, "create group succ, groupId:" + s);
                    result.success("create group succ, groupId:" + s);
                }
            });

        } else if (call.method.equals("editFriendNotes")) {
            String identifier = call.argument("identifier");
            String remarks = call.argument("remarks");
            HashMap<String, Object> hashMap = new HashMap<>();
// 修改好友备注
            hashMap.put(TIMFriend.TIM_FRIEND_PROFILE_TYPE_KEY_REMARK, remarks);
            TIMFriendshipManager.getInstance().modifyFriend(identifier, hashMap, new TIMCallBack() {
                @Override
                public void onError(int i, String s) {
                    Log.e(TAG, "editFriendNotes err code = " + i + ", desc = " + s);
                    result.error(s, String.valueOf(i), null);
                }

                @Override
                public void onSuccess() {
                    Log.i(TAG, "editFriendNotes success");
                    result.success("editFriendNotes success");
                }
            });
        } else if (call.method.equals("getRemark")) {
            try {
                String identifier = call.argument("identifier");
// 获取好友备注
                TIMFriend friend = TIMFriendshipManager.getInstance().queryFriend(identifier);
                if (friend != null) {
                    result.success(friend.getRemark());
                } else {
                    result.error("获取状态：", "失败", null);
                }
            } catch (NullPointerException e) {
                System.out.println("字符为空!" + e);
            }
        } else if (call.method.equals("getGroupMembersList")) {
            String groupId = call.argument("groupId");

//            final List<String> userS = new ArrayList<>();
            final List<String> mData = new ArrayList<>();

            //创建回调
            TIMValueCallBack<List<TIMGroupMemberInfo>> cb = new TIMValueCallBack<List<TIMGroupMemberInfo>>() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "getGroupMembersList onErr. code: " + code + " errmsg: " + desc);
                    result.error(desc, "getGroupMembersList on Err code: " + code, null);
                }

                @Override
                public void onSuccess(List<TIMGroupMemberInfo> infoList) {//参数返回群组成员信息

                    for (TIMGroupMemberInfo infoIM : infoList) {
//                        userS.add(infoIM.getUser());
                        mData.add("{'user':'" + infoIM.getUser() + "'");
                        mData.add("'joinTime':'" + infoIM.getJoinTime() + "'," +
                                "'nameCard':'" + infoIM.getNameCard() + "'," +
                                "'msgFlag':'" + infoIM.getMsgFlag() + "'," +
                                "'msgSeq':'" + infoIM.getMsgSeq() + "'," +
                                "'silenceSeconds':'" + infoIM.getSilenceSeconds() + "'," +
                                "'tinyId':'" + infoIM.getTinyId() + "'," +
                                "'role':'" + infoIM.getRole() + "'}");
                    }
                    result.success(mData.toString());
                }
            };

//            TIMFriendshipManager.getInstance().getUsersProfile(userS, true, new TIMValueCallBack<List<TIMUserProfile>>() {
//                @Override
//                public void onError(int code, String desc) {
//                    //错误码 code 和错误描述 desc，可用于定位请求失败原因
//                    //错误码 code 列表请参见错误码表
//                    Log.e(TAG, "getUsersProfile failed: " + code + " desc");
//                }
//
//                @Override
//                public void onSuccess(List<TIMUserProfile> timUserProfiles) {
//                    if (timUserProfiles != null && timUserProfiles.size() > 0) {
//                        TIMUserProfile info = timUserProfiles.get(0);
//                        mData.add("'nickName':'" + info.getNickName() + "'");
//                        mData.add("'allowType':'" + info.getAllowType() + "'");
//                        mData.add("'faceUrl':'" + info.getFaceUrl() + "'");
//                        mData.add("'identifier':'" + info.getIdentifier() + "'");
//                    } else {
//                        mData.add("'info':" + "[]");
//                    }
//
//                }
//            });

//获取群组成员信息
            TIMGroupManager.getInstance().getGroupMembers(
                    groupId, cb);     //回调

        } else if (call.method.equals("inviteGroupMember")) {
            //创建待加入群组的用户列表
            ArrayList list = call.argument("list");
            String groupId = call.argument("groupId");

            TIMGroupManager.getInstance().inviteGroupMember(groupId, list, new TIMValueCallBack<List<TIMGroupMemberResult>>() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "addGroupMembers failed, code: " + code + "|desc: " + desc);
                    result.error(desc, "code:" + code, null);
                }

                @Override
                public void onSuccess(List<TIMGroupMemberResult> timGroupMemberResults) {
                    Log.e(TAG, "邀请执行完毕");
                    final List<String> adds = new ArrayList<>();

                    if (timGroupMemberResults.size() > 0) {
                        for (int i = 0; i < timGroupMemberResults.size(); i++) {
                            TIMGroupMemberResult res = timGroupMemberResults.get(i);
                            if (res.getResult() == 3) {
//                                result.success("邀请成功，等待对方接受");
                                return;
                            }
                            if (res.getResult() > 0) {
                                adds.add(res.getUser());
                            }
                        }
                        Log.e(TAG, "邀请成功，等待对方接受");
                        result.success("邀请成功");
                    }
                    if (adds.size() > 0) {
                        Log.e(TAG, "adds.size() > 0");
                    }
                }
            });
        } else if (call.method.equals("quitGroup")) {

            String groupId = call.argument("groupId");

            TIMGroupManager.getInstance().quitGroup(groupId, new TIMCallBack() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "quitGroup failed, code: " + code + "|desc: " + desc);
                    result.error(desc, "quitGroup failed, code: " + code, null);
                }

                @Override
                public void onSuccess() {
                    Log.e(TAG, "quit group succ");
                    result.success("quit group succ");
                }
            });
        } else if (call.method.equals("deleteGroupMember")) {
            String groupId = call.argument("groupId");
            ArrayList deleteList = call.argument("deleteList");

            TIMGroupManager.DeleteMemberParam param = new TIMGroupManager.DeleteMemberParam(groupId, deleteList);
            param.setReason("some reason");

            TIMGroupManager.getInstance().deleteGroupMember(param, new TIMValueCallBack<List<TIMGroupMemberResult>>() {
                @Override
                public void onError(int code, String desc) {
                    Log.e(TAG, "deleteGroupMember onErr. code: " + code + " errmsg: " + desc);
                    result.error(desc, "deleteGroup on Err code: " + code, null);
                }

                @Override
                public void onSuccess(List<TIMGroupMemberResult> results) { //群组成员操作结果
                    List<String> mData = new ArrayList<>();

                    for (TIMGroupMemberResult r : results) {
                        Log.d(TAG, "result: " + r.getResult()  //操作结果:  0：删除失败；1：删除成功；2：不是群组成员
                                + " user: " + r.getUser());    //用户帐号
                        mData.add("result:" + r.getResult()
                                + "user:" + r.getUser());
                    }
                    result.success(mData.toString());

                }
            });
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        Log.e(TAG, "onCancel() called with: o = [" + o + "]");
    }


    class Message {
        TIMUserProfile senderProfile;
        TIMConversation timConversation;
        TIMGroupMemberInfo timGroupMemberInfo;
        long timeStamp;
        TIMElem message;

        Message(TIMMessage timMessage) {
            timMessage.getSenderProfile(new TIMValueCallBack<TIMUserProfile>() {
                @Override
                public void onError(int i, String s) {

                }

                @Override
                public void onSuccess(TIMUserProfile timUserProfile) {
                    senderProfile = timUserProfile;
                }
            });
            timConversation = timMessage.getConversation();
            message = timMessage.getElement(0);
            timeStamp = timMessage.timestamp();
            timGroupMemberInfo = timMessage.getSenderGroupMemberProfile();
        }
    }
}
