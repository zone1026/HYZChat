//
//  CNFriend+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/1/30.
//
//

#import "CNFriend+CoreDataProperties.h"

@implementation CNFriend (CoreDataProperties)

+ (NSFetchRequest<CNFriend *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNFriend"];
}

@dynamic f_id;
@dynamic f_name;
@dynamic f_src;
@dynamic f_thumb;
@dynamic f_sex;
@dynamic f_phone;
@dynamic f_identity;
@dynamic belong_user;

@end
