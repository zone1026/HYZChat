//
//  HYZAlert.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/12.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "HYZAlert.h"
#import "UIAlertAction+ButtonIndex.h"

//////////////////////////////////////////////// 快捷展示弹框 ////////////////////////////////////////////////////////////////////////

@implementation HYZAlert

+ (void) showInfo:(NSString*)info underTitle:(NSString*)title {
    CNAlertView *alertView = [[CNAlertView alloc] initWithTitle:title
                                                        message:info
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end


///////////////////////////////////////////////// AlertView重构 /////////////////////////////////////////////////

@implementation CNAlertView

// 多项显示定义初始化
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id <CNAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super init])
    {
        self.firstOtherButtonIndex = 1;
        self.cancelButtonIndex = 0;
        self.delegate = delegate;
        self.alertController = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self clickedButtonAtIndex:action.buttonIndex];
                                                             }];
        cancelAction.buttonIndex = self.cancelButtonIndex;
        [self.alertController addAction:cancelAction];
        
        if ([HYZUtil isEmptyOrNull:otherButtonTitles] == NO)
        {
            UIAlertAction *otherAction;
            if ([HYZUtil isEmptyOrNull:otherButtonTitles] == NO)
            {
                NSInteger index = self.firstOtherButtonIndex;
                va_list params;//定义一个指向个数可变的参数列表指针
                va_start(params, otherButtonTitles);//va_start 得到第一个可变参数地址
                NSString *arg;
                NSString *prev = otherButtonTitles;
                otherAction = [UIAlertAction actionWithTitle:prev
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self clickedButtonAtIndex:action.buttonIndex];
                                                     }];
                otherAction.buttonIndex = index;
                [self.alertController addAction:otherAction];
                
                //va_arg 指向下一个参数地址
                while ((arg = va_arg(params, NSString *)))
                {
                    if ([HYZUtil isEmptyOrNull:arg] == NO)
                    {
                        index++;
                        otherAction = [UIAlertAction actionWithTitle:arg
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self clickedButtonAtIndex:action.buttonIndex];
                                                             }];
                        otherAction.buttonIndex = index;
                        [self.alertController addAction:otherAction];
                    }
                }
                //置空
                va_end(params);
            }
        }
    }
    return self;
}

// 确认取消定义初始化
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id<CNAlertViewDelegate>)delegate
{
    return [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

// 纯信息展示初始化
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    return [self initWithTitle:title message:message delegate:nil];
}

// 显示内容
- (void)show
{
    UIViewController *currentViewController = [HYZUtil getCurrentWindowViewController];
    if (currentViewController != nil)
        [currentViewController presentViewController:self.alertController animated:YES completion:nil];
}

// 完整包装，直接显示确定取消
+ (void)showWithTitle:(NSString *)title message:(NSString *)message tapBlock:(CNAlertViewCompletionBlock)tapBlock
{
    [self showWithTitle:title message:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:tapBlock];
}

// 完整包装，直接显示
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
             tapBlock:(CNAlertViewCompletionBlock)tapBlock
{
    NSString *otherBtnTitleStr = nil;
    if (otherButtonTitles != nil && otherButtonTitles.count > 0)
        otherBtnTitleStr = [otherButtonTitles componentsJoinedByString:@","];
    
    CNAlertView *alertView = [[CNAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherBtnTitleStr, nil];
    alertView.tapBlock = tapBlock;
    [alertView show];
}

// 点击按钮并抛出代理
- (void)clickedButtonAtIndex:(NSInteger)btnIndex
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        [self.delegate alertView:self clickedButtonAtIndex:btnIndex];
    if (self.tapBlock != nil)
        self.tapBlock(self, btnIndex);
}

@end
