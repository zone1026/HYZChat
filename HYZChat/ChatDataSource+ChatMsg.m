//
//  ChatDataSource+ChatMsg.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/11.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatDataSource+ChatMsg.h"

@implementation ChatDataSource (ChatMsg)

- (void)addChatMsg:(ChatMsgType)type withMsgContent:(NSString *)content {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    CNChatMessage *chatMessage = (CNChatMessage *)[[DataManager sharedManager] insertIntoCoreData:@"CNChatMessage"];
    chatMessage.msg_id = 0;
    chatMessage.msg_type = type;
    chatMessage.msg_state = ChatMsgStateNoSend;
    chatMessage.send_userId = currentUser.user_id;
    chatMessage.send_nick = currentUser.user_name;
    chatMessage.send_time = [NSString stringWithFormat:@"%.2f", [HYZUtil getCurrentTimestamp]];
    chatMessage.target_id = 0;
    chatMessage.target_type = [ChatManager sharedManager].chatTargetType;
    chatMessage.belong_user = currentUser;
    
    if (type == ChatMsgTypeText) {
        chatMessage.msg_content = content;
        chatMessage.assign_res = nil;
    }
    else if (type == ChatMsgTypeImage) {
        
    }
    else if (type == ChatMsgTypeAudio) {
        
    }
    else if (type == ChatMsgTypeVideo) {
        
    }
    
    [self.chatMsgArr addObject:chatMessage];//添加到消息列表中
    [[DataManager sharedManager] saveContext];
}

@end
