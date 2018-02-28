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

- (void)updateFriendTagsDescLabel:(UILabel *)lblDesc {
    NSString *desc = nil;
    if (self.tagsArr.count > 0)
        desc = [self.tagsArr componentsJoinedByString:@"、"];
    if ([HYZUtil isEmptyOrNull:desc] == YES) {
        lblDesc.text = @"通过标签给联系人分类";
        lblDesc.textColor = [UIColor lightGrayColor];
    }
    else {
        lblDesc.text = desc;
        lblDesc.textColor = RGB_COLOR(0.0f, 160.0f, 0.0f);
    }
}

- (void)updateFriendPhoneTextField:(UITextField *)tf withIndex:(NSInteger)index {
    if (self.phonesArr.count > index)
        tf.text = [self.phonesArr objectAtIndex:index];
    else
        tf.text = @"";
}

@end
