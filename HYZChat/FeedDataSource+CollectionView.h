//
//  FeedDataSource+CollectionView.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/3/12.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "FeedDataSource.h"
#import "HYZCollectionViewLayout.h"

@interface FeedDataSource (CollectionView) <UICollectionViewDelegate, UICollectionViewDataSource, HYZCollectionViewLayoutDataSource>

@end
