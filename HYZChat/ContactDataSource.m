//
//  ContactDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/30.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "ContactDataSource.h"

@implementation ContactDataSource

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

@end
