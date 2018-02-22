//
//  ContactCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/30.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "ContactCell.h"
#import "UIImageView+WebImage.h"

@interface ContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLogoConstraintLeft;

@end

@implementation ContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellUI:(NSString *)logoURLStr withContactName:(NSString *)name withCheckMode:(BOOL)checkMode {
    [self.imgLogo web_logoImage:logoURLStr withThumbImageURLStr:logoURLStr];
    self.lblName.text = name;
    self.imgLogoConstraintLeft.constant = (checkMode == YES ? 44.0f : 10.0f);
    self.imgCheck.hidden = !checkMode;
}

@end