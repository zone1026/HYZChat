//
//  CNSession+CoreDataProperties.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import "CNSession+CoreDataProperties.h"

@implementation CNSession (CoreDataProperties)

+ (NSFetchRequest<CNSession *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNSession"];
}

@dynamic last_time;
@dynamic session_id;
@dynamic session_logo;
@dynamic session_name;
@dynamic session_shield;
@dynamic unread_Num;
@dynamic belong_user;
@dynamic has_chatMsgs;

@end
