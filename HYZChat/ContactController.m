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
#import "ContactFooterView.h"
#import "RemarksController.h"

@interface ContactController () <ContactDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property (strong, nonatomic) IBOutlet ContactDataSource *contactDataSource;
@property (weak, nonatomic) IBOutlet ContactHeaderView *headerView;
@property (weak, nonatomic) IBOutlet ContactFooterView *footerView;

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
    self.contactDataSource.contactDict = nil;
    [self.contactTableView reloadData];
    
    [self updateContactTableViewFooterView];
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
    
    NSInteger addCount = 0;
    for (CNUser *user in result) {
       BOOL exist = [[DataManager sharedManager] addFriendByUserInfo:user];
        if (NO == exist)
            addCount ++;
    }
    
    if (addCount > 0)
        [HYZAlert showInfo:[NSString stringWithFormat:@"搜索到%ld名用户信息，已添加到好友列表中", (long)addCount] underTitle:@"提示"];
    else
        [HYZAlert showInfo:@"发现本地用户都已经存在好友列表中" underTitle:@"提示"];
    [[DataManager sharedManager] saveContext];
    self.contactDataSource.contactDict = nil;
    [self.contactTableView reloadData];
}

/** 更新通讯录表格的页脚视图 */
- (void)updateContactTableViewFooterView {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    if (currentUser.has_friends.count > 0) {
        self.footerView.frame = CGRectMake(0.0f, 0.0f, self.view.width, 44.0f);
        self.footerView.lblNum.text = [NSString stringWithFormat:@"%ld位联系人", (long)currentUser.has_friends.count];
    }
    else
        self.footerView.frame = CGRectMake(0.0f, 0.0f, self.view.width, 0.01f);
    self.contactTableView.tableFooterView = self.footerView;
}

/** 打开好友私聊界面 */
- (void)openFriendChatUI:(long long)tragetID {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    
    CNSession *chatSession = nil;
    if (nil != currentUser.has_sessions) {
        for (CNSession *session in currentUser.has_sessions) {
            if (session.target_type == ChatTargetTypeP2P && session.target_id == tragetID) {
                chatSession = session;
                break;
            }
        }
    }
    
    if (nil == chatSession) {
        chatSession = [[DataManager sharedManager] addChatSessionByFriendId:tragetID];
        [[DataManager sharedManager] saveContext];
    }
    
    [[ChatManager sharedManager] openChatView:chatSession withFromViewController:self];
}

#pragma mark - ContactDataSourceDelegate

- (void)didSelectCellEnterContactInfoUI:(long long)targetId withCellType:(ContactCellType)type {
    switch (type) {
        case ContactCellTypeDefault:
            break;
        case ContactCellTypeCompany:
            break;
        default:
            [self openFriendChatUI:targetId];
            break;
    }
}

- (void)doFriendRemarks:(CNFriend *)friendInfo {
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"NaviRemarks"];//同一个storyboad
    RemarksController *vc = (RemarksController *)nc.topViewController;
    vc.friendInfo = friendInfo;
    [self showDetailViewController:nc sender:friendInfo];
//    [self presentViewController:nc animated:YES completion:nil];
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
