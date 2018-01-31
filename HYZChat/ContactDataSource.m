//
//  ContactDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/30.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "ContactDataSource.h"
#import "ContactDefaultCellData.h"
#import "ContactCell.h"

@interface ContactDataSource ()
@property (strong, nonatomic) ContactDefaultCellData *delfaultCell;
@end

@implementation ContactDataSource

- (id)init {
    if (self = [super init]) {
        self.delfaultCell = [[ContactDefaultCellData alloc] init];
    }
    return self;
}

- (BOOL)isEmptyData {
    if (nil == self.contactDict || self.contactDict.allValues.count <= 0)
        return YES;
    return NO;
}

- (NSMutableDictionary *)contactDict {
    if (nil == _contactDict)
        _contactDict = [self groupingContactData];
    return _contactDict;
}

#pragma mark - 私有方法

/** 通讯录分组 */
- (NSMutableDictionary *)groupingContactData {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    NSArray *friendArr = [currentUser obtainSubFriendSequence];//根据昵称全拼音升序排序后的数据
    
    NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
    if (nil == friendArr || friendArr.count <= 0)
        return friendDict;
    
    NSString *firstLetter = @"START";
    NSMutableArray *groupingArr = nil;
    for (CNFriend *friend in friendArr) {
        if ([HYZUtil isEmptyOrNull:friend.f_upperPhoneticize] == YES)
            continue;//如果昵称为空，跳过；一般情况下应该是非空的
        
        if ([friend.f_upperPhoneticize isEqualToString:firstLetter] == NO) {
            if ([firstLetter isEqualToString:@"START"] == NO)
                [friendDict setObject:groupingArr forKey:firstLetter];//将上一个分组添加至字典

            firstLetter = friend.f_upperPhoneticize;
            groupingArr = [NSMutableArray array];
        }
        
        [groupingArr addObject:friend];
    }
    
    return friendDict;
}

/**
 * @description 每组联系人数据
 * @param section 分组索引
 */
- (NSMutableArray *)eachGroupContactData:(NSInteger)section {
    if (self.contactDict.allKeys.count > section)
        [self.contactDict.allValues objectAtIndex:section];
    return [NSMutableArray array];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.contactDict.allKeys.count;//顶部搜索+分组个数
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section && self.checkMode == NO)//顶部默认section
        return self.delfaultCell.defaultCellInfoArr.count;//新的朋友、群聊、标签、公共号
    
    return [self eachGroupContactData:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    if (0 == indexPath.section && self.checkMode == NO) {
        DefaultCellInfo *info = [self.delfaultCell.defaultCellInfoArr objectAtIndex:indexPath.row];
        [cell updateCellUI:info.imgName withContactName:info.name withCheckMode:self.checkMode];
    }
    else {
        CNFriend *friend = [[self eachGroupContactData:indexPath.section] objectAtIndex:indexPath.row];
        [cell updateCellUI:friend.f_thumb withContactName:friend.f_nickName withCheckMode:self.checkMode];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellEnterContactInfoUI:withCellType:)]) {
        long long targetId = 0;
        ContactCellType cellType = ContactCellTypeFriend;
        if (0 == indexPath.section && self.checkMode == YES) {
            DefaultCellInfo *info = [self.delfaultCell.defaultCellInfoArr objectAtIndex:indexPath.row];
            targetId = info.cellIdentify;
            cellType = ContactCellTypeDefault;
        }
        else {
            CNFriend *friend = [[self eachGroupContactData:indexPath.section] objectAtIndex:indexPath.row];
            targetId = friend.f_id;
            cellType = [friend contactCellTypeByFriendType];
        }
        [self.delegate didSelectCellEnterContactInfoUI:targetId withCellType:cellType];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

@end
