//
//  CNSession+CoreDataProperties.h
//  
//
//  Created by 黄亚州 on 2018/2/24.
//
//

#import "CNSession+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNSession (CoreDataProperties)

+ (NSFetchRequest<CNSession *> *)fetchRequest;

@property (nonatomic) int64_t last_time;
@property (nullable, nonatomic, copy) NSString *logo_src;
@property (nullable, nonatomic, copy) NSString *logo_thumb;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t session_id;
@property (nonatomic) BOOL shield;
@property (nonatomic) int16_t type;
@property (nonatomic) int64_t unread_Num;
@property (nonatomic) int64_t target_id;
@property (nonatomic) int16_t target_type;
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
