//
//  CNFriend+CoreDataClass.h
//  
//
//  Created by 黄亚州 on 2018/1/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CNUser;

NS_ASSUME_NONNULL_BEGIN

@interface CNFriend : NSManagedObject
/**
 * @description 修改好友的昵称
 * @param newNickName 好友的新昵称
 */
- (void)modificationFirendNickName:(NSString *)newNickName;
/**
 * @description 通过好友的类型得到在通讯录中的cell类型
 */
- (ContactCellType)contactCellTypeByFriendType;

@end

NS_ASSUME_NONNULL_END

#import "CNFriend+CoreDataProperties.h"
