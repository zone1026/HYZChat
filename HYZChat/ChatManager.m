//
//  ChatManager.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/10/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatManager.h"

@implementation ChatManager

+ (instancetype)sharedManager {
    static ChatManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

@end
