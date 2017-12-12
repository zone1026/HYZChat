//
//  UIAlertAction+ButtonIndex.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/12.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "UIAlertAction+ButtonIndex.h"
#import <objc/runtime.h>

@implementation UIAlertAction (ButtonIndex)

static char *static_button_index = "static_button_index";

- (void)setButtonIndex:(NSInteger)buttonIndex {
    objc_setAssociatedObject(self, &static_button_index, @(buttonIndex), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)buttonIndex {
    NSNumber *flagNum = objc_getAssociatedObject(self, &static_button_index);
    return flagNum.integerValue;
}


@end
