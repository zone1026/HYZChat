//
//  HYZUtil.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYZUtil : NSObject

/**
 * @description 检测字符串是否是空字符串
 * @param str 待检测的字符串
 */
+ (BOOL)isEmptyOrNull:(NSString *)str;
/**
 * @description 获取plist文件数据
 * @param key plist中的key键
 * @param filename plist文件名
 */
+ (id)getPlistData:(NSString *)key inFile:(NSString *)filename;
/**
 * @description 生成纯色的image对象
 * @param color image颜色值
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
