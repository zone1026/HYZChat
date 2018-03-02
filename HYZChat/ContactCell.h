//
//  ContactCell.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/30.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
/**
 * @description 更新Cell界面
 * @param logoURLStr 头像URL
 * @param name 联系人的名字
 * @param remarksDesc 备注信息
 * @param checkMode 是否处于勾选模式下
 */
- (void)updateCellUI:(NSString *)logoURLStr withContactName:(NSString *)name withRemarksDesc:(NSString *)remarksDesc withCheckMode:(BOOL)checkMode;

@end
