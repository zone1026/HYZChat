//
//  RemarksDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/3/2.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "RemarksDataSource.h"

@interface RemarksDataSource ()

@end

@implementation RemarksDataSource

#pragma mark - 私有方法

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

/** 好友的电话号码字符串 */
- (NSString *)friendPhoneStr {
    NSMutableArray *phoneStrArr = [NSMutableArray array];
    for (NSString *str in self.phonesArr) {
        if ([HYZUtil isEmptyOrNull:str] == NO && [str isEqualToString:@"placeholder"] == NO && [str containsString:@"phone_"] == NO)
            [phoneStrArr addObject:str];
    }
    return [phoneStrArr componentsJoinedByString:@","];
}

#pragma mark - 共有方法

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
    tf.enabled = (index == 0 && [self.friendInfo checkFriendFristPhoneIsContactPhone] == YES) ? NO : YES;
    tf.textColor = tf.isEnabled == YES ? [UIColor blackColor] : [UIColor lightGrayColor];
    if (self.phonesArr.count > index) {
        NSString *phoneStr = [self.phonesArr objectAtIndex:index];
        if ([HYZUtil isEmptyOrNull:phoneStr] == NO) {
            tf.text = ([phoneStr isEqualToString:@"placeholder"] == YES || [phoneStr containsString:@"phone_"] == YES) ? @"" : phoneStr;
            return;
        }
    }
    
    tf.text = @"";
}

- (void)removeOnePhone:(NSInteger)index {
    if (self.phonesArr.count > index) {
        [self.phonesArr removeObjectAtIndex:index];
        [self.phonesArr addObject:@"placeholder"];
    }
}

- (void)addOnePhone {
    NSInteger index = [self obtainHasAddedPhoneNum];
    if (self.phonesArr.count > index)
        [self.phonesArr replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"phone_%ld", (long)index]];
}

- (NSInteger)obtainValidPhoneNum {
    NSInteger count = 0;
    for (NSString *phone in self.phonesArr) {
        if ([phone isEqualToString:@"placeholder"] == NO && [phone isEqualToString:@"placeholder"] == NO)
            count ++;
    }
    return count;
}

- (NSInteger)obtainHasAddedPhoneNum {
    NSInteger count = 0;
    for (NSString *phone in self.phonesArr) {
        if ([phone isEqualToString:@"placeholder"] == NO)//不是占位手机号
            count ++;
    }
    return count;
}

- (NSString *)obtainPhoneStrByIndex:(NSInteger)index {
    if (self.phonesArr.count > index)
        return [self.phonesArr objectAtIndex:index];
    return nil;
}

- (BOOL)checkPhoneIsHideByIndex:(NSInteger)index {
    if (self.phonesArr.count > index) {
        NSString *phoneStr = [self.phonesArr objectAtIndex:index];
        if ([HYZUtil isEmptyOrNull:phoneStr] == NO && [phoneStr isEqualToString:@"placeholder"] == NO)
            return NO;
    }
    return YES;
}

- (void)updatePhoneNum:(NSString *)phone withIndex:(NSInteger)index {
    if (self.phonesArr.count > index)
        [self.phonesArr replaceObjectAtIndex:index withObject:phone];
}

- (void)saveEidtInfo {
    if (nil == self.friendInfo)
        return;
    
    [self.friendInfo modificationFirendNickName:self.nickName];
    self.friendInfo.f_tags = [self.tagsArr componentsJoinedByString:@","];
    self.friendInfo.f_phone = [self friendPhoneStr];
    self.friendInfo.remarks_desc = [HYZUtil isEmptyOrNull:self.remarksDesc] == YES ? @"": self.remarksDesc;
    self.friendInfo.remarks_src = [HYZUtil isEmptyOrNull:self.remarksImage] == YES ? @"": self.remarksImage;
    [[DataManager sharedManager] saveContext];
}

@end
