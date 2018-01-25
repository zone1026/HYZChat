//
//  CNUser+CoreDataProperties.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/25.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import "CNUser+CoreDataProperties.h"

@implementation CNUser (CoreDataProperties)

+ (NSFetchRequest<CNUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNUser"];
}

@dynamic last_time;
@dynamic user_id;
@dynamic user_identity;
@dynamic user_name;
@dynamic user_password;
@dynamic user_phone;
@dynamic user_sex;
@dynamic is_login;
@dynamic has_chatMessages;

@end
