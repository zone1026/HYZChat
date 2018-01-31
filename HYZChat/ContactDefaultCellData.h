//
//  ContactDefaultCellData.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/31.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultCellInfo : NSObject
/** cell左边图片 */
@property (copy, nonatomic) NSString *imgName;
/** cell名称 */
@property (copy, nonatomic) NSString *name;
/** cell表示 */
@property (assign, nonatomic) ContactDefaultCellIdentify cellIdentify;

@end

@interface ContactDefaultCellData : NSObject
/** 默认cell数据数组 */
@property (strong, nonatomic) NSMutableArray <DefaultCellInfo *>*defaultCellInfoArr;

@end
