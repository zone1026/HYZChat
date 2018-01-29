//
//  CNSession+CoreDataClass.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import "CNSession+CoreDataClass.h"

@implementation CNSession

- (NSString *)obtainLogoURLStr {
    return self.session_logo;
}

- (NSURL *)obtainLogoURL {
    return [NSURL URLWithString:[self obtainLogoURLStr]];
}

@end
