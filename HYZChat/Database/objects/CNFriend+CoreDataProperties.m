//
//  CNFriend+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/1/31.
//
//

#import "CNFriend+CoreDataProperties.h"

@implementation CNFriend (CoreDataProperties)

+ (NSFetchRequest<CNFriend *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNFriend"];
}

@dynamic f_id;
@dynamic f_identity;
@dynamic f_userName;
@dynamic f_phone;
@dynamic f_sex;
@dynamic f_src;
@dynamic f_thumb;
@dynamic f_upperPhoneticize;
@dynamic f_addDate;
@dynamic f_nickName;
@dynamic f_type;
@dynamic belong_user;

@end
