//
//  ContactController.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/30.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "ContactController.h"
#import "ContactDataSource.h"
#import "ContactHeaderView.h"

@interface ContactController () <ContactDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property (strong, nonatomic) IBOutlet ContactDataSource *contactDataSource;
@property (weak, nonatomic) IBOutlet ContactHeaderView *headerView;

@end

@implementation ContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contactDataSource.checkMode = self.checkMode;
    self.contactDataSource.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.headerView.btnVoice.hidden = ![HYZUtil isEmptyOrNull:searchText];
}

#pragma mark - ContactHeaderView

/** 语音点击事件 */
- (IBAction)btnVoiceTouchUpInside:(UIButton *)sender {
    
}

@end
