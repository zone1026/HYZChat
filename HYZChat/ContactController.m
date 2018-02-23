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
#import "UIView+HYZFrame.h"

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
    [self openContactAlertView];
}

#pragma mark - 私有方法

/** 打开添加联系人时的提示框 */
- (void)openContactAlertView {
    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:@"添加新的通讯对象" message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *searcUserAction = [UIAlertAction actionWithTitle:@"搜索本地其他用户" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self searchLocalCNUser];
                                                            }];
    UIAlertAction *searcGroupAction = [UIAlertAction actionWithTitle:@"搜索本地其他用户的新建的群组" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                             }];
    UIAlertAction *createGroupAction = [UIAlertAction actionWithTitle:@"新建群组" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [sheetController addAction:searcUserAction];
    [sheetController addAction:searcGroupAction];
    [sheetController addAction:createGroupAction];
    [sheetController addAction:cancelAction];
    UIPopoverPresentationController *popover = sheetController.popoverPresentationController;
    if (nil != popover) {
        popover.sourceView = self.view;
        CGRect soureceRect = popover.sourceRect;
        soureceRect.origin = CGPointMake(self.view.width, self.topLayoutGuide.length);
        popover.sourceRect = soureceRect;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:sheetController animated:YES completion:nil];
}

/** 搜索本地的用户，发现未添加时，自动添加到好友列表 */
- (void)searchLocalCNUser {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_phone != %@", [DataManager sharedManager].currentUser.user_phone];
    NSArray *result = [[DataManager sharedManager] arrayFromCoreData:@"CNUser" predicate:predicate
                                                            limitNum:NSIntegerMax offset:0 orderBy:nil];
    if (nil == result || result.count <= 0) {
        [HYZAlert showInfo:@"未发现本地用户" underTitle:@"提示"];
        return;
    }
    
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
