//
//  NSAttributedString+TextAttachment.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "NSAttributedString+TextAttachment.h"

@implementation HHTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    return CGRectMake(0, -5, 20, 20);
}

@end

@implementation NSAttributedString (TextAttachment)

- (CGRect)boundsWithSize:(CGSize)size {
    CGRect contentRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];//NSStringDrawingUsesLineFragmentOrigin
    return contentRect;
}

+ (NSString *)getAttachmentInfoByAttachmentDesc:(NSString *)desc {
    NSMutableDictionary *attachmentDict = [ChatManager sharedManager].emotionTextDict;
    if (attachmentDict == nil)
        return nil;
    return [attachmentDict objectForKey:desc];
}

+ (CGRect)boundsForString:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attrs {
    NSAttributedString *attributedString = [NSAttributedString attachmentAttributedStringFrom:string attributes:attrs];
    CGRect contentRect = [attributedString boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading context:nil];
    return contentRect;
}

/*
 * 返回Emotion替换过的 NSAttributedString
 */
+ (NSAttributedString *)attachmentAttributedStringFrom:(NSString *)string attributes:(NSDictionary *)attrs {
    NSMutableAttributedString *attributedEmotionString = [[NSMutableAttributedString alloc] initWithString:string attributes:attrs];
    
    NSArray *attachmentArray = [NSAttributedString attachmentsForAttributedString:attributedEmotionString];
    for (HHTextAttachment *attachment in attachmentArray)
    {
        NSAttributedString *emotionAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedEmotionString replaceCharactersInRange:attachment.range withAttributedString:emotionAttachmentString];
    }
    return attributedEmotionString;
}

/*
 * 查找所有表情文本并替换
 */
+ (NSArray *)attachmentsForAttributedString:(NSMutableAttributedString *)attributedString {
    NSString *markL       = attachmentMarkLeft;
    NSString *markR       = attachmentMarkRight;
    NSString *string      = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < string.length; i++)
    {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
        {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
            {
                [stack removeAllObjects];
            }
            
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == string.length - 1))
            {
                NSMutableString *attachmentDesc = [[NSMutableString alloc] init];
                for (NSString *c in stack)
                {
                    [attachmentDesc appendString:c];
                }
                NSString *imageName = [self getAttachmentInfoByAttachmentDesc:attachmentDesc];
                if ([HYZUtil isEmptyOrNull:imageName] == NO) {
                    NSRange range = NSMakeRange(i + 1 - attachmentDesc.length, attachmentDesc.length);

                    [attributedString replaceCharactersInRange:range withString:@" "];
                    HHTextAttachment *attachment = [[HHTextAttachment alloc] initWithData:nil ofType:nil];
                    attachment.range = NSMakeRange(i + 1 - attachmentDesc.length, 1);
                    attachment.image = [UIImage imageNamed:imageName];

                    i -= ([stack count] - 1);
                    [array addObject:attachment];
                }
                [stack removeAllObjects];
            }
        }
    }
    return array;
}

@end
