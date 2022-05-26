//
//  DimModel.h
//  dim
//
//  Created by 飞鱼 on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
NS_ASSUME_NONNULL_BEGIN
//@class TIMUserProfile, TIMConversation, TIMMessage, TIMGroupMemberInfo, TIMElem;


@interface DimUser : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *faceURL;
@property (nonatomic, copy) NSString *selfSignature;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger birthday;
@property (nonatomic, copy) NSString *location;

+ (DimUser *)initWithTimUser:(TIMUserProfile *)timUserProfile;

@end

@interface DimConversation : NSObject
@property(nonatomic,assign) TIMConversationType type;
@property (nonatomic, copy) NSString *peer;

+ (DimConversation *)initWithTIMConversation:(TIMConversation *)timConversation;
@end

@interface DimMessage : NSObject
@property (nonatomic, strong) DimUser *senderProfile;
@property (nonatomic, copy)   NSString *sender;
@property (nonatomic, strong) DimConversation *timConversation;
@property (nonatomic, strong) TIMGroupMemberInfo *timGroupMemberInfo;
@property (nonatomic, strong) TIMElem *message;
@property (nonatomic, assign) NSTimeInterval timeStamp;

+ (DimMessage *)initWithTIMMessage:(TIMMessage *)timMessage;
@end

NS_ASSUME_NONNULL_END
