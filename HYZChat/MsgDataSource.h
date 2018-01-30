//
//  MsgDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperDataSource.h"
#import "CNSession+CoreDataClass.h"

@protocol MsgDataSourceDelegate <NSObject>

@optional
/**
 * @description 点击会话cell跳转聊天界面
 */
- (void)didSelectCellEnterChatUI:(CNSession *)session;

@end

@interface MsgDataSource : SuperDataSource <UITableViewDelegate, UITableViewDataSource>
/** 会话的代理 */
@property (weak, nonatomic) id <MsgDataSourceDelegate> delegate;
/** 会话列表的数据 */
@property (strong, nonatomic) NSMutableArray <CNSession *>*sessionArr;

@end
