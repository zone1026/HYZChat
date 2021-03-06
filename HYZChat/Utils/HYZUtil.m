//
//  HYZUtil.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "HYZUtil.h"

@implementation HYZUtil

+ (BOOL)isEmptyOrNull:(NSString *)str {
    if (!str) // null object
        return YES;
    else
    {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([trimedString length] == 0)
            // empty string
            return YES;
        else if ([trimedString isEqualToString:@"null"])
            // is neither empty nor null
            return YES;
        else if ([trimedString isEqualToString:@"(null)"])
            // is neither empty nor null
            return YES;
        else if ([trimedString isEqualToString:@"<null>"])
            // is neither empty nor null
            return YES;
        else
            return NO;
    }
}

@end
