//
//  UIView+HYZFrame.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HYZFrame)

@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat minX;
@property (nonatomic, assign, readonly) CGFloat minY;
@property (nonatomic, assign, readonly) CGFloat maxX;
@property (nonatomic, assign, readonly) CGFloat maxY;

- (void)moveDownOffY:(CGFloat)offY;
- (void)addWidth:(CGFloat)offW;
- (void)addHeight:(CGFloat)offH;

@end
