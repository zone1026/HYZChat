//
//  ChatBottomDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatBottomDataSource.h"
#import "UIView+HYZFrame.h"
#import "ChatManager.h"

@interface ChatBottomDataSource ()

@end

@implementation ChatBottomDataSource

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - function


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
    if (textView.markedTextRange != nil) {//中文输入法输入的内容
        UITextPosition *beginning = textView.beginningOfDocument;
        NSInteger endLocation = [textView offsetFromPosition:beginning toPosition:textView.markedTextRange.end];
        if (endLocation == textView.text.length) {
            needScrollToLastLine = YES;
        }
    }
    else {
        if (ChatBottomTargetEmotion == [ChatManager sharedManager].bottomMode) {
            needScrollToLastLine = self.endLocationInput;
        }
        else if (ChatBottomTargetText == [ChatManager sharedManager].bottomMode)
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

#pragma mark - 公开方法

- (void)textChangedByEmotionStr:(UITextView *)textView {
    [self textViewDidChange:textView];
}
@end
