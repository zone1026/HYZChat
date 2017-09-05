//
//  ChatEmotionTabCell.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatEmotionTabCell : UICollectionViewCell
/**
 * @description 更新表情图标
 * @param imgName 表情图标的名字
 */
- (void)updateInfo:(NSString *)imgName;
@end
