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

- (void)prepareForReuse {
    [super prepareForReuse];
    self.lblMsg.linkLongHandler = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSArray *)configCellMenu {
    return @[@{KEY_CHAT_MENU_TITLE:TITLE_CHAT_MENU_ITEM_COPY, KEY_CHAT_MENU_SELECTOR:SELECTOR_CHAT_MENU_ITEM_COPY},
             @{KEY_CHAT_MENU_TITLE:TITLE_CHAT_MENU_ITEM_TRANSPOND, KEY_CHAT_MENU_SELECTOR:SELECTOR_CHAT_MENU_ITEM_TRANSPOND},
             @{KEY_CHAT_MENU_TITLE:TITLE_CHAT_MENU_ITEM_COLLECT, KEY_CHAT_MENU_SELECTOR:SELECTOR_CHAT_MENU_ITEM_COLLECT},
             @{KEY_CHAT_MENU_TITLE:TITLE_CHAT_MENU_ITEM_DEL, KEY_CHAT_MENU_SELECTOR:SELECTOR_CHAT_MENU_ITEM_DEL},
             @{KEY_CHAT_MENU_TITLE:TITLE_CHAT_MENU_ITEM_MULTICHOICE, KEY_CHAT_MENU_SELECTOR:SELECTOR_CHAT_MENU_ITEM_MULTICHOICE}];
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
    self.lblMsg.linkLongHandler = ^(LinkType linkType, NSString *string, NSRange range, CGPoint touchPoint) {
        NSString *title;
        NSString *openTypeString;
        if (LinkTypeURL == linkType) {
            title = string;
            openTypeString = @"在Safari中打开";
        } else if (LinkTypePhoneNumber == linkType) {
            title = [NSString stringWithFormat:@"%@可能是一个电话号码，你可以",string];
            openTypeString = @"呼叫";
        }
        else if (LinkTypeNormal == linkType) {//复制文本
            if (self.cellData != nil)
                [[NSNotificationCenter defaultCenter] postNotificationName:NotiMsgContentLongPressGesture object:self];
            return;
        }
        else
            return;
    };
    self.lblMsg.linkTapHandler = ^(LinkType linkType, NSString *string, NSRange range) {
        
    };
}

@end
