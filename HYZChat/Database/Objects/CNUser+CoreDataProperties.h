//
//  CNUser+CoreDataProperties.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import "CNUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNUser (CoreDataProperties)

+ (NSFetchRequest<CNUser *> *)fetchRequest;

@property (nonatomic) BOOL is_login;
@property (nonatomic) double last_time;
@property (nonatomic) int64_t user_id;
@property (nonatomic) int16_t user_identity;
@property (nullable, nonatomic, copy) NSString *user_name;
@property (nullable, nonatomic, copy) NSString *user_password;
@property (nullable, nonatomic, copy) NSString *user_phone;
@property (nonatomic) int16_t user_sex;
@property (nullable, nonatomic, retain) NSSet<CNSession *> *has_sessions;

@end

@interface CNUser (CoreDataGeneratedAccessors)

- (void)addHas_sessionsObject:(CNSession *)value;
- (void)removeHas_sessionsObject:(CNSession *)value;
- (void)addHas_sessions:(NSSet<CNSession *> *)values;
- (void)removeHas_sessions:(NSSet<CNSession *> *)values;

@end

NS_ASSUME_NONNULL_END
