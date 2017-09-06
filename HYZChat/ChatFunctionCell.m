//
//  ChatFunctionCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatFunctionCell.h"
#import "CALayer+HYZUtil.h"

@interface ChatFunctionCell ()
@property (weak, nonatomic) IBOutlet UIButton *btnFunction;
@property (weak, nonatomic) IBOutlet UIImageView *imgFunction;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (assign, nonatomic) NSInteger buttonValue;

@end

@implementation ChatFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self clearData];
    [self.btnFunction.layer setBorder:0.5 withColor:[UIColor lightGrayColor] withCorner:8.0];
    [self.btnFunction setBackgroundImage:[HYZUtil imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateHighlighted];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearData];
}

- (void)clearData {
    self.imgFunction.image = nil;
    self.lblName.text = @"";
    self.btnFunction.hidden = YES;
}

- (IBAction)btnFunctionTouchUpInside:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiChatBottomFunctionButtonClick object:@(self.buttonValue)];
}

#pragma mark - update ui data

- (void)updateInfo:(NSString *)imageName withFunctionName:(NSString *)name withButtonValue:(NSInteger )value {
    if ([HYZUtil isEmptyOrNull:imageName] == NO) {
        self.imgFunction.image = [UIImage imageNamed:imageName];
        self.lblName.text = name;
        self.btnFunction.hidden = NO;
        self.buttonValue = value;
    }
}

@end
