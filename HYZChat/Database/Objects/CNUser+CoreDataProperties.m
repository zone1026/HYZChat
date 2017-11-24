//
//  CNUser+CoreDataProperties.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//
//

#import "CNUser+CoreDataProperties.h"

@implementation CNUser (CoreDataProperties)

+ (NSFetchRequest<CNUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNUser"];
}

@dynamic user_id;
@dynamic user_identity;
@dynamic user_name;
@dynamic user_phone;
@dynamic user_sex;
@dynamic has_chatMessages;

@end
