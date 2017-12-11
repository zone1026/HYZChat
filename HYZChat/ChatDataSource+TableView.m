//
//  ChatDataSource+TableView.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatDataSource+TableView.h"
#import "ChatMsgTextCell.h"

@implementation ChatDataSource (TableView)

- (UITableViewCell *)proxyForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNChatMessage *chatMsg = [self.chatMsgArr objectAtIndex:indexPath.row];
    ChatTableCellInfo *info = [self.chatCellInfoDict objectForKey:@(chatMsg.msg_type)];
    if (info == nil || [chatMsg checkMsgTypeCanSupport] == NO)//没有拿到cell所用的配置信息
        return [tableView dequeueReusableCellWithIdentifier:@"text"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:info.indentifier forIndexPath:indexPath];
    [self updateTableCellUI:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)proxyForTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNChatMessage *chatMsg = [self.chatMsgArr objectAtIndex:indexPath.row];
    return [self calculateTableCellHeightByChatMsgData:chatMsg];
}

#pragma mark - 私有方法
/**
 * @description 通过聊天数据更新单元格UI
 * @param cell 单元格
 * @param indexPath 单元格的索引
 */
- (void)updateTableCellUI:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNChatMessage *chatMsg = [self.chatMsgArr objectAtIndex:indexPath.row];
    switch (chatMsg.msg_type) {
        case ChatMsgTypeText:
        {
            ChatMsgTextCell *textCell = (ChatMsgTextCell *)cell;
            [textCell updateMessageData:chatMsg];
        }
            break;
        case ChatMsgTypeImage:
            
            break;
        case ChatMsgTypeAudio:
            
            break;
        case ChatMsgTypeVideo:
            
            break;
        default:
            break;
    }
}

/**
 * @description 通过聊天数据计算cell高度
 * @param chatMsg 聊天消息数据
 */
- (CGFloat)calculateTableCellHeightByChatMsgData:(CNChatMessage *)chatMsg {
    if (chatMsg == nil || [chatMsg checkMsgTypeCanSupport] == NO)
        return 0.01f;
    
    switch (chatMsg.msg_type) {
        case ChatMsgTypeText:
        {
            CGFloat textHeight = [HYZUtil autoFitSizeOfStr:chatMsg.msg_content withWidth:(kScreenWidth - 70.0f - 70.0f)
                                                  withFont:[UIFont systemFontOfSize:15.0f]].height;
            return 23.0f + textHeight + 23.0f;
        }
            break;
        case ChatMsgTypeImage:
            
            break;
        case ChatMsgTypeAudio:
            
            break;
        case ChatMsgTypeVideo:
            
            break;
        default:
            break;
    }
    
    return 0.01f;
}

@end
