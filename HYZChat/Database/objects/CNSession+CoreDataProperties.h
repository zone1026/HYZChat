//
//  CNSession+CoreDataProperties.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import "CNSession+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNSession (CoreDataProperties)

+ (NSFetchRequest<CNSession *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *last_time;
@property (nullable, nonatomic, copy) NSString *session_id;
@property (nullable, nonatomic, copy) NSString *session_logo;
@property (nullable, nonatomic, copy) NSString *session_name;
@property (nonatomic) BOOL session_shield;
@property (nonatomic) int64_t unread_Num;
@property (nullable, nonatomic, retain) CNUser *belong_user;
@property (nullable, nonatomic, retain) NSSet<CNChatMessage *> *has_chatMsgs;

@end

@interface CNSession (CoreDataGeneratedAccessors)

- (void)addHas_chatMsgsObject:(CNChatMessage *)value;
- (void)removeHas_chatMsgsObject:(CNChatMessage *)value;
- (void)addHas_chatMsgs:(NSSet<CNChatMessage *> *)values;
- (void)removeHas_chatMsgs:(NSSet<CNChatMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
