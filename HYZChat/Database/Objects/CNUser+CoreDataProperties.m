//
//  CNUser+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/1/30.
//
//

#import "CNUser+CoreDataProperties.h"

@implementation CNUser (CoreDataProperties)

+ (NSFetchRequest<CNUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNUser"];
}

@dynamic is_login;
@dynamic last_time;
@dynamic user_id;
@dynamic user_identity;
@dynamic user_name;
@dynamic user_password;
@dynamic user_phone;
@dynamic user_sex;
@dynamic has_sessions;
@dynamic has_groups;
@dynamic has_friends;

@end
