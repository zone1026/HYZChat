//
//  CNSession+CoreDataClass.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CNChatMessage, CNUser;

NS_ASSUME_NONNULL_BEGIN

@interface CNSession : NSManagedObject
/**
 * @description 获取会话中的消息列表数据
 */
- (NSArray *)obtainSubChatMessageSequenceData;
/**
 * @description 通过会话的类型获取回话名字的颜色
 */
- (UIColor *)sessionNameColorByType;
/**
 * @description 会话的最近一条聊天信息内容
 */
- (NSString *)sessionLastChatMsgContent;
/**
 * @description 会话的最近一条聊天信息内容
 */
- (NSString *)sessionUnreadMsgNumDesc;

@end

NS_ASSUME_NONNULL_END

#import "CNSession+CoreDataProperties.h"
