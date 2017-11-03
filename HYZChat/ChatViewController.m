//
//  ChatViewController.m
//  HyzChat
//
//  Created by 黄亚州 on 2017/8/31.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessageAttribute.h"
#import "ChatDataSource.h"
#import "InputViewFrameChanageData.h"
#import "UIView+HYZFrame.h"
#import "ChatBottomController.h"
#import "ChatDataSource+TableView.h"
#import "ChatManager.h"

@interface ChatViewController ()
@property (strong, nonatomic) IBOutlet ChatDataSource *chatDataSource;

@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraintHeight;

@property (strong, nonatomic) ChatMessageAttribute *messageAttribute;
@property (assign, nonatomic) CGFloat inputTextViewHeight;
@property (assign, nonatomic) CGFloat kbHeight;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputTextViewHeight = viewTopDefaultHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerMessageNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeMessageNoitication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)barBtnBackSelector:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - public methon

- (void)addChatMessageAttribute:(ChatMessageAttribute *)attribute {
    self.messageAttribute = attribute;
}

#pragma mark - message notification

- (void)registerMessageNotification {
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiInputViewFrameChanage:) name:NotiInputViewFrameChanage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiChatBottomFunctionButtonClick:) name:NotiChatFunctionBtnClick object:nil];
}

- (void)removeMessageNoitication {
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiInputViewFrameChanage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiChatFunctionBtnClick object:nil];
}

//键盘弹出
- (void)keyboardWillShow:(NSNotification *)notification {
    [ChatManager sharedManager].bottomMode = ChatBottomTargetText;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiEmotionBtnDefaultStauts object:nil];
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    [UIView animateWithDuration:chatAnimateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.viewBottomConstraintHeight.constant = self.inputTextViewHeight + kbRect.size.height;
    } completion:^(BOOL finished) {}];
    self.kbHeight = kbRect.size.height;
}

//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:chatAnimateDuration animations:^{
        self.viewBottomConstraintHeight.constant = self.inputTextViewHeight;
    } completion:^(BOOL finished) {}];
    self.kbHeight = 0.0;
}

//viewbottom 高度发生变化
- (void)handleNotiInputViewFrameChanage:(NSNotification *)notification {
    if (notification.object != nil && [notification.object isKindOfClass:[InputViewFrameChanageData class]]) {
        InputViewFrameChanageData *data = notification.object;
        if (data.isImmediatelyChanageInputHeight == YES) {
            [UIView animateWithDuration:chatAnimateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewBottomConstraintHeight.constant = self.kbHeight + data.inputViewHeight;
            } completion:nil];
            [ChatManager sharedManager].bottomMode = ChatBottomTargetFree;
        }
        else {
            if (data.isInputChanage == YES) {
                [UIView animateWithDuration:chatAnimateDuration animations:^{
                    self.viewBottomConstraintHeight.constant = self.kbHeight + data.inputTextViewHeight;
                } completion:^(BOOL finished) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiLiveshowInteractionScrollCellToBottom object:nil];
                }];
            }
            else {
                [UIView animateWithDuration:chatAnimateDuration animations:^{    
                    self.viewBottomConstraintHeight.constant = data.inputViewHeight;
                } completion:^(BOOL finished) {
                    if ([ChatManager sharedManager].bottomMode == ChatBottomTargetEmotion) {
                    }
                }];
            }
        }
        self.inputTextViewHeight = data.inputTextViewHeight;
    }
}

- (void)handleNotiChatBottomFunctionButtonClick:(NSNotification *)notification {
    if (notification.object != nil) {
        NSInteger btnValue = [notification.object integerValue];
        switch (btnValue) {
            case 0:
                [self openImage];
                break;
            case 1:
                [self openPhoto];
                break;
            case 2:
                [self openOnlineVideo];
                break;
            case 3:
                [self openLocation];
                break;
            case 4:
                [self openRedEnvelope];
                break;
            case 5:
                [self openSight];
                break;
            case 6:
                [self openUserReport];
                break;
            case 7:
                [self openMyCard];
                break;
            case 8:
                [self openCollect];
                break;
            default:
                break;
        }
    }
}

#pragma mark - chat bottom function button jump

//照片
- (void)openImage {
    
}

//相机
- (void)openPhoto {
    
}

//打开网络视频
- (void)openOnlineVideo {
    
}

//打开位置
- (void)openLocation {
    
}

//打开发红包
- (void)openRedEnvelope {
    
}

//打开小视频
- (void)openSight {
    
}

//打开用户举报
- (void)openUserReport {
    
}

//打开个人名片
- (void)openMyCard {
    
}

//打开个人名片
- (void)openCollect {
    
}

@end
