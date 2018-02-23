//
//  SettingController.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/2/23.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "SettingController.h"

@interface SettingController () <UITableViewDelegate>

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 15.0f)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (5 == indexPath.section) {//退出登录
        [CNAlertView showWithTitle:nil message:@"您确定要退出登录吗？退出后不会删除任何历史数据，下次登录依然可以使用本账号。"
                          tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                              if (alertView.firstOtherButtonIndex == buttonIndex)
                                  [self logoutCurrentAccount];
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - 私有方法

/** 退出当前的账号 */
- (void)logoutCurrentAccount {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    currentUser.is_login = NO;
    [[DataManager sharedManager] saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiUserLoginNeeded object:nil];
}

@end
