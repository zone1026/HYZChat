//
//  MsgCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "MsgCell.h"

@interface MsgCell ()
/** 消息头像 */
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
/** 消息标题 */
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
/** 消息时间 */
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
/** 最近一次消息的内容 */
@property (weak, nonatomic) IBOutlet UILabel *lblLastMsg;
/** 是否已对消息屏蔽 */
@property (weak, nonatomic) IBOutlet UIImageView *imgShield;
/** 未读消息个数 */
@property (weak, nonatomic) IBOutlet UILabel *lblUnreadNum;

@end

@implementation MsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellInfo:(CNSession *)chatSession {
//    self.imgLogo = [UIImage imageNamed:<#(nonnull NSString *)#>]
}

@end
