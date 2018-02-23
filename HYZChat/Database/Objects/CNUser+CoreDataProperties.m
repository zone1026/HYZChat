//
//  CNUser+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/2/23.
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
@dynamic user_name;
@dynamic user_password;
@dynamic user_phone;
@dynamic has_friends;
@dynamic has_groups;
@dynamic has_sessions;
@dynamic assign_userInfo;

@end
