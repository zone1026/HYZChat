//
//  CNChatMessage+CoreDataProperties.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/11.
//  Copyright © 2017年 黄亚州. All rights reserved.
//
//

#import "CNChatMessage+CoreDataProperties.h"

@implementation CNChatMessage (CoreDataProperties)

+ (NSFetchRequest<CNChatMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNChatMessage"];
}

@dynamic msg_content;
@dynamic msg_id;
@dynamic msg_state;
@dynamic msg_type;
@dynamic send_nick;
@dynamic send_time;
@dynamic send_userId;
@dynamic target_id;
@dynamic target_type;
@dynamic assign_res;
@dynamic belong_user;

@end
