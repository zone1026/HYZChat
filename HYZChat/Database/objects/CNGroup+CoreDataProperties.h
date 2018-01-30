//
//  CNGroup+CoreDataProperties.h
//  
//
//  Created by 黄亚州 on 2018/1/30.
//
//

#import "CNGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNGroup (CoreDataProperties)

+ (NSFetchRequest<CNGroup *> *)fetchRequest;

@property (nonatomic) int64_t g_id;
@property (nullable, nonatomic, copy) NSString *g_name;
@property (nullable, nonatomic, copy) NSString *g_src;
@property (nullable, nonatomic, copy) NSString *g_thumb;
@property (nonatomic) BOOL g_public;
@property (nonatomic) int16_t max_num;
@property (nullable, nonatomic, retain) CNUser *belong_user;

@end

NS_ASSUME_NONNULL_END
