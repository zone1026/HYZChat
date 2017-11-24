//
//  CNChatMessage+CoreDataClass.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CNChatResource, CNUser;

NS_ASSUME_NONNULL_BEGIN

@interface CNChatMessage : NSManagedObject

/**
 * @description 检测消息类型目前是否支持
 */
- (BOOL)checkMsgTypeCanSupport;

@end

NS_ASSUME_NONNULL_END

#import "CNChatMessage+CoreDataProperties.h"
