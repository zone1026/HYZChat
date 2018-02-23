//
//  CNUser+CoreDataProperties.h
//  
//
//  Created by 黄亚州 on 2018/2/23.
//
//

#import "CNUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNUser (CoreDataProperties)

+ (NSFetchRequest<CNUser *> *)fetchRequest;

@property (nonatomic) BOOL is_login;
@property (nonatomic) double last_time;
@property (nonatomic) int64_t user_id;
@property (nullable, nonatomic, copy) NSString *user_name;
@property (nullable, nonatomic, copy) NSString *user_password;
@property (nullable, nonatomic, copy) NSString *user_phone;
@property (nullable, nonatomic, retain) NSSet<CNFriend *> *has_friends;
@property (nullable, nonatomic, retain) NSSet<CNGroup *> *has_groups;
@property (nullable, nonatomic, retain) NSSet<CNSession *> *has_sessions;
@property (nullable, nonatomic, retain) CNUserInfo *assign_userInfo;

@end

@interface CNUser (CoreDataGeneratedAccessors)

- (void)addHas_friendsObject:(CNFriend *)value;
- (void)removeHas_friendsObject:(CNFriend *)value;
- (void)addHas_friends:(NSSet<CNFriend *> *)values;
- (void)removeHas_friends:(NSSet<CNFriend *> *)values;

- (void)addHas_groupsObject:(CNGroup *)value;
- (void)removeHas_groupsObject:(CNGroup *)value;
- (void)addHas_groups:(NSSet<CNGroup *> *)values;
- (void)removeHas_groups:(NSSet<CNGroup *> *)values;

- (void)addHas_sessionsObject:(CNSession *)value;
- (void)removeHas_sessionsObject:(CNSession *)value;
- (void)addHas_sessions:(NSSet<CNSession *> *)values;
- (void)removeHas_sessions:(NSSet<CNSession *> *)values;

@end

NS_ASSUME_NONNULL_END
