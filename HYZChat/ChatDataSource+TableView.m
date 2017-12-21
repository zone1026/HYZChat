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
            textCell.multiChoiceMode = self.isMultiChoiceMode;
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
            CGFloat cellHeight = [[self.cellHeightDict objectForKey:chatMsg.send_time] floatValue];
            if (cellHeight == 0.0f) {
                NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f], NSFontAttributeName, nil];
                //设置换行模式，表情图标出界自动换行
                [attributes setValuesForKeysWithDictionary:[HYZUtil getWrapModeAttributes]];
                //设置行间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 3.0;
                //            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
                
                NSAttributedString *attributedString = [NSAttributedString attachmentAttributedStringFrom:chatMsg.msg_content attributes:attributes];
                
                CGFloat textWidth = (kScreenWidth - 65.0f - (65.0f + 8.0f));
//                CGRect attributeRect = [attributedString boundsWithSize:CGSizeMake(textWidth, 0.0f)];//计算不准确 废弃使用
                CGFloat textHeight = 0.0f;//ceilf(attributeRect.size.height) + 3.0f;
                
                if (nil == self.richLabel) {
                    self.richLabel = [[RichLabel alloc] initWithFrame:CGRectZero];
                    self.richLabel.automaticLinkDetectionEnabled = YES;
                    self.richLabel.numberOfLines = 0;
                }
                
                [self.richLabel setFrame:CGRectMake(0.0f, 0.0f, textWidth, textHeight)];
                self.richLabel.attributedText = attributedString;
                [self.richLabel sizeToFit];
                
                textHeight = self.richLabel.frame.size.height + 3.0f;
                
                //文本内容距离cell顶部(包含昵称label的高度)32.0f；距离cell底部20.0f；
                cellHeight = 32.0f - ([chatMsg checkShowNickName] == YES ? 0.0f: ChatNickNameDefaultHeight) + textHeight + 20.0f;
                
                [self.cellHeightDict setObject:@(cellHeight) forKey:chatMsg.send_time];//缓存高度
            }
            return cellHeight;
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
