//
//  CNFriend+CoreDataClass.m
//  
//
//  Created by 黄亚州 on 2018/1/30.
//
//

#import "CNFriend+CoreDataClass.h"

/** 对好友备注的最大电话号码个数 */
static const NSInteger remarksFriendMaxPhoneNum = 5;

@implementation CNFriend

- (void)modificationFirendNickName:(NSString *)newNickName {
    if ([HYZUtil isEmptyOrNull:newNickName] == YES)//如果新的昵称为空，昵称就是好友的用户名
        newNickName = self.f_userName;
    
    self.f_nickName = newNickName;
    
    NSString *upperPhoneTicize = [HYZUtil chineseCharactersChange2UpperPhoneticize:newNickName];//大写的全拼音
    NSString *firstLetter = [upperPhoneTicize substringToIndex:1];
    if ([firstLetter characterAtIndex:0] >= 'A' && [firstLetter characterAtIndex:0] <= 'Z')//首字母是否是A～Z（ASCII值65～90）
        self.f_upperPhoneticize = [upperPhoneTicize stringByReplacingOccurrencesOfString:@" " withString:@""];
    else
        self.f_upperPhoneticize = @"[[[";//PS:"["的ASCII值是91，大于Z；对好友列表排序时会用到
}

- (ContactCellType)contactCellTypeByFriendType {
    ContactCellType type = ContactCellTypeFriend;
    switch (self.f_type) {
        case FriendTypeeCompany:
            type = ContactCellTypeCompany;
            break;
        default:
            break;
    }
    return type;
}

- (NSMutableArray *)obtainFriendPhoneArray {
    NSMutableArray *phoneArr;
    if ([HYZUtil isEmptyOrNull:self.f_phone] == NO)
        phoneArr = [[self.f_phone componentsSeparatedByString:@","] mutableCopy];
    else
        phoneArr = [NSMutableArray array];
    
    if (phoneArr.count < remarksFriendMaxPhoneNum) {//没有到达最大值
        NSInteger start = phoneArr.count;
        for (NSInteger i = start; i < remarksFriendMaxPhoneNum; i++)
            [phoneArr addObject:@"placeholder"];//占位手机号
    }
    return phoneArr;
}

- (NSMutableArray *)obtainFriendTagsArray {
    NSMutableArray *tagsArr;
    if ([HYZUtil isEmptyOrNull:self.f_tags] == NO)
        tagsArr = [[self.f_tags componentsSeparatedByString:@","] mutableCopy];
    else
        tagsArr = [NSMutableArray array];
    return tagsArr;
}

- (BOOL)checkFriendFristPhoneIsContactPhone {
    return YES;
}

@end
