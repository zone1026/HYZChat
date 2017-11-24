//
//  ChatDataSource+TableView.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatDataSource.h"

@interface ChatDataSource (TableView)

/**
 * @description 创建消息单元格
 * @param tableView 列表视图
 * @param indexPath 单元格索引
 */
- (UITableViewCell *)proxyForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 * @description 计算消息单元格的高度
 * @param tableView 列表视图
 * @param indexPath 单元格索引
 */
- (CGFloat)proxyForTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
