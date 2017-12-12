//
//  ChatDataSource+TableView.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatDataSource+TableView.h"
#import "ChatMsgTextCell.h"
#import "NSAttributedString+TextAttachment.h"

@implementation ChatDataSource (TableView)

- (UITableViewCell *)proxyForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNChatMessage *chatMsg = [self.chatMsgArr objectAtIndex:indexPath.row];
    ChatTableCellInfo *info = [self.chatCellInfoDict objectForKey:@(chatMsg.msg_type)];
    if (info == nil || [chatMsg checkMsgTypeCanSupport] == NO)//没有拿到cell所用的配置信息
        return [tableView dequeueReusableCellWithIdentifier:@"herTextCell"];
    NSString *identifierStr = [NSString stringWithFormat:@"%@%@Cell", (chatMsg.send_userId != [DataManager sharedManager].currentUser.user_id ? @"her": @"me"),
                               info.indentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr forIndexPath:indexPath];
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
            NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f], NSFontAttributeName, nil];
            //设置换行模式，表情图标出界自动换行
            [attributes setValuesForKeysWithDictionary:[HYZUtil getWrapModeAttributes]];
            //设置行间距
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 3.0;
            [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
            
            BOOL isMe = chatMsg.send_userId == [DataManager sharedManager].currentUser.user_id;
            CGRect attributeRect = [NSAttributedString boundsForString:chatMsg.msg_content
                                        size:CGSizeMake((kScreenWidth - (isMe == YES ? 63.0f : 65.0f) - (60.0f + 8.0f)), CGFLOAT_MAX) attributes:attributes];
            CGFloat textHeight = attributeRect.size.height + 3.0f;
            
            //文本内容距离cell顶部(包含昵称label的高度)32.0f；距离cell底部20.0f；
            return 32.0f - ([chatMsg checkShowNickName] == YES ? 0.0f: ChatNickNameDefaultHeight) + textHeight + 20.0f;
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
