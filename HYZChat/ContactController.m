//
//  ContactController.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/30.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "ContactController.h"
#import "ContactDataSource.h"

@interface ContactController () <ContactDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property (strong, nonatomic) IBOutlet ContactDataSource *contactDataSource;

@end

@implementation ContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *headerView = [self.contactTableView dequeueReusableCellWithIdentifier:@"searchCell"].contentView;
    headerView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, 66.0f);
    self.contactTableView.tableHeaderView = headerView;
    
    self.contactDataSource.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)addContactSelector:(UIBarButtonItem *)sender {
    
}

#pragma mark - ContactDataSourceDelegate

- (void)didSelectCellEnterContactInfoUI:(long long)targetId withCellType:(ContactCellType)type {
    
}

@end
