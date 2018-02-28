//
//  RemarksInfo.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/2/28.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "RemarksInfo.h"

@implementation RemarksInfo

- (NSMutableArray *)tagsArr {
    if (nil == _tagsArr) {
        if (nil != self.friendInfo)
            _tagsArr = [self.friendInfo obtainFriendTagsArray];
        else
            _tagsArr = [NSMutableArray array];
    }
    return _tagsArr;
}

- (NSMutableArray *)phonesArr {
    if (nil == _phonesArr) {
        if (nil != self.friendInfo)
            _phonesArr = [self.friendInfo obtainFriendPhoneArray];
        else
            _phonesArr = [NSMutableArray array];
    }
    return _phonesArr;
}

- (void)setFriendInfo:(CNFriend *)friendInfo {
    if (nil == friendInfo)
        return;
    
    _friendInfo = friendInfo;
    self.nickName = friendInfo.f_nickName;
    self.remarksDesc = friendInfo.remarks_desc;
    self.remarksImage = friendInfo.remarks_src;
}

@end
