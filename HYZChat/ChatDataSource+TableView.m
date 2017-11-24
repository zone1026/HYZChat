//
//  ChatDataSource+TableView.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatDataSource+TableView.h"

@implementation ChatDataSource (TableView)

- (UITableViewCell *)proxyForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNChatMessage *chatMsg = [self.chatMsgArr objectAtIndex:indexPath.row];
    UITableViewCell *cell; //= [self createTableCell:chatMsg.msg_type];
    
    return cell;
}

- (CGFloat)proxyForTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0.01;
}

#pragma mark - 私有方法

- (UITableViewCell *)createTableCell:(ChatMsgType)type withTableView:(UITableView *)tableView {
    ChatTableCellInfo *info = [self.chatCellInfoDict objectForKey:@(type)];
    if (info == nil)//没有拿到cell所用的配置信息
        return nil;
//    UITableViewCell *cell = []
    
}

//- (void)
@end
