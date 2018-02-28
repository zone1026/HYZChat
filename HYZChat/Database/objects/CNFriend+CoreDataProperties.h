//
//  CNFriend+CoreDataProperties.h
//  
//
//  Created by 黄亚州 on 2018/2/28.
//
//

#import "CNFriend+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNFriend (CoreDataProperties)

+ (NSFetchRequest<CNFriend *> *)fetchRequest;

@property (nonatomic) int64_t f_addDate;
@property (nonatomic) int64_t f_id;
@property (nonatomic) int16_t f_identity;
@property (nullable, nonatomic, copy) NSString *f_nickName;
@property (nullable, nonatomic, copy) NSString *f_phone;
@property (nonatomic) int16_t f_sex;
@property (nullable, nonatomic, copy) NSString *f_src;
@property (nullable, nonatomic, copy) NSString *f_thumb;
@property (nonatomic) int16_t f_type;
@property (nullable, nonatomic, copy) NSString *f_upperPhoneticize;
@property (nullable, nonatomic, copy) NSString *f_userName;
@property (nullable, nonatomic, copy) NSString *f_tags;
@property (nullable, nonatomic, copy) NSString *remarks_desc;
@property (nullable, nonatomic, copy) NSString *remarks_src;
@property (nullable, nonatomic, retain) CNUser *belong_user;

@end

NS_ASSUME_NONNULL_END
