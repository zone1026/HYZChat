//
//  CNChatResource+CoreDataProperties.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//
//

#import "CNChatResource+CoreDataProperties.h"

@implementation CNChatResource (CoreDataProperties)

+ (NSFetchRequest<CNChatResource *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNChatResource"];
}

@dynamic res_name;
@dynamic res_type;
@dynamic res_url;
@dynamic belong_chatMessage;

@end
