//
//  CNUser+CoreDataClass.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CNChatMessage;

NS_ASSUME_NONNULL_BEGIN

@interface CNUser : NSManagedObject

/**
 * @description 获取用户的聊天信息
 */
- (NSArray *)getSubChatMessageSequence;

@end

NS_ASSUME_NONNULL_END

#import "CNUser+CoreDataProperties.h"
