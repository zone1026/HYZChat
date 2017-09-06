//
//  CNChatMessage+CoreDataProperties.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "CNChatMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNChatMessage (CoreDataProperties)

+ (NSFetchRequest<CNChatMessage *> *)fetchRequest;

@property (nonatomic) int64_t msg_id;
@property (nullable, nonatomic, copy) NSString *msg_content;
@property (nonatomic) int16_t msg_type;
@property (nullable, nonatomic, copy) NSString *send_time;
@property (nonatomic) int64_t send_userId;
@property (nonatomic) int64_t target_id;
@property (nonatomic) int16_t msg_state;
@property (nullable, nonatomic, retain) CNUser *belong_user;
@property (nullable, nonatomic, retain) CNChatResource *assign_res;

@end

NS_ASSUME_NONNULL_END
