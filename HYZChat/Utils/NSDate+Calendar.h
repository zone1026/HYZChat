//
//  NSDate+Calendar.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/29.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calendar)
/**
 * @dscription 日期的星期值
 */
- (NSInteger)weekValueForDate;

/**
 * @dscription 通过星期值返回星期几
 * @param weekValue 星期值
 */
+ (NSString *)weekStringFromNumber:(NSInteger)weekValue;

@end
