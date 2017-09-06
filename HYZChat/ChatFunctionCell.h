//
//  ChatFunctionCell.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatFunctionCell : UICollectionViewCell
/**
 * @description 更新cell信息
 * @param imageName 功能按钮对应的图片
 * @param name 功能按钮对应的名字
 * @param value 功能按钮对应的标示值
 */
- (void)updateInfo:(NSString *)imageName withFunctionName:(NSString *)name withButtonValue:(NSInteger )value;

@end
