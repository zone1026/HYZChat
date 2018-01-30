//
//  CNGroup+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/1/30.
//
//

#import "CNGroup+CoreDataProperties.h"

@implementation CNGroup (CoreDataProperties)

+ (NSFetchRequest<CNGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNGroup"];
}

@dynamic g_id;
@dynamic g_name;
@dynamic g_src;
@dynamic g_thumb;
@dynamic g_public;
@dynamic max_num;
@dynamic belong_user;

@end
