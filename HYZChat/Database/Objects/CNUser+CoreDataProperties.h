//
//  CNUser+CoreDataProperties.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/25.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import "CNUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNUser (CoreDataProperties)

+ (NSFetchRequest<CNUser *> *)fetchRequest;

@property (nonatomic) double last_time;
@property (nonatomic) int64_t user_id;
@property (nonatomic) int16_t user_identity;
@property (nullable, nonatomic, copy) NSString *user_name;
@property (nullable, nonatomic, copy) NSString *user_password;
@property (nullable, nonatomic, copy) NSString *user_phone;
@property (nonatomic) int16_t user_sex;
@property (nonatomic) BOOL is_login;
@property (nullable, nonatomic, retain) NSSet<CNChatMessage *> *has_chatMessages;

@end

@interface CNUser (CoreDataGeneratedAccessors)

- (void)addHas_chatMessagesObject:(CNChatMessage *)value;
- (void)removeHas_chatMessagesObject:(CNChatMessage *)value;
- (void)addHas_chatMessages:(NSSet<CNChatMessage *> *)values;
- (void)removeHas_chatMessages:(NSSet<CNChatMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
