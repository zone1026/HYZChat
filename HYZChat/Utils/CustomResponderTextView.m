//
//  CustomResponderTextView.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/20.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "CustomResponderTextView.h"
#import "ChatManager.h"

@implementation CustomResponderTextView

/**
 * @description 下一个响应的对象
 */
- (UIResponder *)nextResponder {
    if ([ChatManager sharedManager].cellLongPressResponder != nil)//由于长按cell时，有可能此时键盘已经弹出
        return [ChatManager sharedManager].cellLongPressResponder;
    
    return [super nextResponder];
}

/**  可以响应的方法 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([ChatManager sharedManager].cellLongPressResponder != nil)
        return NO;
    
    return [super canPerformAction:action withSender:sender];
}

@end
