//
//  ChatDataSource+ChatMsg.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/11.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatDataSource.h"

@interface ChatDataSource (ChatMsg)

/**
 * @description 添加聊天消息数据
 * @param type 消息类型
 * @param content 消息类型
 */
- (void)addChatMsg:(ChatMsgType)type withMsgContent:(NSString *)content;

@end
