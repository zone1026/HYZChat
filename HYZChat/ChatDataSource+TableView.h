//
//  ChatDataSource+TableView.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatDataSource.h"

@interface ChatDataSource (TableView)

- (UITableViewCell *)proxyForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
