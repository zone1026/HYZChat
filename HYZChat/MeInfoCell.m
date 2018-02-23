//
//  MeInfoCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/2/23.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "MeInfoCell.h"
#import "UIImageView+WebImage.h"

@interface MeInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblNickName;
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;

@end

@implementation MeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self updateUIInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 更新UI消息 */
- (void)updateUIInfo {
    CNUser *currentUser = [DataManager sharedManager].currentUser;
    [self.imgLogo web_meLogoImage];
    self.lblNickName.text = currentUser.user_name;
    self.lblAccount.text = @"微信账号：xxx";
}

@end
