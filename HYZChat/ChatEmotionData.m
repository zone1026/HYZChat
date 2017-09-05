//
//  ChatEmotionData.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatEmotionData.h"
#import "InputEmotionData.h"
#import "ChatEmotionCell.h"

@interface ChatEmotionData ()
@property (nonatomic, strong) NSMutableArray *emotionsArr;

@end

@implementation ChatEmotionData

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - emotions plist data

- (void)parseEmotionsPlistData {
    NSArray *emotions = [HYZUtil getPlistData:@"Emotions" inFile:@"emotion"];
    if (emotions.count == 0) {
        NSLog(@"plist file not exist !");
    }
    else {
        NSInteger onePageItemCount = [self itemCount2Section];
        NSInteger pageNum = emotions.count / (onePageItemCount - 1) + 1;//-1 代表删除占位
        NSInteger totalNum = pageNum * onePageItemCount;
        NSInteger delPosIndex = onePageItemCount - 1;
        self.emotionPageNum = pageNum;
        self.emotionsArr = [self getEmptyCellData:totalNum];
        NSInteger cellRow = onePageItemCount / emotionLineNum;
        for (NSInteger i = 0; i < totalNum; i++) {
            if (i < (emotions.count + pageNum - 1)) {//最后一页的删除按钮 不用重新赋值，getEmptyCellData已生成
                InputEmotionData *data = [[InputEmotionData alloc] init];
                data.isEmpty = NO;
                if (i % onePageItemCount == delPosIndex) {
                    data.name = @"删除";
                    data.imgName = @"CHT_BTN_DEL_EMOTION";
                }
                else {
                    NSDictionary *dict = [emotions objectAtIndex:i - i / onePageItemCount];
                    data.name = [dict objectForKey:@"value"];
                    data.imgName = [dict objectForKey:@"icon"];
                }
                NSInteger row = i / cellRow;
                NSInteger ind = row + (i % cellRow)*emotionLineNum + (i / onePageItemCount)*(onePageItemCount - emotionLineNum);
                NSLog(@"index == %ld", (long)ind);
                self.emotionsArr[ind] = data;
            }
        }
    }
}

//生成几个空item 数据
- (NSMutableArray *)getEmptyCellData:(NSInteger)num {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < num; i++) {
        InputEmotionData *data = [[InputEmotionData alloc] init];
        if (i == num - 1) {
            data.name = @"删除";
            data.imgName = @"CHT_BTN_DEL_EMOTION";
        }
        else {
            data.name = @"空数据";
            data.imgName = @"empty";
            data.isEmpty = YES;
        }
        [arr addObject:data];
    }
    return arr;
}

- (BOOL)isEmptyEmotionData {
    if (self.emotionsArr == nil || self.emotionsArr.count <= 0)
        return YES;
    
    return NO;
}

- (NSInteger)getEmotionNeedPageNum {
    NSInteger section = self.emotionsArr.count / [self itemCount2Section];
    return section;
}

- (NSInteger)itemCount2Section {
    NSInteger row = (kScreenWidth - emotionLineSpacing * 2 + emotionLineSpacing) / (emotionCellWidth + emotionLineSpacing);
    return emotionLineNum * row;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageControlValueChangeForEmotion:)]) {
        CGPoint offset = scrollView.contentOffset;
        NSInteger currentPage = (offset.x + scrollView.frame.size.width - 1) / scrollView.frame.size.width;
        [self.delegate pageControlValueChangeForEmotion:currentPage];
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
    ChatEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emotionCell" forIndexPath:indexPath];
    NSInteger index = indexPath.item + indexPath.section * [self itemCount2Section];
    InputEmotionData *data = [self.emotionsArr objectAtIndex:index];
    [(ChatEmotionCell *)cell updateInfo:data.imgName];
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(emotionCellWidth, emotionCellWidth);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSInteger row = (kScreenWidth - emotionLineSpacing * 2 + emotionLineSpacing) / (emotionCellWidth + emotionLineSpacing);
    CGFloat width = (kScreenWidth - row*emotionCellWidth - (row - 1)*emotionLineSpacing) / 2;
    return CGSizeMake(width, self.collectionViewEmotionHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    NSInteger row = (kScreenWidth - emotionLineSpacing * 2 + emotionLineSpacing) / (emotionCellWidth + emotionLineSpacing);
    CGFloat width = (kScreenWidth - row*emotionCellWidth - (row - 1)*emotionLineSpacing) / 2;
    return CGSizeMake(width, self.collectionViewEmotionHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return emotionLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return emotionItemSpacing;
}

@end
