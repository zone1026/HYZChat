//
//  ChatTableCellInfo.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatTableCellInfo.h"

@implementation ChatTableCellInfo

@synthesize type;
@synthesize className;
@synthesize indentifier;

- (NSString *)description {
    return [NSString stringWithFormat:@"消息类型：%@, 类文件名：%@, cell标识：%@", @(self.type), self.className, self.indentifier];
}

@end
