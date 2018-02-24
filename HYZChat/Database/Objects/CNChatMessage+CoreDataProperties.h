//
//  CNChatMessage+CoreDataProperties.h
//  
//
//  Created by 黄亚州 on 2018/2/24.
//
//

#import "CNChatMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CNChatMessage (CoreDataProperties)

+ (NSFetchRequest<CNChatMessage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *msg_content;
@property (nonatomic) int64_t msg_id;
@property (nonatomic) int16_t msg_state;
@property (nonatomic) int16_t msg_type;
@property (nullable, nonatomic, copy) NSString *send_nick;
@property (nonatomic) int64_t send_time;
@property (nonatomic) int64_t send_userId;
@property (nullable, nonatomic, retain) CNChatResource *assign_res;
@property (nullable, nonatomic, retain) CNSession *belong_session;

@end

NS_ASSUME_NONNULL_END
