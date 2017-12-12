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

@end

@implementation ChatMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsMeSend:(BOOL)isMeSend {
    _isMeSend = isMeSend;
}

#pragma mark - 共有方法
- (void)updateMessageData:(CNChatMessage *)msgData {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    [self updateMessageData:msgData withMeMsg:(msgData.send_userId == currentUser.user_id)];
}

- (void)updateMessageData:(CNChatMessage *)msgData withMeMsg:(BOOL)isMe {
    self.cellData = msgData;
    self.isMeSend = isMe;
    self.imgLogo.image = [UIImage imageNamed:@"DEFAULT_LOGO"];
    self.lblNick.text = [HYZUtil isEmptyOrNull:self.cellData.send_nick] == YES ? @"未知" : self.cellData.send_nick;
    self.lblNickConstraintHeight.constant =  [msgData checkShowNickName] == NO ? 0.0f : ChatNickNameDefaultHeight;
}

#pragma mark - 事件

- (void)imgLogoTapGestureSelector:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [HYZAlert showInfo:self.description underTitle:@"您单击了头像"];
    }
}

- (void)imgLogoLongPressGestureSelector:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [HYZAlert showInfo:self.description underTitle:@"您长按了头像"];
    }
}

#pragma mark - 私有方法

- (NSString *)description {
    if (self.cellData == nil)
        return @"描述：cell数据源为空";
    
    return [NSString stringWithFormat:@"描述>>>\"消息发送方:%@，消息类型:%d，消息目标类型:%d \"",self.cellData.send_nick, self.cellData.msg_type,
            self.cellData.target_type];
}

@end
