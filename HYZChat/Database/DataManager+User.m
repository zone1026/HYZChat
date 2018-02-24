//
//  DataManager+User.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/12.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "DataManager+User.h"

@implementation DataManager (User)

- (BOOL)addFriendByUserInfo:(CNUser *)user {
    NSArray *friendArr = [self.currentUser obtainSubFriendSequence];
    
    CNFriend *friend = nil;
    for (CNFriend *friendInfo in friendArr) {
        if (friendInfo.f_id == user.user_id) {
            friend = friendInfo;
            break;
        }
    }
    
    BOOL exist = YES;
    if (nil == friend) {
        exist = NO;
        friend = (CNFriend *)[self insertIntoCoreData:@"CNFriend"];
        friend.belong_user = self.currentUser;
        
        friend.f_addDate = [HYZUtil getCurrentTimestamp];
        [friend modificationFirendNickName:user.user_name];
    }

    friend.f_id = user.user_id;
    friend.f_identity = user.assign_userInfo.u_identity;
    friend.f_userName = user.user_name;
    friend.f_phone = user.user_phone;
    friend.f_sex = user.assign_userInfo.u_sex;
    friend.f_src = user.assign_userInfo.u_src;
    friend.f_thumb = user.assign_userInfo.u_thumb;
    friend.f_type = FriendTypeNormal;

    return exist;
}

/** 通过好友ID查找好友信息 */
- (CNFriend *)friendFromCoredataByFid:(long long)fid {
    NSArray *friendArr = [self.currentUser obtainSubFriendSequence];
    for (CNFriend *friend in friendArr) {
        if (friend.f_id == fid)
            return friend;
    }
    
    CNFriend *friend = (CNFriend *)[self insertIntoCoreData:@"CNFriend"];
    friend.belong_user = self.currentUser;
    
    return friend;
}

- (CNSession *)addChatSessionByFriendId:(long long)fid {
    if (nil != self.currentUser.has_friends) {
        for (CNFriend *friend in self.currentUser.has_friends) {
            if (friend.f_id == fid)
                return [self obtainSessionFromCoredataByFriend:friend];
        }
    }
    
    return nil;
}

/** 通过好友信息创建私聊会话 */
- (CNSession *)obtainSessionFromCoredataByFriend:(CNFriend *)friend {
    CNSession *session = (CNSession *)[self insertIntoCoreData:@"CNSession"];
    session.belong_user = self.currentUser;
    
    session.last_time = [HYZUtil getCurrentTimestamp];
    session.logo_src = friend.f_src;
    session.logo_thumb = friend.f_thumb;
    session.name = friend.f_nickName;
    session.shield = NO;//是否屏蔽
    session.type = SessionTypeFriend;
    session.unread_Num = 0;
    session.target_id = friend.f_id;
    session.target_type = ChatTargetTypeP2P;
    
    return session;
}

@end
