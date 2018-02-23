//
//  DataManager+User.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/12.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "DataManager.h"

@interface DataManager (User)

/**
 * @description 通过用户信息添加到好友列表
 * @param user 用户的信息
 * @return 该用户是否已存在好友列表中
 */
- (BOOL)addFriendByUserInfo:(CNUser *)user;

@end
