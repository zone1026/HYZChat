//
//  FrameController.m
//  HyzChat
//
//  Created by 黄亚州 on 2017/8/31.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "FrameController.h"

@interface FrameController ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *welcomeView;

/** 是否在登录界面 */
@property (assign, nonatomic) BOOL inShowLogin;

@end

@implementation FrameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.inShowLogin = NO;
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiUserLoginNeeded:)
                                                 name:NotiUserLoginNeeded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiUserLoginSuccess:)
                                                 name:NotiUserLoginSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CNUser *lastUser = [[DataManager sharedManager] lastLoginUser];
    if (nil == lastUser || lastUser.is_login == NO)
        [self openLoginView];
    else {
        [DataManager sharedManager].currentUser = lastUser;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.welcomeView.hidden = YES;
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - 消息通知

- (void)handleNotiUserLoginNeeded:(NSNotification *)notification {
    [self openLoginView];
}

- (void)handleNotiUserLoginSuccess:(NSNotification *)notification {
    self.inShowLogin = NO;
}

#pragma mark - 私有方法

/** 打开登录界面 */
- (void)openLoginView {
    if (self.inShowLogin == YES)
        return;
    
    self.welcomeView.hidden = YES;
    self.inShowLogin = YES;
    
    UINavigationController *nc = (UINavigationController *)[HYZUtil instantiateViewController:@"LoginNavigation" withStoryboardName:@"Login"];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
