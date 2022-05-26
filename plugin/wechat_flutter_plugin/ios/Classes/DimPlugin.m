#import "DimPlugin.h"
#import <ImSDK/ImSDK.h>
#import "YYModel.h"
#import "DimModel.h"
#import "MJExtension.h"
#import "MyGenerateTestUserSig.h"

@interface DimPlugin() <TIMConnListener, TIMUserStatusListener, TIMRefreshListener, TIMMessageListener, FlutterStreamHandler>
@property (nonatomic, strong) FlutterEventSink eventSink;

@end

@implementation DimPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"dim_method"
                                     binaryMessenger:[registrar messenger]];
    DimPlugin* instance = [[DimPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"dim_event" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if([ @"init" isEqualToString:call.method] ){
        int appidInt = [call.arguments[@"appid"] intValue];
        //初始化 SDK 基本配置
        TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
        config.sdkAppId = appidInt;
        config.connListener = self;
        
        //初始化 SDK
        int code = [[TIMManager sharedInstance] initSdk:config];
        NSLog(@"initSdk:result is %d", code);
        //将用户配置与通讯管理器进行绑定
        TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
        userConfig.userStatusListener = self;
        userConfig.refreshListener = self;
        [[TIMManager sharedInstance] setUserConfig:userConfig];
        [[TIMManager sharedInstance] removeMessageListener:self];
        [[TIMManager sharedInstance] addMessageListener:self];
         result(@"init Succ");
    } else if ([ @"im_logout" isEqualToString:call.method] ){
        [[TIMManager sharedInstance] logout:^{
            result(@"Logout Succ");
        } fail:^(int code, NSString *msg) {
            result([NSString stringWithFormat:@"Login Failed: %d->%@", code, msg]);
        }];
    }else if([@"im_login" isEqualToString:call.method]) {
    
        NSString *identifier = call.arguments[@"identifier"];
//        NSString *userSig = call.arguments[@"userSig"];
        NSString *userSig = [MyGenerateTestUserSig myGenTestUserSig:identifier];
        NSLog(@"identifier-->userSig:%@-->%@", identifier,userSig);
        TIMLoginParam *param = [[TIMLoginParam alloc ]init];
   
//        if(userSig == nil||userSig ==NULL){
//            userSig = [MyGenerateTestUserSig myGenTestUserSig:identifier];
//        }
        
        param.identifier = identifier;
        param.userSig = userSig;
        
        [[TIMManager sharedInstance] login: param succ:^(){
            result(@"Login Succ");
        } fail:^(int code, NSString * err) {
            NSLog(@"Login Failed: %d->%@", code, err);
            result([NSString stringWithFormat:@"Login Failed: %d->%@", code, err]);
        }];
    }else if([@"sdkLogout" isEqualToString:call.method]){
        [[TIMManager sharedInstance] logout:^{
            result(@"logout success");
        } fail:^(int code, NSString *msg) {
            [NSString stringWithFormat:@"logout failed. code %d desc %@", code, msg];
        }];
    }else if([@"getConversations" isEqualToString:call.method]){
        
        NSArray *conversationList = [[TIMManager sharedInstance] getConversationList];
        if (conversationList!=nil && conversationList.count>0) {
            NSMutableArray *dictArray = [[NSMutableArray alloc]init];
            for (TIMConversation *conversation in conversationList) {
                DimConversation *dimConversation = [DimConversation initWithTIMConversation:conversation ];
                [dictArray addObject:dimConversation];
            }
             NSString *jsonString = [dictArray yy_modelToJSONString];
            result(jsonString);
        }else{
            result(@"[]");
        }
    }else if([@"delConversation" isEqualToString:call.method]){
        NSString *identifier = call.arguments[@"identifier"];
        [[TIMManager sharedInstance] deleteConversation:TIM_C2C receiver:identifier];
        result(@"delConversation success");
    }else if([@"getMessages" isEqualToString:call.method]){
        NSString *identifier = call.arguments[@"identifier"];
        int count = [call.arguments[@"count"] intValue];
        int ctype = [call.arguments[@"ctype"] intValue];
        //TIMMessage *lastMsg = call.arguments[@"lastMsg"];
        TIMConversation *con = [[TIMManager sharedInstance] getConversation: ctype==2 ? TIM_GROUP:TIM_C2C receiver:identifier];
        [con getMessage:count last:NULL succ:^(NSArray *msgs) {
            if(msgs != nil && msgs.count > 0){
                NSMutableArray *dictArray = [[NSMutableArray alloc]init];
                for (TIMMessage *message in msgs) {
                    DimMessage *dimMessage = [DimMessage initWithTIMMessage:message];
                    [dictArray addObject:dimMessage];
                }
                 NSString *jsonString = [dictArray yy_modelToJSONString];
                result(jsonString);
            }else{
                result(@"[]");
            }
        } fail:^(int code, NSString *msg) {
            result([NSString stringWithFormat:@"get message failed. code: %d msg: %@", code, msg]);
        }];
    }else if([@"sendTextMessages" isEqualToString:call.method]){
        NSString *identifier = call.arguments[@"identifier"];
        NSString *content = call.arguments[@"content"];
        TIMMessage *msg = [TIMMessage new];
        
        //添加文本内容
        TIMTextElem *elem = [TIMTextElem new];
        elem.text = content;
        
        //将elem添加到消息
        if([msg addElem:elem] != 0){
            NSLog(@"addElement failed");
            return;
        }
        TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:identifier];
        //发送消息
        [conversation sendMessage:msg succ:^{
            result(@"send message ok");
        } fail:^(int code, NSString *msg) {
            result([NSString stringWithFormat:@"send message failed. code: %d desc:%@", code, msg]);
        }];
    }else if([@"sendImageMessages" isEqualToString:call.method]){
        NSString *identifier = call.arguments[@"identifier"];
        NSString *iamgePath = call.arguments[@"image_path"];
        //构造一条消息
        TIMMessage *msg = [TIMMessage new];
        
        //添加图片
        TIMImageElem *elem = [TIMImageElem new];
        elem.path = iamgePath;
        if([msg addElem:elem] != 0){
            NSLog(@"addElement failed");
        }
        
        TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:identifier];
        [conversation sendMessage:msg succ:^{
            result(@"SendMsg ok");
        } fail:^(int code, NSString *msg) {
            result([NSString stringWithFormat:@"send message failed. code: %d desc:%@", code, msg]);
        }];
        
    }else if([@"sendSoundMessages" isEqualToString:call.method]){
        NSString *identifier = call.arguments[@"identifier"];
        NSString *soundpath = call.arguments[@"sound_path"];
        int duration = [call.arguments[@"duration"] intValue];
        //构造一条消息
        TIMMessage *msg = [TIMMessage new];
        
        //添加声音
        TIMSoundElem *elem = [TIMSoundElem new];
        elem.path = soundpath;
        elem.second = duration;
        if([msg addElem:elem] != 0){
            NSLog(@"addElement failed");
        }
        
        TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:identifier];
        [conversation sendMessage:msg succ:^{
            result(@"SendMsg ok");
        } fail:^(int code, NSString *msg) {
            result([NSString stringWithFormat:@"send message failed. code: %d desc:%@", code, msg]);
        }];
        
    }else if([@"sendLocation" isEqualToString:call.method]){
        NSString *identifier = call.arguments[@"identifier"];
        double lat = [call.arguments[@"lat"] doubleValue];
        double lng = [call.arguments[@"lng"] doubleValue];
        NSString *desc = call.arguments[@"desc"];
        //构造一条消息
        TIMMessage *msg = [TIMMessage new];
        
        //添加图片
        TIMLocationElem *elem = [TIMLocationElem new];
        elem.latitude = lat;
        elem.longitude = lng;
        elem.desc = desc;
        if([msg addElem:elem] != 0){
            NSLog(@"addElement failed");
        }
        
        TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:identifier];
        [conversation sendMessage:msg succ:^{
            result(@"SendMsg ok");
        } fail:^(int code, NSString *msg) {
            result([NSString stringWithFormat:@"send message failed. code: %d desc:%@", code, msg]);
        }];
        
    }
    else if([@"post_data_test" isEqualToString:call.method]){
        
        NSLog(@"post_data_test invoke");
        self.eventSink(@"hahahahha  I am from listener");
        
    }else if([@"addFriend" isEqualToString:call.method]){
        
        NSString *identifier = call.arguments[@"identifier"];
        
        TIMFriendRequest *req = [[TIMFriendRequest alloc] init];
        req.identifier = identifier;
        req.addWording =@"请添加我";
        req.addSource = @"AddSource_Type_iOS";
        [[TIMFriendshipManager sharedInstance] addFriend:req succ:^(TIMFriendResult *addResult) {
            if (addResult.result_code == 0)
                result(@"添加成功");
            else
                result([NSString stringWithFormat:@"异常：%ld, %@", (long)addResult.result_code, addResult.result_info]);
        } fail:^(int code, NSString *msg) {
             result([NSString stringWithFormat:@"失败：%d, %@", code, msg]);
        }];
        
    }else if([@"delFriend" isEqualToString:call.method]){
        
        
        NSMutableArray * del_users = [[NSMutableArray alloc] init];
        // 删除好友 iOS_002
        [del_users addObject: (NSString *)call.arguments[@"identifier"]];
        // TIM_FRIEND_DEL_BOTH 指定删除双向好友
        [[TIMFriendshipManager sharedInstance] deleteFriends:del_users delType:TIM_FRIEND_DEL_BOTH succ:^(NSArray<TIMFriendResult *> *results) {
            for (TIMFriendResult * res in results) {
                if (res.result_code != TIM_FRIEND_STATUS_SUCC) {
                   result([NSString stringWithFormat:@"deleteFriends failed: user=%@ status=%ld", res.identifier, (long)res.result_code]);
                }
                else {
                    result([NSString stringWithFormat:@"deleteFriends succ: user=%@ status=%ld", res.identifier, (long)res.result_code]);
                }
            }
        } fail:^(int code, NSString * err) {
            result([NSString stringWithFormat:@"deleteFriends failed: code=%d err=%@", code, err]);
        }];
        
    }else if([@"listFriends" isEqualToString:call.method]){
        
        [[TIMFriendshipManager sharedInstance] getFriendList:^(NSArray * arr) {
            NSString *jsonString = [arr yy_modelToJSONString];
            result(jsonString);
        }fail:^(int code, NSString * err) {
            result([NSString stringWithFormat:@"GetFriendList fail: code=%d err=%@", code, err]);
        }];
        
    }else if([@"opFriend" isEqualToString:call.method]){
        
        NSString *identifier = call.arguments[@"identifier"];
        NSString *opTypeStr = call.arguments[@"opTypeStr"];
        TIMFriendResponse *response = [[TIMFriendResponse alloc] init];
        response.identifier = identifier;
        if([opTypeStr isEqualToString:@"Y"]){
            response.responseType = TIM_FRIEND_RESPONSE_AGREE_AND_ADD;
        }else{
            response.responseType = TIM_FRIEND_RESPONSE_REJECT;
        }
        [[TIMFriendshipManager sharedInstance] doResponse:response succ:^(TIMFriendResult *res) {
            if (res.result_code != TIM_FRIEND_STATUS_SUCC) {
                result([NSString stringWithFormat:@"deleteFriends failed: user=%@ status=%ld", res.identifier, (long)res.result_code]);
            }
            else {
                result([NSString stringWithFormat:@"deleteFriends succ: user=%@ status=%ld", res.identifier, (long)res.result_code]);
            }
        } fail:^(int code, NSString *err) {
           result([NSString stringWithFormat:@"opFriend fail: code=%d err=%@", code, err]);
        }];
        
    }
    else if([@"getUsersProfile" isEqualToString:call.method]){
        
        NSArray *arr1 = call.arguments[@"users"];
        
    
        [[TIMFriendshipManager sharedInstance] getUsersProfile:arr1 forceUpdate:YES succ:^(NSArray * arr) {
//            for (TIMUserProfile * profile in arr) {
//                NSLog(@"user=%@", profile);
//            }
            if (arr !=NULL && arr.count >0) {
                NSString *jsonString = [arr yy_modelToJSONString];
                result(jsonString);
            }else{
                result(@"[]");
            }
        }fail:^(int code, NSString * err) {

            result([NSString stringWithFormat:@"getUsersProfile fail: code=%d err=%@", code, err]);
        }];
    }
    else if([@"setUsersProfile" isEqualToString:call.method]){
        NSString *nick = call.arguments[@"nick"];
        NSInteger gender = (NSInteger)call.arguments[@"gender"];
        NSString *faceUrl = call.arguments[@"faceUrl"];
        [[TIMFriendshipManager sharedInstance]modifySelfProfile:@{TIMProfileTypeKey_Nick:nick,TIMProfileTypeKey_FaceUrl:faceUrl,TIMProfileTypeKey_Gender:[NSNumber numberWithInt:gender==1?TIM_GENDER_MALE:TIM_GENDER_FEMALE]} succ:^{
            result(@"setUsersProfile succ");
        } fail:^(int code, NSString *err) {
            result([NSString stringWithFormat:@"GetFriendList fail: code=%d err=%@", code, err]);
        }];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}


#pragma mark - FlutterStreamHandler
- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;
    //    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    //    [self sendBatteryStateEvent];
    //    [[NSNotificationCenter defaultCenter]
    //     addObserver:self
    //     selector:@selector(onBatteryStateDidChange:)
    //     name:UIDeviceBatteryStateDidChangeNotification
    //     object:nil];
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments{
    return nil;
}

#pragma mark - TIMMessageListener
/**
 *  新消息回调通知
 *
 *  @param msgs 新消息列表，TIMMessage 类型数组
 */
- (void)onNewMessage:(NSArray*)msgs{
    if(msgs != nil && msgs.count > 0){
        NSMutableArray *dictArray = [[NSMutableArray alloc]init];
        for (TIMMessage *message in msgs) {
            DimMessage *dimMessage = [DimMessage initWithTIMMessage:message];
            [dictArray addObject:dimMessage];
        }
        NSString *jsonString = [dictArray yy_modelToJSONString];
        self.eventSink(jsonString);
    }
}

#pragma mark - TIMRefreshListener
/**
 *  会话列表变动
 */
- (void)onRefresh{
    self.eventSink(@"[]");
}
@end
