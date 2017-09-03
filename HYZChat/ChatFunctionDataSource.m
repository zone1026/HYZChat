//
//  ChatFunctionDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatFunctionDataSource.h"
#import "UIView+HYZFrame.h"
#import "InputEmotionData.h"
#import "ChatEmotionCell.h"

static const CGFloat textViewMaxHeight = 88.0;

@interface ChatFunctionDataSource ()
@property (nonatomic, strong) NSMutableArray *emotionsArr;
@end

@implementation ChatFunctionDataSource

- (instancetype)init {
    if (self = [super init]) {
        self.target = ChatTextViewCurrentInputTargetText;
    }
    return self;
}

#pragma mark - function

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
        NSInteger cellRow = onePageItemCount / emotionRLineNum;
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
                NSInteger ind = row + (i % cellRow)*emotionRLineNum + (i / onePageItemCount)*(onePageItemCount - emotionRLineNum);
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
    return emotionRLineNum * row;
}

#pragma mark - collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tag == ChatBottomCollectionViewTagEmotion) {
        if ([self isEmptyEmotionData] == NO)
            return [self getEmotionNeedPageNum];
    }
    else if (collectionView.tag == ChatBottomCollectionViewTagFunction) {
        
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == ChatBottomCollectionViewTagEmotion) {
        if ([self isEmptyEmotionData] == NO)
            return [self itemCount2Section];
    }
    else if (collectionView.tag == ChatBottomCollectionViewTagFunction) {
        
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (collectionView.tag == ChatBottomCollectionViewTagEmotion) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emotionCell" forIndexPath:indexPath];
        if ([cell isKindOfClass:[ChatEmotionCell class]]) {
            InputEmotionData *data = [self.emotionsArr objectAtIndex:indexPath.item];
            [(ChatEmotionCell *)cell updateInfo:data.imgName];
        }
    }
    else if (collectionView.tag == ChatBottomCollectionViewTagFunction) {
        
    }
    
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == ChatBottomCollectionViewTagEmotion) {
        
    }
    else if (collectionView.tag == ChatBottomCollectionViewTagFunction) {
        
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == ChatBottomCollectionViewTagEmotion) {
        return CGSizeMake(emotionCellWidth, emotionCellWidth);
    }
    else if (collectionView.tag == ChatBottomCollectionViewTagFunction) {
        
    }
    return CGSizeMake(30, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView.tag == ChatBottomCollectionViewTagEmotion) {
        NSInteger row = (kScreenWidth - emotionLineSpacing * 2 + emotionLineSpacing) / (emotionCellWidth + emotionLineSpacing);
        CGFloat width = (kScreenWidth - row*emotionCellWidth - (row - 1)*emotionLineSpacing) / 2;
        return CGSizeMake(width, self.collectionViewEmotionHeight);
    }
    else if (collectionView.tag == ChatBottomCollectionViewTagFunction) {
        
    }
    return CGSizeMake(30, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (collectionView.tag == ChatBottomCollectionViewTagEmotion) {
        NSInteger row = (kScreenWidth - emotionLineSpacing * 2 + emotionLineSpacing) / (emotionCellWidth + emotionLineSpacing);
        CGFloat width = (kScreenWidth - row*emotionCellWidth - (row - 1)*emotionLineSpacing) / 2;
        return CGSizeMake(width, self.collectionViewEmotionHeight);
    }
    else if (collectionView.tag == ChatBottomCollectionViewTagFunction) {
        
    }
    return CGSizeMake(30, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == ChatBottomCollectionViewTagEmotion) {
        return emotionLineSpacing;
    }
    else if (collectionView.tag == ChatBottomCollectionViewTagFunction) {
        
    }
    return 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (![HYZUtil isEmptyOrNull:textView.text]) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sendChatMessage:)]) {
                [self.delegate sendChatMessage:textView.text];
            }
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.contentSize.width, CGFLOAT_MAX)];
    if (textView.height != MIN(size.height, textViewMaxHeight)) {
        CGFloat height = MIN(size.height, textViewMaxHeight);
        [textView addHeight:height - textView.height];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateTopViewHeight:)]) {
            [self.delegate updateTopViewHeight:height];
        }
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        textView.scrollEnabled = (size.height > textViewMaxHeight);
    }
    else {
        textView.scrollEnabled = YES;
    }
    BOOL needScrollToLastLine = NO;
    if (textView.markedTextRange) {//中文输入法输入的内容
        UITextPosition *beginning = textView.beginningOfDocument;
        NSInteger endLocation = [textView offsetFromPosition:beginning toPosition:textView.markedTextRange.end];
        if (endLocation == textView.text.length) {
            needScrollToLastLine = YES;
        }
    }
    else {
        if (ChatTextViewCurrentInputTargetEmotion == self.target) {
            needScrollToLastLine = self.endLocationInput;
        }
        else if (ChatTextViewCurrentInputTargetText == self.target)
        {
            if (textView.selectedRange.location >= textView.text.length) {
                needScrollToLastLine = YES;
            }
        }
    }
    if (needScrollToLastLine) {
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 1, 1)];
    }
}

@end
