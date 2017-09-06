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

static const CGFloat animateDuration = 0.3f;

@interface ChatViewController ()
@property (strong, nonatomic) IBOutlet ChatDataSource *chatDataSource;

@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraintBottom;

@property (strong, nonatomic) ChatMessageAttribute *messageAttribute;
@property (assign, nonatomic) ChatTextViewCurrentInputTarget inputModel;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiChatBottomFunctionButtonClick:) name:NotiChatBottomFunctionButtonClick object:nil];
}

- (void)removeMessageNoitication {
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiInputViewFrameChanage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiChatBottomFunctionButtonClick object:nil];
}

//键盘弹出
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0.0, -kbRect.size.height);
    [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.chatTableView.transform = self.viewBottom.transform = transform;
    } completion:^(BOOL finished) {
    }];
}

//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    CGAffineTransform transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:animateDuration animations:^{
        self.chatTableView.transform = self.viewBottom.transform = transform;
    } completion:^(BOOL finished) {
    }];
}

//viewbottom 高度发生变化
- (void)handleNotiInputViewFrameChanage:(NSNotification *)notification {
    if (notification.object != nil && [notification.object isKindOfClass:[InputViewFrameChanageData class]]) {
        InputViewFrameChanageData *data = notification.object;
        if (data.isImmediatelyChanageInputHeight == YES) {
            self.viewBottomConstraintHeight.constant = 44.0;
            self.inputModel = ChatTextViewCurrentInputTargetFree;
        }
        else {
            if (data.isInputChanage) {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.viewBottomConstraintHeight.constant = data.inputViewHeight;
                    
                } completion:^(BOOL finished) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiLiveshowInteractionScrollCellToBottom object:nil];
                }];
            }
            else {
                self.inputModel = data.isEmotionModel == YES ? ChatTextViewCurrentInputTargetEmotion : ChatTextViewCurrentInputTargetText;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.viewBottomConstraintHeight.constant = data.inputViewHeight;
//                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    if (self.inputModel == ChatTextViewCurrentInputTargetEmotion) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:NotiLiveshowInteractionScrollCellToBottom object:nil];
                    }
                }];
            }
        }
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
