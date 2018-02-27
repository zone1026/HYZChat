//
//  CNSession+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/2/27.
//
//

#import "CNSession+CoreDataProperties.h"

@implementation CNSession (CoreDataProperties)

+ (NSFetchRequest<CNSession *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNSession"];
}

@dynamic last_time;
@dynamic logo_src;
@dynamic logo_thumb;
@dynamic name;
@dynamic session_id;
@dynamic shield;
@dynamic target_id;
@dynamic target_type;
@dynamic type;
@dynamic unread_num;
@dynamic belong_user;
@dynamic has_chatMsgs;

@end
