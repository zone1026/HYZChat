//
//  UIImageView+WebImage.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/29.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebImage)

/**
 * @description 展示头像网络图片
 * @param src 原图的URL
 * @param thumb 缩略图的URL
 */
- (void)web_logoImage:(NSString *)src withThumbImageURLStr:(NSString *)thumb;
/**
 * @description 展示网络图片
 * @param src 原图的URL
 * @param thumb 缩略图的URL
 * @param imageName 占位图的名称
 */
- (void)web_srcImageURLStr:(NSString *)src withThumbImageURLStr:(NSString *)thumb
   withPlaceholderImageName:(NSString *)imageName;

@end
