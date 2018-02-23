//
//  CNFriend+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/2/23.
//
//

#import "CNFriend+CoreDataProperties.h"

@implementation CNFriend (CoreDataProperties)

+ (NSFetchRequest<CNFriend *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNFriend"];
}

@dynamic f_addDate;
@dynamic f_id;
@dynamic f_identity;
@dynamic f_nickName;
@dynamic f_phone;
@dynamic f_sex;
@dynamic f_src;
@dynamic f_thumb;
@dynamic f_type;
@dynamic f_upperPhoneticize;
@dynamic f_userName;
@dynamic belong_user;

@end
