//
//  ChatFunctionData.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatFunctionData.h"
#import "ChatFunctionCell.h"
#import "PlusFunctionInfo.h"

@interface ChatFunctionData ()
@property (nonatomic, strong) NSMutableArray *functionsArr;
@end

@implementation ChatFunctionData

- (instancetype)init {
    if (self = [super init]) {
        self.functionPageNum = 0;
        self.collectionViewFunctionHeight = 0.0;
    }
    return self;
}

#pragma mark - emotions plist data
- (void)parseFunctionsPlistData {
    NSArray *functions = [HYZUtil getPlistData:@"ChatFunction" inFile:@"Chat"];
    if (functions.count <= 0) {
        NSLog(@"plist file not exist !");
    }
    else {
        NSInteger onePageItemCount = [self itemCount2Section];
        NSInteger pageNum = functions.count / onePageItemCount + 1;
        NSInteger totalNum = pageNum * onePageItemCount;
        self.functionPageNum = pageNum;
        self.functionsArr = [self getEmptyCellData:totalNum];
        NSInteger cellRow = onePageItemCount / functionLineNum;
        for (NSInteger i = 0; i < totalNum; i++) {
            if (i < functions.count) {
                PlusFunctionInfo *info = [[PlusFunctionInfo alloc] init];
                info.isEmpty = NO;
                NSDictionary *dict = [functions objectAtIndex:i];
                info.value = [[dict objectForKey:@"value"] integerValue];
                info.name = [dict objectForKey:@"name"];
                info.imgName = [dict objectForKey:@"icon"];
                NSInteger row = i / cellRow;
                NSInteger ind = row + (i % cellRow)*functionLineNum + (i / onePageItemCount)*(onePageItemCount - functionLineNum);
                self.functionsArr[ind] = info;
            }
        }
    }
}

//生成几个空item 数据
- (NSMutableArray *)getEmptyCellData:(NSInteger)num {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < num; i++) {
        PlusFunctionInfo *info = [[PlusFunctionInfo alloc] init];
        info.name = @"空数据";
        info.imgName = @"";
        info.value = -1;
        info.isEmpty = YES;
        [arr addObject:info];
    }
    return arr;
}

- (BOOL)isEmptyEmotionData {
    if (self.functionsArr == nil || self.functionsArr.count <= 0)
        return YES;
    
    return NO;
}

- (NSInteger)getEmotionNeedPageNum {
    NSInteger section = self.functionsArr.count / [self itemCount2Section];
    return section;
}

- (NSInteger)itemCount2Section {
    NSInteger row = 4;//(kScreenWidth - functionLineSpacing) / (functionCellWidth + functionLineSpacing);
    return functionLineNum * row;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageControlValueChangeForFunction:)]) {
        CGPoint offset = scrollView.contentOffset;
        NSInteger currentPage = (offset.x + scrollView.frame.size.width - 1) / scrollView.frame.size.width;
        [self.delegate pageControlValueChangeForFunction:currentPage];
    }
}

#pragma mark - collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self isEmptyEmotionData] == NO)
        return [self getEmotionNeedPageNum];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self isEmptyEmotionData] == NO)
        return [self itemCount2Section];
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatFunctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"functionCell" forIndexPath:indexPath];
    NSInteger index = indexPath.item + indexPath.section * [self itemCount2Section];
    PlusFunctionInfo *info = [self.functionsArr objectAtIndex:index];
    [cell updateInfo:info.imgName withFunctionName:info.name withButtonValue:info.value];
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(functionCellWidth, functionCellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(functionHeaderOrFooterSpacing, self.collectionViewFunctionHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(functionHeaderOrFooterSpacing, self.collectionViewFunctionHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    NSInteger row = [self itemCount2Section] / functionLineNum;
    return (kScreenWidth - row*functionCellWidth - functionHeaderOrFooterSpacing*2) / (row - 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return functionItemSpacing;
}

@end
