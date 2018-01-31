//
//  CNFriend+CoreDataClass.m
//  
//
//  Created by 黄亚州 on 2018/1/30.
//
//

#import "CNFriend+CoreDataClass.h"

@implementation CNFriend

- (void)modificationFirendNickName:(NSString *)newNickName {
    self.f_nickName = newNickName;
    
    NSString *upperPhoneTicize = [HYZUtil chineseCharactersChange2UpperPhoneticize:newNickName];//大写的全拼音
    NSString *firstLetter = [upperPhoneTicize substringToIndex:1];
    if ([firstLetter characterAtIndex:0] >= 'A' && [firstLetter characterAtIndex:0] <= 'Z')//首字母是否是A～Z
        self.f_upperPhoneticize = upperPhoneTicize;
    else
        self.f_upperPhoneticize = @"###";
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

@end
