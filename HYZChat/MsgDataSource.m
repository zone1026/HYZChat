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
    if ([self isEmptyData] == YES)
        return 1;
    return self.sessionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isEmptyData] == YES) {
        UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
        emptyCell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, tableView.bounds.size.width);
        return emptyCell;
    }

    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell" forIndexPath:indexPath];
    CNSession *session = [self.sessionArr objectAtIndex:indexPath.section];
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
        if (self.sessionArr.count > indexPath.section) {
            CNSession *session = [self.sessionArr objectAtIndex:indexPath.section];
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
    __weak typeof(self) weakSelf = self;
    // 删除按钮
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                         title:@"删除用户"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 [weakSelf deleteMsgCellByCellIndexPath:indexPath];
                                                                                 if (weakSelf.sessionArr.count <= 0)
                                                                                     [tableView reloadData];
                                                                                 else
                                                                                     [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                             }];
    UITableViewRowAction *secondAction = nil;
    CNSession *session = [self.sessionArr objectAtIndex:indexPath.section];
    switch (session.type) {
        case SessionTypeFriend:
        case SessionTypeGroup:
        {
            secondAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                              title:(session.unread_num > 0 ? @"标记已读" : @"标记未读")
                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                [weakSelf sessionUnreadMsgSignOpt:indexPath];
                                                                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                            }];
        }
            break;
        case SessionTypeOrganization:
        case SessionTypeOfficial:
        {
            secondAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                              title:@"取消关注"
                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                [weakSelf cancelConcernContact:indexPath];
                                                                if (weakSelf.sessionArr.count <= 0)
                                                                    [tableView reloadData];
                                                                else
                                                                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                            }];
        }
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

#pragma mark - 私有方法

/** 左侧滑删除消息 */
- (void)deleteMsgCellByCellIndexPath:(NSIndexPath *)indexPath {
    CNSession *session = [self.sessionArr objectAtIndex:indexPath.section];
    session.belong_user = nil;
    [[DataManager sharedManager] deleteFromCoreData:session];
    [self.sessionArr removeObject:session];
}

/** 标记回话的已读/未读操作 */
- (void)sessionUnreadMsgSignOpt:(NSIndexPath *)indexPath {
    CNSession *session = [self.sessionArr objectAtIndex:indexPath.section];
    session.unread_num = session.unread_num > 0 ? 0 : 1;
}

/** 取消关注*/
- (void)cancelConcernContact:(NSIndexPath *)indexPath {
    CNSession *session = [self.sessionArr objectAtIndex:indexPath.section];
    [[DataManager sharedManager] deleteCurrentUserFriendByFid:session.target_id];//先删除好友数据
    [self deleteMsgCellByCellIndexPath:indexPath];//再做删除会话
}

@end
