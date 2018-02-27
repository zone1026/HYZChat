//
//  MsgDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "MsgDataSource.h"
#import "MsgCell.h"

@interface MsgDataSource ()

@end

@implementation MsgDataSource

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)isEmptyData {
    if (nil == self.sessionArr || self.sessionArr.count <= 0)
        return YES;
    return NO;
}

- (NSMutableArray <CNSession *> *)sessionArr {
    if (_sessionArr == nil) {
        CNUser *currentUser = [DataManager sharedManager].currentUser;
        _sessionArr = [[currentUser getSubSessionSequence] mutableCopy];
    }
    return _sessionArr;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isEmptyData] == YES)
        return 1;
    return self.sessionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isEmptyData] == YES) {
        UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
        emptyCell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, tableView.bounds.size.width);
        return emptyCell;
    }

    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell" forIndexPath:indexPath];
    CNSession *session = [self.sessionArr objectAtIndex:indexPath.row];
    [cell updateCellInfo:session];
    return cell;
}

/** 可编辑 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellEnterChatUI:)]) {
        if (self.sessionArr.count > indexPath.row) {
            CNSession *session = [self.sessionArr objectAtIndex:indexPath.row];
            [self.delegate didSelectCellEnterChatUI:session];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self isEmptyData] == NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isEmptyData] == YES)
        return kScreenHeight*0.5f;
    return 70.0f;
}

/** 添加左拉抽屉操作 */
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 删除按钮
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除用户"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 
                                                                             }];
    UITableViewRowAction *secondAction = nil;
    CNSession *session = [self.sessionArr objectAtIndex:indexPath.row];
    switch (session.type) {
        case SessionTypeFriend:
        case SessionTypeGroup:
            secondAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:(session.unread_Num > 0 ? @"标记已读" : @"标记未读")
                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                
                                                            }];
            break;
        case SessionTypeOrganization:
        case SessionTypeOfficial:
            secondAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消关注"
                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                
                                                            }];
            break;
        default:
            break;
    }
    
    if (nil == secondAction)
        return @[delAction];
    
    secondAction.backgroundColor = [UIColor lightGrayColor];
    // 将设置好的按钮放到数组中返回
    return @[delAction, secondAction];
}

@end
