//
//  HYZCollectionViewLayout.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/3/12.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "HYZCollectionViewLayout.h"

@implementation HYZCollectionViewLayout

- (id)init {
    if (self = [super init])
        self.scrollDirection = UICollectionViewScrollDirectionVertical;// Flow Layout Direction
    
    return self;
}

/** 当边界发生改变时，是否需要更新布局 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

/** 准备布局 */
- (void)prepareLayout {
    [super prepareLayout];
}

/** 返回layout attributes */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArr = [NSMutableArray array];
    id dataSource = self.collectionView.dataSource;
    NSDictionary *itemFrames = [((id<HYZCollectionViewLayoutDataSource>)dataSource) collectionViewCellItemFrames];
    [itemFrames enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (YES == CGRectIntersectsRect([obj CGRectValue], rect)) {
            NSIndexPath *indexPath = key;
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attribute.frame = [obj CGRectValue];
            if (YES == [((id<HYZCollectionViewLayoutDataSource>)dataSource) respondsToSelector:@selector(collectionViewCellZIndexDict)]) {
                NSDictionary *tempzIndex = [((id<HYZCollectionViewLayoutDataSource>)dataSource) collectionViewCellZIndexDict];
                if (tempzIndex && [tempzIndex objectForKey:key])
                    attribute.zIndex = [[tempzIndex objectForKey:key] integerValue];
            }
            [attributesArr addObject:attribute];
        }
    }];
    return attributesArr;
}

/** 调整collectionView的content size */
- (CGSize)collectionViewContentSize {
    id dataSource = self.collectionView.dataSource;
    return [((id<HYZCollectionViewLayoutDataSource>)dataSource) adjustCollectionViewContentSize];
}

@end
