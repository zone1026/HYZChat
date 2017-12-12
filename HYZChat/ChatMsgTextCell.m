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

@property (weak, nonatomic) IBOutlet UIView *viewMsgBg;
@property (weak, nonatomic) IBOutlet RichLabel *lblMsg;

@end

@implementation ChatMsgTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewMsgBg.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 消息

- (void)updateMessageData:(CNChatMessage *)msgData {
    [super updateMessageData:msgData];
    [self updateTextCellUI];
}

- (void)updateMessageData:(CNChatMessage *)msgData withMeMsg:(BOOL)isMe {
    [super updateMessageData:msgData withMeMsg:isMe];
    [self updateTextCellUI];
}

#pragma mark - 私有方法
/** 更新textcell相关的UI */
- (void)updateTextCellUI {
    [self.lblMsg updateTextContent:self.cellData.msg_content];
}

@end
