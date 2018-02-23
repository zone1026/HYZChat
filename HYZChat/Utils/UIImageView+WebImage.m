//
//  UIImageView+WebImage.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/29.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (WebImage)

- (void)web_logoImage:(NSString *)src withThumbImageURLStr:(NSString *)thumb {
    [self web_srcImageURLStr:src withThumbImageURLStr:thumb withPlaceholderImageName:@"DEFAULT_LOGO"];
}

- (void)web_srcImageURLStr:(NSString *)src withThumbImageURLStr:(NSString *)thumb
   withPlaceholderImageName:(NSString *)imageName {
    UIImage *locolSrcImage = [UIImage imageNamed:src];
    if (nil != locolSrcImage) {
        self.image = locolSrcImage;
        return;
    }
    // 占位图片
    UIImage *placeholder = [UIImage imageNamed:imageName];
    // 从内存/沙盒缓存中获得原图
    UIImage *srcImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:src];
    if (nil != srcImage) //如果内存/沙盒缓存有原图，那么就直接显示原图（不关心当前的网络状态）
        [self sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:placeholder];
    else { //需要下载
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        if (YES == manager.isReachableViaWiFi) //WI_FI网络下,下载原图
            [self sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:placeholder];
        else if (YES == manager.isReachableViaWWAN) //移动网络下，下载缩略图
            [self sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:placeholder];
        else { //没有网络
            UIImage *thumbImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumb];
            if (nil != thumbImage) // 内存/沙盒缓存中有小图
                [self sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:placeholder];
            else
                [self sd_setImageWithURL:nil placeholderImage:placeholder];
        }
    }
}

- (void)web_meLogoImage {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    [self web_logoImage:currentUser.assign_userInfo.u_src withThumbImageURLStr:currentUser.assign_userInfo.u_thumb];
}

@end
