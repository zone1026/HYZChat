//
//  CALayer+HYZUtil.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (HYZUtil)
- (void)setBorder:(CGFloat)border withColor:(UIColor *)color withCorner:(CGFloat)cornerRadius;
@end
