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

@end
