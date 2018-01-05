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
/** 消息内容双击手势 */
@property (strong, nonatomic) UITapGestureRecognizer *viewMsgContentDoubleTapGesture;

@end

@implementation ChatMsgTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewMsgBg.layer.cornerRadius = 5.0f;
    if (self.viewMsgContent != nil) {
        self.viewMsgContentDoubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMsgContentDoubleTapGestureSelector:)];
        self.viewMsgContentDoubleTapGesture.cancelsTouchesInView = YES;
        self.viewMsgContentDoubleTapGesture.numberOfTapsRequired = 2;//双击
        self.viewMsgContentDoubleTapGesture.numberOfTouchesRequired = 1;//触点个数，默认1
        [self.viewMsgContent addGestureRecognizer:self.viewMsgContentDoubleTapGesture];
    }
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

#pragma mark - 共有方法

- (void)cancelContentSelected {
    if (self.lblMsg != nil)
        self.lblMsg.selectedRange = NSMakeRange(0, 0);
}

#pragma mark - 私有方法
/** 更新textcell相关的UI */
- (void)updateTextCellUI {
    [self.lblMsg updateTextContent:self.cellData.msg_content];
    self.lblMsg.linkLongHandler = ^(LinkType linkType, NSString *string, NSRange range, CGPoint touchPoint) {
        if (self.cellData != nil)
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiMsgContentLongPressGesture object:self];
    };
    self.lblMsg.linkTapHandler = ^(LinkType linkType, NSString *string, NSRange range) {
        if (LinkTypeURL == linkType) {
            [HYZAlert showInfo:@"哈哈，URL跳转。我没做，没做，做" underTitle:@"少年郎"];
        } else if (LinkTypePhoneNumber == linkType) {
            CNAlertView *alertView = [[CNAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@可能是一个电话号码，你可以",string]
                                preferredStyle:UIAlertControllerStyleActionSheet delegate:nil tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                                    if (buttonIndex == alertView.firstOtherButtonIndex) {//呼叫
                                        NSString *telString = [NSString stringWithFormat:@"tel://%@",string];
                                        return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString] options:@{} completionHandler:nil];
                                    }
                                    else if (buttonIndex == (alertView.firstOtherButtonIndex + 1)) {//复制
                                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                        pasteboard.string = string;
                                    }
                                    else if (buttonIndex == (alertView.firstOtherButtonIndex + 2)) {//添加到手机通讯录
                                        [HYZAlert showInfo:@"哈哈，添加到手机通讯录。我没做，没做，做" underTitle:@"少年郎"];
                                    }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", @"复制", @"添加到手机通讯录", nil];
            
            UIAlertController *alertController = alertView.alertController;
            alertController.modalPresentationStyle = UIModalPresentationPopover;
            alertController.preferredContentSize = CGSizeMake(200, 350);
            UIPopoverPresentationController *popover = alertController.popoverPresentationController;
            if (popover != nil) {
                popover.sourceView = self;
                popover.sourceRect = popover.sourceView.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
            [[HYZUtil getCurrentWindowViewController] presentViewController:alertController animated:YES completion:nil];
        }
    };
}

#pragma mark - 事件

/** 消息内容的双击手势响应方法 */
- (void)viewMsgContentDoubleTapGestureSelector:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && self.cellData != nil)
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiChatMsgContentDoubleTap object:self.cellData.msg_content];
}

@end
