//
//  CNChatResource+CoreDataProperties.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "CNChatResource+CoreDataProperties.h"

@implementation CNChatResource (CoreDataProperties)

+ (NSFetchRequest<CNChatResource *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNChatResource"];
}

@dynamic res_url;
@dynamic res_type;
@dynamic res_name;
@dynamic belong_chatMessage;

@end
