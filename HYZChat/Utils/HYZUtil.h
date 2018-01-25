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
 * @description 获取当前时间戳
 */
+ (NSTimeInterval)getCurrentTimestamp;

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
/**
 * @description 文本所需要占用的尺寸
 * @param str 文本信息
 * @param width 文本所占用的宽度
 * @param font 文本的字体属性
 */
+ (CGSize)autoFitSizeOfStr:(NSString *)str withWidth:(CGFloat)width withFont:(UIFont *)font;
/**
 * @description 获取一个UUID
 */
+ (NSString *)getUUID;

/**
 * @description 获得换行模式属性
 */
+ (NSDictionary *)getWrapModeAttributes;
/**
 * @decription 获取当前页面的ViewController
 */
+ (UIViewController *)getCurrentWindowViewController;
/**
 * @decription 检测手机号是否合法
 * @param mobileNum 手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 * @decription 实例化ViewController
 * @param identifier ViewController的标识
 * @param name ViewController所在storyboard的文件名
 */
+ (UIViewController *)instantiateViewController:(NSString *)identifier withStoryboardName:(NSString *)name;

@end
