//
//  ChatFunctionDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatFunctionDataSource.h"
#import "UIView+HYZFrame.h"

static const CGFloat textViewMaxHeight = 88.0;

@interface ChatFunctionDataSource ()

@end

@implementation ChatFunctionDataSource
{
    BOOL endLocationInput;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - collection view data source

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

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(32, 32);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(32, 32);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(32, 32);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
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
            needScrollToLastLine = endLocationInput;
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
