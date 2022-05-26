//
//  DimModel.m
//  dim
//
//  Created by 飞鱼 on 2019/2/15.
//

#import "DimModel.h"

@implementation DimUser

+ (DimUser *)initWithTimUser:(TIMUserProfile *)timUserProfile {
    DimUser *dimUser = [[DimUser alloc]init];
    dimUser.identifier = timUserProfile.identifier;
    dimUser.nickName = timUserProfile.nickname;
    dimUser.faceURL = timUserProfile.faceURL;
    dimUser.selfSignature = [[NSString alloc]initWithData:timUserProfile.selfSignature  encoding:NSUTF8StringEncoding];
    dimUser.gender = timUserProfile.gender ? timUserProfile.gender : 1;
    dimUser.birthday = timUserProfile.birthday;
    dimUser.location = [[NSString alloc]initWithData:timUserProfile.location  encoding:NSUTF8StringEncoding];
    return dimUser;
}

@end

@implementation DimConversation

+ (DimConversation *)initWithTIMConversation:(TIMConversation *)timConversation {
    DimConversation *dimConversation = [[DimConversation alloc]init];
    dimConversation.type = timConversation.getType;
    dimConversation.peer = timConversation.getReceiver;
    return dimConversation;
}
@end

@implementation DimMessage

+ (DimMessage *)initWithTIMMessage:(TIMMessage *)timMessage {
    DimMessage *dimMessage = [[DimMessage alloc]init];
    dimMessage.sender = timMessage.sender;
    dimMessage.timConversation = [DimConversation initWithTIMConversation:timMessage.getConversation];
    dimMessage.timGroupMemberInfo = timMessage.getSenderGroupMemberProfile;
    dimMessage.message = [timMessage getElem:0];
    dimMessage.timeStamp = timMessage.timestamp.timeIntervalSince1970;
    
    return dimMessage;
}
@end
