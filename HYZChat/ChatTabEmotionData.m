//
//  ChatTabEmotionData.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatTabEmotionData.h"
#import "ChatEmotionTabCell.h"

@interface ChatTabEmotionData ()
@property (strong, nonatomic) NSArray *emotionTabArr;
@property (assign, nonatomic) NSInteger selectedTabIndex;

@end

@implementation ChatTabEmotionData
- (instancetype)init {
    if (self = [super init]) {
        self.selectedTabIndex = 0;
    }
    return self;
}

- (NSArray *)emotionTabArr {
    if (_emotionTabArr == nil)
        _emotionTabArr = [HYZUtil getPlistData:@"EmotionTab" inFile:@"emotion"];
    
    return _emotionTabArr;
}

#pragma mark - fucntion

- (BOOL)isEmptyEmotionTabData {
    if (self.emotionTabArr == nil || self.emotionTabArr.count <= 0)
        return YES;
    return NO;
}

- (void)openTab:(NSInteger)tabIndex {
    if (tabIndex == self.selectedTabIndex)
        return;
    
    self.selectedTabIndex = tabIndex;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(openEmotionTab:withEmotionTabValue:)]) {
        NSDictionary *dict = [self.emotionTabArr objectAtIndex:tabIndex];
        [self.delegate openEmotionTab:tabIndex withEmotionTabValue:dict[@"value"]];
    }
}

#pragma mark - collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self isEmptyEmotionTabData] == NO)
        return self.emotionTabArr.count;
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatEmotionTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emotionTabCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.emotionTabArr objectAtIndex:indexPath.item];
    [cell updateInfo:dict[@"icon"]];
    cell.backgroundColor = self.selectedTabIndex == indexPath.item ? [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]: [UIColor clearColor];
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self openTab:indexPath.item];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(emotionTabCellWidth, emotionTabCellWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

@end
