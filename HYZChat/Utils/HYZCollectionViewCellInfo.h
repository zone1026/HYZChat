//
//  HYZCollectionViewCellInfo.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/3/12.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

/** cell type Key */
static NSString *collectionViewCellTypeKey = @"cellType";
/** cell index Key */
static NSString *collectionViewCellIndexKey = @"cellIndex";

/**
 collection View cell 所承载的信息。包括cell 对应的cell标识（Identifier）；显示cell所需的数据；
 cell的布局frame
 */
@interface HYZCollectionViewCellInfo : NSObject
/** collection View cell 的标识 */
@property (copy, nonatomic) NSString *cellIdentifier;
/** 显示collection View cell 所需的数据 */
@property (strong, nonatomic) id modelInfo;
/** collection View cell 布局frame */
@property (assign, nonatomic) CGRect layoutFrame;

@end
