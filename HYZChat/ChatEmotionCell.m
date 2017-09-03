//
//  ChatEmotionCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/3.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatEmotionCell.h"

@interface ChatEmotionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgEmotion;

@end

@implementation ChatEmotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self clearData];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearData];
}

- (void)clearData {
    self.imgEmotion.image = nil;
}

#pragma mark - update uiimage view image

- (void)updateInfo:(NSString *)imgName
{
    if ([HYZUtil isEmptyOrNull:imgName]) {
        self.imgEmotion.image = nil;
        return;
    }
    self.imgEmotion.image = [UIImage imageNamed:imgName];
}

@end
