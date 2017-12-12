//
//  ViewController.m
//  HyzChat
//
//  Created by 黄亚州 on 2017/8/31.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.btnStart.layer.cornerRadius = 5.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

#pragma mark - event

- (IBAction)textFieldEditChanged:(UITextField *)sender {
    if (sender == self.tfPhone) {
        
    }
    else if (sender == self.tfPassword) {
        
    }
}

- (IBAction)btnStartTouchUpInside:(UIButton *)sender {
    [self startUserLogoin];
}

#pragma mark - 私有方法

/**
 * @description 开始用户登录
 */
- (void)startUserLogoin {
    if ([HYZUtil isEmptyOrNull:self.tfPhone.text] == YES) {
        [HYZAlert showInfo:@"手机号不能为空" underTitle:@"提示"];
        return;
    }
    
    if ([self.tfPhone.text length] != 11) {//不为11位 不是手机号
        [HYZAlert showInfo:@"手机号需要11位，请输入正确的手机号" underTitle:@"提示"];
        return;
    }
    
    if ([HYZUtil isMobileNumber:self.tfPhone.text] == NO) {
        [HYZAlert showInfo:@"手机号不合法，请输入正确的手机号" underTitle:@"提示"];
        return;
    }
    
    if ([HYZUtil isEmptyOrNull:self.tfPassword.text] == YES) {
        [HYZAlert showInfo:@"密码不能为空" underTitle:@"提示"];
        return;
    }
    
    CNUser *user = [[DataManager sharedManager] findUserFromCoredataByPhone:self.tfPhone.text];
    if ([HYZUtil isEmptyOrNull:user.user_password] == YES) {//还没密码，说明是新用户
        user.user_password = self.tfPassword.text;
        [[DataManager sharedManager] saveContext];
    }
    else {
        if ([user.user_password isEqualToString:self.tfPassword.text] == NO) {
            [HYZAlert showInfo:[NSString stringWithFormat:@"密码错误，您之前设置的密码是：<%@>，请您重新输入", user.user_password] underTitle:@"提示"];
            return;
        }
    }
    [DataManager sharedManager].currentUser = user;
}

@end
