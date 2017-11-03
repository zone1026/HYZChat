//
//  ChatDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>
/**消息存放数组*/
@property (strong, nonatomic) NSMutableArray *msgArr;

@end
