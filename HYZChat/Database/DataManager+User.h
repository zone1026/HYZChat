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
/**
 * @description 通过好友信息添加私聊会话
 * @param fid 用户的信息
 * @return 会话信息
 */
- (CNSession *)addChatSessionByFriendId:(long long)fid;
/**
 * @description 根据好友删除当前用户的某位好友
 * @param fid 用户的信息
 * @return 是否找到了该好友信息
 */
- (BOOL)deleteCurrentUserFriendByFid:(long long)fid;

@end
