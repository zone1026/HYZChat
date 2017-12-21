//
//  ChatDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperDataSource.h"
#import "CNChatMessage+CoreDataClass.h"
#import "ChatTableCellInfo.h"
#import "RichLabel.h"

@interface ChatDataSource : SuperDataSource <UITableViewDelegate, UITableViewDataSource>

/** 消息存放数组 */
@property (strong, nonatomic) NSMutableArray *chatMsgArr;
/** 消息所用Cell信息集合 */
@property (strong, nonatomic) NSMutableDictionary *chatCellInfoDict;
/** 用于计算富文本高度的临时label */
@property (strong, nonatomic) RichLabel *richLabel;
/** cell高度的缓存集合 */
@property (strong, nonatomic) NSMutableDictionary *cellHeightDict;
/** 是否处于多选模式 */
@property (assign, nonatomic) BOOL isMultiChoiceMode;
/** 多选cell IndexPath 存放数组 */
@property (strong, nonatomic) NSMutableArray <NSIndexPath *>*multiChoiceCellIndexPath;

@end
