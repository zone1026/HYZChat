//
//  UIView+HYZFrame.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "UIView+HYZFrame.h"

@implementation UIView (HYZFrame)

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (CGFloat)minX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)minY {
    return CGRectGetMinY(self.frame);
}
- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)moveDownOffY:(CGFloat)offY {
    self.frame = CGRectMake(self.minX, self.minY + offY, self.width, self.height);
}

- (void)addWidth:(CGFloat)offW {
    self.frame = CGRectMake(self.minX, self.minY, self.width + offW, self.height);
}

- (void)addHeight:(CGFloat)offH {
    self.frame = CGRectMake(self.minX, self.minY, self.width, self.height + offH);
}

@end
