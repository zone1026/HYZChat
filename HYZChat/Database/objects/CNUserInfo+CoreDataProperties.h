//
//  CNUserInfo+CoreDataProperties.h
//  
//
//  Created by 黄亚州 on 2018/2/23.
//
//

#import "CNUserInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNUserInfo (CoreDataProperties)

+ (NSFetchRequest<CNUserInfo *> *)fetchRequest;

@property (nonatomic) int16_t u_sex;
@property (nonatomic) int16_t u_identity;
@property (nullable, nonatomic, copy) NSString *u_birthday;
@property (nullable, nonatomic, copy) NSString *u_city;
@property (nullable, nonatomic, copy) NSString *u_email;
@property (nullable, nonatomic, copy) NSString *u_src;
@property (nullable, nonatomic, copy) NSString *u_thumb;
@property (nullable, nonatomic, retain) CNUser *belong_user;

@end

NS_ASSUME_NONNULL_END
