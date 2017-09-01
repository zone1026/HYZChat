//
//  CALayer+HYZUtil.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "CALayer+HYZUtil.h"

@implementation CALayer (HYZUtil)

- (void)setBorder:(CGFloat)border withColor:(UIColor *)color withCorner:(CGFloat)cornerRadius {
    self.masksToBounds = YES;
    if (border > 0) {
        self.borderWidth = border;
    }
    if (color) {
        self.borderColor = [color CGColor];
    }
    if (cornerRadius > 0) {
        [self setCornerRadius:cornerRadius];
    }
}

@end
