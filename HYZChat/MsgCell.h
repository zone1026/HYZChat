//
//  MsgCell.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/26.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNSession+CoreDataClass.h"

@interface MsgCell : UITableViewCell
/** cell会话信息 */
@property (strong, nonatomic) CNSession *cellData;

/**
 * @description 更新cell信息
 * @param chatSession 会话信息
 */
- (void)updateCellInfo:(CNSession *)chatSession;

@end
