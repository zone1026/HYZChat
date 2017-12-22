//
//  ChatMsgCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/23.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatMsgCell.h"

@interface ChatMsgCell ()
/** 头像点击手势 */
@property (strong, nonatomic) UITapGestureRecognizer *imgLogoTapGesture;
/** 头像点击手势 */
@property (strong, nonatomic) UILongPressGestureRecognizer *imgLogoLongPressGesture;
/** 消息内容点击手势 */
@property (strong, nonatomic) UILongPressGestureRecognizer *viewMsgContentLongPressGesture;

@end

@implementation ChatMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (self.imgLogo != nil) {
        self.imgLogoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgLogoTapGestureSelector:)];
        self.imgLogoTapGesture.cancelsTouchesInView = NO;
        self.imgLogoTapGesture.numberOfTapsRequired = 1;//点击次数，默认1
        self.imgLogoTapGesture.numberOfTouchesRequired = 1;//触点个数，默认1
        [self.imgLogo addGestureRecognizer:self.imgLogoTapGesture];
        
        self.imgLogoLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imgLogoLongPressGestureSelector:)];
        self.imgLogoLongPressGesture.cancelsTouchesInView = NO;
        self.imgLogoLongPressGesture.minimumPressDuration = 0.5f;//设置长按时间，默认0.5秒
        [self.imgLogo addGestureRecognizer:self.imgLogoLongPressGesture];
    }
    if (self.viewMsgContent != nil) {
        self.viewMsgContentLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewMsgContentLongPressGestureSelector:)];
        self.viewMsgContentLongPressGesture.cancelsTouchesInView = NO;
        self.viewMsgContentLongPressGesture.minimumPressDuration = 0.5f;//设置长按时间，默认0.5秒
        [self.viewMsgContent addGestureRecognizer:self.viewMsgContentLongPressGesture];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsMeSend:(BOOL)isMeSend {
    _isMeSend = isMeSend;
}

- (void)setCheckMode:(BOOL)checkMode {
    _checkMode = checkMode;
    if (self.imgCheck != nil)
        self.imgCheck.image = [UIImage imageNamed:checkMode == YES ? @"CHAT_BTN_CHECK" : @"CHAT_BTN_UNCHECK"];
}

#pragma mark - 共有方法

- (void)updateMessageData:(CNChatMessage *)msgData {
    [self updateMessageData:msgData withMeMsg:[msgData checkOneselfSendMsg]];
}

- (void)updateMessageData:(CNChatMessage *)msgData withMeMsg:(BOOL)isMe {
    self.cellData = msgData;
    self.isMeSend = isMe;
    if (self.imgLogo != nil)
        self.imgLogo.image = [UIImage imageNamed:@"DEFAULT_LOGO"];
    if (self.lblNick != nil)
        self.lblNick.text = [HYZUtil isEmptyOrNull:self.cellData.send_nick] == YES ? @"未知" : self.cellData.send_nick;
    if (self.lblNickConstraintHeight != nil)
        self.lblNickConstraintHeight.constant =  [msgData checkShowNickName] == NO ? 0.01f : ChatNickNameDefaultHeight;
    if (self.imgLogoConstraintLeft != nil)
        self.imgLogoConstraintLeft.constant = (self.multiChoiceMode == YES && [msgData checkMsgNeedUserLogo] == YES) ? 4.0f + 26.0f + 4.0f : 8.0f;
    if (self.viewMsgContentConstraintRight != nil)
        self.viewMsgContentConstraintRight.constant = self.multiChoiceMode == YES ? 65.0f - (4.0f + 26.0f + 4.0f - 8.0f): 65.0f;
    if (self.imgCheck != nil)
        self.imgCheck.hidden = !self.multiChoiceMode;
}

- (NSArray *)configCellMenu {
    return @[@{KEY_CHAT_MENU_TITLE:TITLE_CHAT_MENU_ITEM_TRANSPOND, KEY_CHAT_MENU_SELECTOR:SELECTOR_CHAT_MENU_ITEM_TRANSPOND},
             @{KEY_CHAT_MENU_TITLE:TITLE_CHAT_MENU_ITEM_DEL, KEY_CHAT_MENU_SELECTOR:SELECTOR_CHAT_MENU_ITEM_DEL},
             @{KEY_CHAT_MENU_TITLE:TITLE_CHAT_MENU_ITEM_MULTICHOICE, KEY_CHAT_MENU_SELECTOR:SELECTOR_CHAT_MENU_ITEM_MULTICHOICE}];
}

#pragma mark - 事件

/** 头像的点击手势响应方法 */
- (void)imgLogoTapGestureSelector:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiLogoImageGesture object:nil
                                                          userInfo:@{@"gestureType":@"tap", @"uid":@(self.cellData.send_userId)}];
//        [HYZAlert showInfo:self.description underTitle:@"您单击了头像"];
}

/** 头像的按钮手势响应方法 */
- (void)imgLogoLongPressGestureSelector:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan)
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiLogoImageGesture object:nil
                                                          userInfo:@{@"gestureType":@"longPress", @"uid":@(self.cellData.send_userId)}];
//        [HYZAlert showInfo:self.description underTitle:@"您长按了头像"];
}

/** 消息内容的长按手势响应方法 */
- (void)viewMsgContentLongPressGestureSelector:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan && self.cellData != nil && self.cellData.msg_type != ChatMsgTypeText)//文本消息由自己的长按事件
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiMsgContentLongPressGesture object:self];
}

#pragma mark - 私有方法

- (NSString *)description {
    if (self.cellData == nil)
        return @"描述：cell数据源为空";
    
    return [NSString stringWithFormat:@"描述>>>\"消息发送方:%@，消息类型:%d，消息目标类型:%d \"",self.cellData.send_nick, self.cellData.msg_type,
            self.cellData.target_type];
}

@end
