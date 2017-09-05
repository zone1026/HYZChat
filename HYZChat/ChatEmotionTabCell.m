//
//  ChatEmotionTabCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatEmotionTabCell.h"

@interface ChatEmotionTabCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgEmotionTab;
@end

@implementation ChatEmotionTabCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self clearData];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearData];
}

- (void)clearData {
    self.imgEmotionTab.image = nil;
}

#pragma mark - update uiimage view image

- (void)updateInfo:(NSString *)imgName {
    if ([HYZUtil isEmptyOrNull:imgName]) {
        self.imgEmotionTab.image = nil;
        return;
    }
    self.imgEmotionTab.image = [UIImage imageNamed:imgName];
}

@end
