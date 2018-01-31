//
//  MsgController.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "MsgController.h"
#import "MsgDataSource.h"
#import "UIView+HYZFrame.h"

@interface MsgController ()<MsgDataSourceDelegate>
@property (strong, nonatomic) IBOutlet MsgDataSource *msgDataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnAdd;

@end

@implementation MsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.msgDataSource.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event

- (IBAction)barBtnAddSelector:(UIBarButtonItem *)sender {
    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:@"添加新的会话" message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *searcUserAction = [UIAlertAction actionWithTitle:@"搜索本地其他用户" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        
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
        soureceRect.origin = CGPointMake(self.view.width, 0.0f);
        popover.sourceRect = soureceRect;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:sheetController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MsgDataSourceDelegate

- (void)didSelectCellEnterChatUI:(CNSession *)session {
    if (nil == session) {
        [HYZAlert showInfo:@"抱歉，会话数据为空" underTitle:@"提示"];
        return;
    }
    [[ChatManager sharedManager] openChatView:[session chatTargetTypeBySessionType] withFromViewController:self];
}

#pragma mark - 私有方法

- (void)createNewGroup {
    
}


@end
