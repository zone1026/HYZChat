//
//  CNChatResource+CoreDataProperties.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//
//

#import "CNChatResource+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNChatResource (CoreDataProperties)

+ (NSFetchRequest<CNChatResource *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *res_name;
@property (nonatomic) int16_t res_type;
@property (nullable, nonatomic, copy) NSString *res_url;
@property (nullable, nonatomic, retain) CNChatMessage *belong_chatMessage;

@end

NS_ASSUME_NONNULL_END
