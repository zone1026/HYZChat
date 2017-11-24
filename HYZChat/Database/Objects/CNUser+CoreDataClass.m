//
//  CNUser+CoreDataClass.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "CNUser+CoreDataClass.h"
#import "CNChatMessage+CoreDataClass.h"

@implementation CNUser

- (NSArray *)getSubChatMessageSequence {
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"send_time" ascending:YES]];//已发送时间生序，send_time是unix时间戳
    return [self.has_chatMessages sortedArrayUsingDescriptors:sortDesc];
}

@end
