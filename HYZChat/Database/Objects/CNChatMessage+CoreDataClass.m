//
//  CNChatMessage+CoreDataClass.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//
//

#import "CNChatMessage+CoreDataClass.h"

@implementation CNChatMessage

- (BOOL)checkMsgTypeCanSupport {
    if (self.msg_type <= ChatMsgTypeFree || self.msg_type >= ChatMsgTypeUpperLimit)
        return NO;
    return YES;
}

- (BOOL)checkShowNickName {
    if ([self checkOneselfSendMsg])//自己不显示
        return NO;
    
    if (self.belong_session.target_type == ChatTargetTypeP2P)
        return NO;
    else if (self.belong_session.target_type == ChatTargetTypeP2G) {
        //群组是否开启了显示昵称。。。
    }
    
    return NO;
}

- (BOOL)checkMsgNeedUserLogo {
    //以后出现了不带头像的消息类型 在这里判断
    if (self.msg_type <= ChatMsgTypeFree || self.msg_type >= ChatMsgTypeUpperLimit)
        return NO;
    return YES;
}

- (BOOL)checkOneselfSendMsg {
    return self.send_userId == [DataManager sharedManager].currentUser.user_id;
}

@end
