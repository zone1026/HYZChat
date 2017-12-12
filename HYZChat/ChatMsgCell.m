//
//  ChatMsgCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/23.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatMsgCell.h"

@interface ChatMsgCell ()

@end

@implementation ChatMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

#pragma mark - 私有方法

@end
