//
//  CNUserInfo+CoreDataProperties.m
//  
//
//  Created by 黄亚州 on 2018/2/23.
//
//

#import "CNUserInfo+CoreDataProperties.h"

@implementation CNUserInfo (CoreDataProperties)

+ (NSFetchRequest<CNUserInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CNUserInfo"];
}

@dynamic u_sex;
@dynamic u_identity;
@dynamic u_birthday;
@dynamic u_city;
@dynamic u_email;
@dynamic u_src;
@dynamic u_thumb;
@dynamic belong_user;

@end
