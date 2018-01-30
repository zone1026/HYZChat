//
//  CNSession+CoreDataClass.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import "CNSession+CoreDataClass.h"

@implementation CNSession

- (NSArray *)obtainSubChatMessageSequenceData {
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"send_time" ascending:NO]];//send_time是unix时间戳
    return [self.has_chatMsgs sortedArrayUsingDescriptors:sortDesc];
}

- (UIColor *)sessionNameColorByType {
    UIColor *color = nil;
    switch (self.type) {
        case SessionTypeOrganization:
        case SessionTypeOfficial:
            color = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
            break;
        
        case SessionTypeFriend:
        case SessionTypeGroup:
        case SessionTypeSystem:
        default:
            color = [UIColor blackColor];
            break;
    }
    return color;
}

- (NSString *)sessionMsgUiContent {
    if (nil == self.has_chatMsgs || self.has_chatMsgs.count <= 0)
        return @"";
    
    NSString *msgUiContent;
    NSArray *chatMsgArr = [self obtainSubChatMessageSequenceData];
    CNChatMessage *chatMessage = [chatMsgArr firstObject];
    switch (chatMessage.msg_type) {
        case ChatMsgTypeText:
            msgUiContent = chatMessage.msg_content;
            break;
         case ChatMsgTypeImage:
            msgUiContent = @"【图片】";
            break;
        case ChatMsgTypeAudio:
            msgUiContent = @"【语音】";
            break;
        case ChatMsgTypeVideo:
            msgUiContent = @"【小视频】";
            break;
        default:
            msgUiContent = @"类型未知";
            break;
    }
    return msgUiContent;
}

- (NSString *)sessionUnreadMsgNumDesc {
    if (self.unread_Num <= 0)
        return @"";
    
    if (self.unread_Num > 99)
        return @" 99+ ";
    
    return [NSString stringWithFormat:@"%lld", self.unread_Num];
}

- (ChatTargetType)chatTargetTypeBySessionType {
    ChatTargetType type = ChatTargetTypeP2P;
    switch (self.type) {
        case SessionTypeOrganization:
        case SessionTypeOfficial:
        case SessionTypeSystem:
            type = ChatTargetTypeSubscription;
            break;
        case SessionTypeGroup:
            type = ChatTargetTypeP2G;
            break;
        default:
            break;
    }
    return type;
}

@end
