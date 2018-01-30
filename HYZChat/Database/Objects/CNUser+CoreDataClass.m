//
//  CNUser+CoreDataClass.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "CNUser+CoreDataClass.h"
#import "CNSession+CoreDataClass.h"

@implementation CNUser

- (NSArray *)getSubSessionSequence {
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"last_time" ascending:NO]];//last_time是unix时间戳
    return [self.has_sessions sortedArrayUsingDescriptors:sortDesc];
}

@end
