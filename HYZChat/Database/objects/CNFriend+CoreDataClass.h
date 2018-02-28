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
/**
 * @description 获取好友的电话号码数据
 */
- (NSMutableArray *)obtainFriendPhoneArray;
/**
 * @description 获取好友的标签数据（标签是自己对好友设置的）
 */
- (NSMutableArray *)obtainFriendTagsArray;
/**
 * @description 检测第一个手机号是否是通讯录手机号码
 */
- (BOOL)checkFriendFristPhoneIsContactPhone;

@end

NS_ASSUME_NONNULL_END

#import "CNFriend+CoreDataProperties.h"
