//
//  ChatMsgTextCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/23.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatMsgTextCell.h"
#import "RichLabel.h"

@interface ChatMsgTextCell ()

@property (weak, nonatomic) IBOutlet RichLabel *lblMsg;

@end

@implementation ChatMsgTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 消息

- (void)updateMessageData:(CNChatMessage *)msgData withMeMsg:(BOOL)isMe {
    [super updateMessageData:msgData withMeMsg:isMe];
    self.lblMsg.text = @"暂未消息";
}

@end
