//
//  ChatDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatDataSource.h"
#import "ChatDataSource+TableView.h"


@implementation ChatDataSource

- (instancetype)init {
    if (self = [super init]) {
        _chatMsgArr = nil;
        _chatCellInfoDict = nil;
        [self loadChatCellInfoData];
        [self loadLocalChatMsgData];
    }
    return self;
}

- (NSMutableArray *)chatMsgArr {
    if (_chatMsgArr == nil)
        _chatMsgArr = [NSMutableArray array];
    return _chatMsgArr;
}

- (NSMutableDictionary *)chatCellInfoDict {
    if (_chatCellInfoDict == nil)
        _chatCellInfoDict = [NSMutableDictionary dictionary];
    return _chatCellInfoDict;
}

- (NSMutableDictionary *)cellHeightDict {
    if (_cellHeightDict == nil)
        _cellHeightDict = [NSMutableDictionary dictionary];
    return _cellHeightDict;
}

#pragma mark - 私有方法

/** 加载本地数据库中的消息数据*/
- (void)loadLocalChatMsgData {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    NSArray *userMsgArr = [currentUser getSubChatMessageSequence];
    for (CNChatMessage *chatMsg in userMsgArr) {
        if ([chatMsg checkMsgTypeCanSupport] == YES)
            [self.chatMsgArr addObject:chatMsg];
    }
}

/** 加载本地数据库中的消息数据*/
- (void)loadChatCellInfoData {
    NSArray *cellInfo = [HYZUtil getPlistData:@"Cell" inFile:@"Chat"];
    for (NSDictionary *dict in cellInfo) {
        ChatTableCellInfo *info = [[ChatTableCellInfo alloc] init];
        info.type = [dict[@"type"] integerValue];
        if (info.type <= ChatMsgTypeFree || info.type >= ChatMsgTypeUpperLimit)
            continue;//不支持这个cell的类型
        info.className = dict[@"className"];
        info.indentifier = dict[@"indentifier"];
        [self.chatCellInfoDict setObject:info forKey:@(info.type)];
    }
}

#pragma mark - 共有方法

- (BOOL)isEmptyData {
    if (self.chatMsgArr == nil || self.chatMsgArr.count <= 0)
        return YES;
    
    return NO;
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isEmptyData] == YES)
        return 0;
    
    return self.chatMsgArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self proxyForTableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self proxyForTableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
