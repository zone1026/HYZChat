//
//  ChatBottomDataSource.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatBottomDataSource.h"
#import "UIView+HYZFrame.h"


static const CGFloat textViewMaxHeight = 88.0;

@interface ChatBottomDataSource ()

@end

@implementation ChatBottomDataSource

- (instancetype)init {
    if (self = [super init]) {
        self.target = ChatTextViewCurrentInputTargetText;
        self.selectedEmotionTab = 0;
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
