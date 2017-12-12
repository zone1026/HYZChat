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
    if (self.target_type == ChatTargetTypeP2P)
        return NO;
    else if (self.target_type == ChatTargetTypeP2G) {
        //群组是否开启了显示昵称。。。
    }
    return NO;
}
@end
