//
//  CNUser+CoreDataProperties.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "CNUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNUser (CoreDataProperties)

+ (NSFetchRequest<CNUser *> *)fetchRequest;

@property (nonatomic) int64_t user_id;
@property (nullable, nonatomic, copy) NSString *user_name;
@property (nullable, nonatomic, copy) NSString *user_phone;
@property (nonatomic) int16_t user_sex;
@property (nonatomic) int16_t user_identity;
@property (nullable, nonatomic, retain) NSSet<CNChatMessage *> *has_chatMessage;

@end

@interface CNUser (CoreDataGeneratedAccessors)

- (void)addHas_chatMessageObject:(CNChatMessage *)value;
- (void)removeHas_chatMessageObject:(CNChatMessage *)value;
- (void)addHas_chatMessage:(NSSet<CNChatMessage *> *)values;
- (void)removeHas_chatMessage:(NSSet<CNChatMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
