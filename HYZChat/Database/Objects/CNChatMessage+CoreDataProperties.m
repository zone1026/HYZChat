//
//  CNChatMessage+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/2/24.
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
@dynamic assign_res;
@dynamic belong_session;

@end
