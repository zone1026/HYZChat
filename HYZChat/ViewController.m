//
//  ViewController.m
//  HyzChat
//
//  Created by 黄亚州 on 2017/8/31.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfNickName;
@property (weak, nonatomic) IBOutlet UISwitch *switchSex;
@property (weak, nonatomic) IBOutlet UISwitch *switchVip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSupplementConstraintHeight;

@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (assign, nonatomic) BOOL isExistUser;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.btnStart.layer.cornerRadius = 5.0f;
    self.isExistUser = YES;
    self.viewSupplementConstraintHeight.constant = 0.0f;
    CNUser *lastUser = [[DataManager sharedManager] lastLoginUser];
    if (lastUser != nil) {
        self.lblDesc.text = [NSString stringWithFormat:@"欢迎您回来，%@%@", lastUser.user_name, lastUser.user_sex == UserSexMan ? @"先生" : @"女士"];
        self.tfPhone.text = lastUser.user_phone;
        self.tfPassword.text = lastUser.user_password;
        self.tfNickName.text = lastUser.user_name;
        [DataManager sharedManager].currentUser = lastUser;
    }
    else {
        self.lblDesc.text = @"欢迎登录";
        self.tfPhone.text = @"";
        self.tfPassword.text = @"";
        self.tfNickName.text = @"";
    }
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

- (IBAction)switchValueChanged:(UISwitch *)sender {
    
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
    
    if (self.isExistUser == NO) {
        if ([HYZUtil isEmptyOrNull:self.tfNickName.text] == YES) {
            [HYZAlert showInfo:@"昵称不能为空" underTitle:@"提示"];
            return;
        }
        
        if ([self.tfNickName.text length] > 10) {
            [HYZAlert showInfo:@"昵称不能超过10字符" underTitle:@"提示"];
            return;
        }
        CNUser *user = [DataManager sharedManager].currentUser;
        user.user_name = self.tfNickName.text;
        user.user_sex = self.switchSex.on == YES ? UserSexMan : UserSexWoman;
        user.user_identity = self.switchVip.on == YES ? UserIdentityVIP : UserIdentityNormal;
        user.last_time = [HYZUtil getCurrentTimestamp];
        
        self.isExistUser = YES;
        self.tfPhone.enabled = YES;
        self.tfPassword.enabled = YES;
        self.viewSupplementConstraintHeight.constant = 0.0f;
        [self.btnStart setTitle:@"登  录" forState:UIControlStateNormal];
        [self openChatUI];
    }
    else {
        CNUser *user = [[DataManager sharedManager] findUserFromCoredataByPhone:self.tfPhone.text];
        [DataManager sharedManager].currentUser = user;
        
        if ([HYZUtil isEmptyOrNull:user.user_password] == YES) {//还没密码，说明是新用户
            user.user_password = self.tfPassword.text;
            self.tfPhone.enabled = NO;
            self.tfPassword.enabled = NO;
            self.viewSupplementConstraintHeight.constant = 92.0f;
            self.isExistUser = NO;
            [self.btnStart setTitle:@"完善信息" forState:UIControlStateNormal];
        }
        else {
            if ([user.user_password isEqualToString:self.tfPassword.text] == NO) {
                [HYZAlert showInfo:[NSString stringWithFormat:@"密码错误，您之前设置的密码是：< %@ >，请您重新输入", user.user_password] underTitle:@"提示"];
                return;
            }
            user.last_time = [HYZUtil getCurrentTimestamp];
            [self openChatUI];
        }
    }
}

/** 打开聊天界面 */
- (void)openChatUI {
    [[DataManager sharedManager] saveContext];
//    [[ChatManager sharedManager] openChatView:ChatTargetTypeP2P withFromViewController:self];
}

@end
