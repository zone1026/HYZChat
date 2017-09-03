//
//  ChatEmotionCell.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/3.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatEmotionCell : UICollectionViewCell
/**
 * @description 更新表情图标
 * @param imgPath 表情图标的名字
 */
- (void)updateInfo:(NSString *)imgPath;
@end
