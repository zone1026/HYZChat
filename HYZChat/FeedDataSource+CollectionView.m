//
//  FeedDataSource+CollectionView.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/3/12.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "FeedDataSource+CollectionView.h"

@implementation FeedDataSource (CollectionView)

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - HYZCollectionViewLayoutDataSource

- (NSDictionary *)collectionViewCellItemFrames {
    return [self calculateItemCellFrames];
}

- (CGSize)adjustCollectionViewContentSize {
    CGFloat adjustHeight;
    if (self.contentHeight < self.collectionViewSize.height) {
        adjustHeight = self.collectionViewSize.height;
    }
    else {
        adjustHeight = self.contentHeight;
    }
    adjustHeight += 20;//content低部留富余空白
    return CGSizeMake(self.collectionViewSize.width, adjustHeight);
}


#pragma mark - 私有方法

/** 计算cell item的frame */
- (NSMutableDictionary *)calculateItemCellFrames {
    NSMutableDictionary *tempItemsFrames = [NSMutableDictionary dictionary];
    return tempItemsFrames;
}

@end
