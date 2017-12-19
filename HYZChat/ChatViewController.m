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
#import "ChatDataSource+TableView.h"
#import "ChatDataSource+ChatMsg.h"
#import "InputViewFrameChanageData.h"
#import "UIView+HYZFrame.h"
#import "ChatBottomController.h"
#import "ChatManager.h"

@interface ChatViewController ()
/** 列表的数据源 */
@property (strong, nonatomic) IBOutlet ChatDataSource *chatDataSource;
/** 聊天表格的背景图 */
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
/** 聊天表格 */
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
/** 底部功能视图 */
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
/** 底部功能视图的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraintHeight;

/** 消息的属性 */
@property (strong, nonatomic) ChatMessageAttribute *messageAttribute;
/** 输入框的高度 */
@property (assign, nonatomic) CGFloat inputTextViewHeight;
/** 键盘的高度 */
@property (assign, nonatomic) CGFloat kbHeight;
/** 表情视图的高度 */
@property (assign, nonatomic) CGFloat emotionViewHeiht;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputTextViewHeight = ChatViewTopInputViewDefaultHeight;
    self.emotionViewHeiht = NSNotFound;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerMessageNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeMessageNoitication];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self scrollTableViewToBottom];
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

/** 注册消息通知 */
- (void)registerMessageNotification {
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiInputViewFrameChanage:)
                                                 name:NotiInputViewFrameChanage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiChatBottomFunctionButtonClick:)
                                                 name:NotiChatFunctionBtnClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiUpdateChatViewForSendMsg:)
                                                 name:NotiUpdateChatViewForSendMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiChatBottomPanelShrinkage:)
                                                 name:NotiChatBottomPanelShrinkage object:nil];
}

/** 移除消息通知 */
- (void)removeMessageNoitication {
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiInputViewFrameChanage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiChatFunctionBtnClick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiUpdateChatViewForSendMsg object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiChatBottomPanelShrinkage object:nil];
}

/** 键盘弹出 */
- (void)keyboardWillShow:(NSNotification *)notification {
    [ChatManager sharedManager].bottomMode = ChatBottomTargetText;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiEmotionBtnDefaultStauts object:nil];
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    [UIView animateWithDuration:chatAnimateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.viewBottomConstraintHeight.constant = self.inputTextViewHeight + kbRect.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self scrollTableViewToBottom];
    }];
    
    self.kbHeight = kbRect.size.height;
}

/** 键盘隐藏 */
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:chatAnimateDuration animations:^{
        self.viewBottomConstraintHeight.constant = self.inputTextViewHeight;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
    self.kbHeight = 0.0;
}

/** viewbottom 高度发生变化 */
- (void)handleNotiInputViewFrameChanage:(NSNotification *)notification {
    if (notification.object != nil && [notification.object isKindOfClass:[InputViewFrameChanageData class]]) {
        InputViewFrameChanageData *data = notification.object;
        if (data.isInputChanage == YES || data.isImmediatelyChanageInputHeight == YES) {
            [UIView animateWithDuration:chatAnimateDuration animations:^{
                if ([ChatManager sharedManager].bottomMode == ChatBottomTargetEmotion)
                    self.viewBottomConstraintHeight.constant = self.emotionViewHeiht + data.inputTextViewHeight;
                else if ([ChatManager sharedManager].bottomMode == ChatBottomTargetText)
                    self.viewBottomConstraintHeight.constant = self.kbHeight + data.inputTextViewHeight;
                else
                    self.viewBottomConstraintHeight.constant = data.inputViewHeight;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self scrollTableViewToBottom];
            }];
        }
        else {
            [UIView animateWithDuration:chatAnimateDuration animations:^{
                self.viewBottomConstraintHeight.constant = data.inputViewHeight;
            } completion:^(BOOL finished) {
                if ([ChatManager sharedManager].bottomMode == ChatBottomTargetEmotion)
                    self.emotionViewHeiht = data.inputViewHeight - data.inputTextViewHeight;
                [self scrollTableViewToBottom];
            }];
        }
        self.inputTextViewHeight = data.inputTextViewHeight;
    }
}

/** 底部功能区 */
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

/** 通过发送消息更新聊天表格 */
- (void)handleNotiUpdateChatViewForSendMsg:(NSNotification *)notification {
    if (notification.userInfo != nil) {
        ChatMsgType msgType = [notification.userInfo[@"type"] integerValue];
        NSString *content = notification.userInfo[@"content"];
#warning send chat msg
        [self.chatDataSource addChatMsg:msgType withMsgContent:content];
        [self.chatTableView reloadData];
    }
}

/** 收缩聊天底部面板通知 */
- (void)handleNotiChatBottomPanelShrinkage:(NSNotification *)notifcation {
    [ChatManager sharedManager].bottomMode = ChatBottomTargetFree;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiEmotionBtnDefaultStauts object:nil];
    [UIView animateWithDuration:chatAnimateDuration animations:^{
        self.viewBottomConstraintHeight.constant = self.inputTextViewHeight;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

#pragma mark - 私有方法

/** 将列表信息滑动到底部 */
- (void)scrollTableViewToBottom {
    if ([self.chatDataSource isEmptyData] == NO)
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatDataSource.chatMsgArr.count - 1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
