//
//  HYZCollectionViewLayout.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/3/12.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @descriptoin 自定义collectionView布局对应的代理
 */
@protocol HYZCollectionViewLayoutDataSource <NSObject>

@required
/**
 * @description cell item 的frame集合
 */
- (NSDictionary *)collectionViewCellItemFrames;
/**
 * @description 调整collectionView的content size
 */
- (CGSize)adjustCollectionViewContentSize;

@optional
/**
 * @description 设置cell的Z轴Index
 */
- (NSDictionary *)collectionViewCellZIndexDict;

@end

@interface HYZCollectionViewLayout : UICollectionViewFlowLayout

@end
