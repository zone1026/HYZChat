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
#import "ChatMsgCell.h"

@interface ChatViewController ()<ChatDataSourceDelegate>
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

/** 导航栏返回barBtnItem */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnBack;
/** 导航栏信息barBtnItem */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnInfo;
/** 导航栏取消barBtnItem */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnCancel;

/** 工具栏取消barBtnItem */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarBtnTranspond;
/** 工具栏收藏barBtnItem */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarBtnCollect;
/** 工具栏删除barBtnItem */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarBtnDel;
/** 工具栏更多barBtnItem */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarBtnMore;

/** 消息的属性 */
@property (strong, nonatomic) ChatMessageAttribute *messageAttribute;
/** 输入框的高度 */
@property (assign, nonatomic) CGFloat inputTextViewHeight;
/** 键盘的高度 */
@property (assign, nonatomic) CGFloat kbHeight;
/** 表情视图的高度 */
@property (assign, nonatomic) CGFloat emotionViewHeiht;
/** 长按时的cell */
@property (strong, nonatomic) ChatMsgCell *longPressGestureCell;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chatDataSource.delegate = self;
    self.inputTextViewHeight = ChatViewTopInputViewDefaultHeight;
    self.emotionViewHeiht = NSNotFound;
    self.longPressGestureCell = nil;
    
    //导航栏bar button item
    [self.barBtnInfo setImage:[UIImage imageNamed:([ChatManager sharedManager].chatTargetType == ChatTargetTypeP2G) ?
                               @"NAVI_BTN_GROUPINFO" : @"NAVI_BTN_ROLEINFO"]];
    self.navigationItem.leftBarButtonItem = self.barBtnBack;
    self.navigationItem.rightBarButtonItem = self.barBtnInfo;
    [self.navigationController setToolbarHidden:YES];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.longPressGestureCell = nil;
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

/** 返回 barButtonItem响应 */
- (IBAction)barBtnBackSelector:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 信息 barButtonItem响应 */
- (IBAction)barBtnInfoSelector:(UIBarButtonItem *)sender {
}

/** 取消 barButtonItem响应 */
- (IBAction)barBtnCancelSelector:(UIBarButtonItem *)sender {
    self.chatDataSource.multiChoiceCellIndexPath = nil;
    self.chatDataSource.isMultiChoiceMode = NO;
    self.navigationItem.leftBarButtonItems = @[self.barBtnBack];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    [UIView animateWithDuration:chatAnimateDuration animations:^{
        self.viewBottomConstraintHeight.constant = self.inputTextViewHeight;
    }];
    
    [self.chatTableView reloadData];
}

#pragma mark - 工具栏

- (IBAction)toolBarBtnTranspondSelector:(UIBarButtonItem *)sender {
    [HYZAlert showInfo:@"我是转发，走开，都别理我" underTitle:@"少年郎"];
}

- (IBAction)toolBarBtnCollectSelector:(UIBarButtonItem *)sender {
    [HYZAlert showInfo:@"我是收藏，走开，都别理我" underTitle:@"少年郎"];
}

- (IBAction)toolBarBtnDelSelector:(UIBarButtonItem *)sender {
    if (nil == self.chatDataSource.multiChoiceCellIndexPath || self.chatDataSource.multiChoiceCellIndexPath.count <= 0)
        return;
    NSArray *indexPaths = [self.chatDataSource.multiChoiceCellIndexPath copy];
    self.chatDataSource.multiChoiceCellIndexPath = nil;
    [self deleteChatMsgCell:indexPaths];
}

- (IBAction)toolBarBtnMoreSelctor:(UIBarButtonItem *)sender {
    [HYZAlert showInfo:@"我是更多，走开，都别理我" underTitle:@"少年郎"];
}

#pragma mark - message notification

/** 注册消息通知 */
- (void)registerMessageNotification {
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (handleKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiInputViewFrameChanage:)
                                                 name:NotiInputViewFrameChanage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiChatBottomFunctionButtonClick:)
                                                 name:NotiChatFunctionBtnClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiUpdateChatViewForSendMsg:)
                                                 name:NotiUpdateChatViewForSendMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiChatBottomPanelShrinkage:)
                                                 name:NotiChatBottomPanelShrinkage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiMsgContentLongPressGesture:)
                                                 name:NotiMsgContentLongPressGesture object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuControllerWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiLogoImageGesture:)
                                                 name:NotiLogoImageGesture object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiMsgContentLongPressGesture object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiLogoImageGesture object:nil];
}

/** 键盘弹出 */
- (void)handleKeyboardWillShow:(NSNotification *)notification {
    [ChatManager sharedManager].bottomMode = ChatBottomTargetText;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiEmotionBtnDefaultStauts object:nil];
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    [UIView animateWithDuration:chatAnimateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.viewBottomConstraintHeight.constant = self.inputTextViewHeight + kbRect.size.height;
        [self.view layoutIfNeeded];
        [self scrollTableViewToBottom];
    } completion:^(BOOL finished) {}];
    
    self.kbHeight = kbRect.size.height;
}

/** 键盘隐藏 */
- (void)handleKeyboardWillHide:(NSNotification *)notification {
    if ([ChatManager sharedManager].bottomMode != ChatBottomTargetEmotion && [ChatManager sharedManager].bottomMode != ChatBottomTargetFunction) {
        [ChatManager sharedManager].bottomMode = ChatBottomTargetFree;
        [UIView animateWithDuration:chatAnimateDuration animations:^{
            self.viewBottomConstraintHeight.constant = self.inputTextViewHeight;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {}];
    }
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
                [self scrollTableViewToBottom];
            } completion:^(BOOL finished) {}];
        }
        else {
            [UIView animateWithDuration:chatAnimateDuration animations:^{
                self.viewBottomConstraintHeight.constant = data.inputViewHeight;
                [self.view layoutIfNeeded];
                [self scrollTableViewToBottom];
            } completion:^(BOOL finished) {
                if ([ChatManager sharedManager].bottomMode == ChatBottomTargetEmotion)
                    self.emotionViewHeiht = data.inputViewHeight - data.inputTextViewHeight;
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
#warning send chat msg request
        [self.chatDataSource addChatMsg:msgType withMsgContent:content];
//        [self.chatTableView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatDataSource.chatMsgArr.count - 1 inSection:0];
        [self.chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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

/** 聊天消息内容长按手势通知 */
- (void)handleNotiMsgContentLongPressGesture:(NSNotification *)notiifcation {
    if (self.chatDataSource.isMultiChoiceMode == YES)
        return;
    if (notiifcation.object != nil) {
        if ([notiifcation.object isKindOfClass:[ChatMsgCell class]])
            [self showCellMenu:notiifcation.object];
    }
}

/** 菜单即将消失通知 */
- (void)handleMenuControllerWillHide:(NSNotification *)notiifcation {
    [ChatManager sharedManager].cellLongPressResponder = nil;
    self.longPressGestureCell = nil;
}

- (void)handleNotiLogoImageGesture:(NSNotification *)notiifcation {
    if (self.chatDataSource.isMultiChoiceMode == YES)
        return;
    
    if (notiifcation.userInfo != nil) {
        NSString *gestureType = [notiifcation.userInfo objectForKey:@"gestureType"];
//        long long uid = [[notiifcation.userInfo objectForKey:@"uid"] longLongValue];
        if ([gestureType isEqualToString:@"tap"]) {
            [HYZAlert showInfo:@"您单击了头像" underTitle:@"提示"];
        }
        else if ([gestureType isEqualToString:@"longPress"]) {
            [HYZAlert showInfo:@"您长按了头像" underTitle:@"提示"];
        }
    }
}

#pragma mark - ChatDataSourceDelegate

- (void)updateToolBarButtonItemState {
    if (self.chatDataSource.isMultiChoiceMode == NO)
        return;
    
    self.toolBarBtnTranspond.enabled = self.toolBarBtnCollect.enabled = self.toolBarBtnDel.enabled = self.toolBarBtnMore.enabled
                                                                            = self.chatDataSource.multiChoiceCellIndexPath.count > 0;
}

#pragma mark - 私有方法

/** 将列表信息滑动到底部 */
- (void)scrollTableViewToBottom {
    if ([self.chatDataSource isEmptyData] == NO)
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatDataSource.chatMsgArr.count - 1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/** 长按显示cell工具菜单 */
- (void)showCellMenu:(ChatMsgCell *)cell {
    NSArray *cellMenuData = [cell configCellMenu];
    if (cellMenuData == nil || cellMenuData.count <= 0)
        return;
    
    self.longPressGestureCell = cell;
    NSMutableArray *menuItems = [NSMutableArray array];
    for (NSDictionary *dictMenu in cellMenuData) {
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:[dictMenu objectForKey:KEY_CHAT_MENU_TITLE]
                                                        action:NSSelectorFromString([dictMenu objectForKey:KEY_CHAT_MENU_SELECTOR])]];
    }
    
    if ([ChatManager sharedManager].bottomMode != ChatBottomTargetText)
        [cell becomeFirstResponder];
    else
        [ChatManager sharedManager].cellLongPressResponder = cell;
    
    CGRect msgContentFrame = [cell convertRect:cell.viewMsgContent.frame toView:self.view];
    [[UIMenuController sharedMenuController] setTargetRect:msgContentFrame inView:self.view];
    [UIMenuController sharedMenuController].menuItems = [menuItems copy];
    [UIMenuController sharedMenuController].menuVisible = YES;
}

/**
 * @description 删除聊天cell
 * @param cellIndexPathArr 要删除聊天cell索引
 */
- (void)deleteChatMsgCell:(NSArray <NSIndexPath *>*)cellIndexPathArr {
    if (nil == cellIndexPathArr || cellIndexPathArr.count <= 0)
        return;
    NSMutableArray *indexPathArr = [NSMutableArray array];
    for (NSIndexPath *indexPath in cellIndexPathArr) {
        if (indexPath.row < self.chatDataSource.chatMsgArr.count) {
            CNChatMessage *cellData = [self.chatDataSource.chatMsgArr objectAtIndex:indexPath.row];
            [self.chatDataSource.chatMsgArr removeObject:cellData];
            [[DataManager sharedManager] deleteFromCoreData:cellData];//本地数据中移除
            [indexPathArr addObject:indexPath];
        }
    }
    [self.chatTableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
    [[DataManager sharedManager] saveContext];//保存数据
    [self updateToolBarButtonItemState];
}

#pragma mark - chat cell 点击后的菜单

/**  可以响应的方法 */
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(cellDelSelector) || action == @selector(cellResendSelector) ||
        action == @selector(cellCopySelector) || action == @selector(cellCollectSelector) ||
        action == @selector(cellTranspondSelector) || action == @selector(cellMultiChoiceSelector)) {
        [UIMenuController sharedMenuController].menuItems = nil;
        return YES;
    }
    return NO;
}

/** 删除菜单item响应选择器 */
- (void)cellDelSelector {
    if (self.longPressGestureCell == nil || [self.chatDataSource isEmptyData] == YES)
        return;
    
    [self deleteChatMsgCell:@[[self.chatTableView indexPathForCell:self.longPressGestureCell]]];
}

/** 重新发送菜单item响应选择器 */
- (void)cellResendSelector {}

/** 复制菜单item响应选择器 */
- (void)cellCopySelector {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.longPressGestureCell == nil ? @"" : self.longPressGestureCell.cellData.msg_content;
}

/** 收藏菜单item响应选择器 */
- (void)cellCollectSelector {
}

/** 转发菜单item响应选择器 */
- (void)cellTranspondSelector {
}

/** 多选item响应选择器 */
- (void)cellMultiChoiceSelector {
    self.chatDataSource.multiChoiceCellIndexPath = nil;
    if (self.longPressGestureCell != nil)
        [self.chatDataSource.multiChoiceCellIndexPath addObject:[self.chatTableView indexPathForCell:self.longPressGestureCell]];

    self.navigationItem.leftBarButtonItem = self.barBtnCancel;
    self.chatDataSource.isMultiChoiceMode = YES;
    [self updateToolBarButtonItemState];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    [UIView animateWithDuration:chatAnimateDuration animations:^{
        self.viewBottomConstraintHeight.constant = 0.0f;
    }];
    
    [self.chatTableView reloadData];
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
