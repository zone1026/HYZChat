//
//  CNSession+CoreDataClass.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CNChatMessage, CNUser;

NS_ASSUME_NONNULL_BEGIN

@interface CNSession : NSManagedObject
/**
 * @deciption 获取logo的URL字符串
 */
- (NSString *)obtainLogoURLStr;
/**
 * @deciption 获取logo的URL
 */
- (NSURL *)obtainLogoURL;

@end

NS_ASSUME_NONNULL_END

#import "CNSession+CoreDataProperties.h"
