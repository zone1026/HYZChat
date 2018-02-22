//
//  CNSession+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/1/29.
//
//

#import "CNSession+CoreDataProperties.h"

@implementation CNSession (CoreDataProperties)

+ (NSFetchRequest<CNSession *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNSession"];
}

@dynamic last_time;
@dynamic session_id;
@dynamic logo_src;
@dynamic name;
@dynamic shield;
@dynamic unread_Num;
@dynamic logo_thumb;
@dynamic type;
@dynamic belong_user;
@dynamic has_chatMsgs;

@end