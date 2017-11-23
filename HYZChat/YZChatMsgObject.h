//
//  YZChatMsgObject.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/23.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNChatMessage+CoreDataClass.h"

@interface YZChatMsgObject : NSObject
@property (strong, nonatomic) CNChatMessage *chatMessage;
@end
