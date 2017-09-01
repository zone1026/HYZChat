//
//  NSAttributedString+TextAttachment.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#warning Change the value if not @"[附件]"
#define attachmentMarkLeft @"["
#define attachmentMarkRight @"]"

@interface HHTextAttachment : NSTextAttachment

@property (assign, nonatomic) NSRange range;

@end

@interface AttachmentInfo : NSObject
//附件名称
@property (copy, nonatomic) NSString *imageName;
//附件描述
@property (copy, nonatomic) NSString *attachmentDesc;

@end

@interface NSAttributedString (TextAttachment)

/*
 * @decriptoin 返回绘制NSAttributedString所需要的区域
 * @param size 尺寸
 */
- (CGRect)boundsWithSize:(CGSize)size;

/*
 * @decriptoin返回文本附件所对应数组 比如：表情数据等
 */
+ (NSArray <AttachmentInfo *>*)textAttachmentStringArray;

+ (AttachmentInfo *)getAttachmentInfoByAttachmentDesc:(NSString *)desc;

/*
 * @decriptoin 返回绘制文本需要的区域
 * @param string 字符串
 * @param size 尺寸
 * @param attrs 文本属性
 */
+ (CGRect)boundsForString:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attrs;

/*
 * @decriptoin 返回文本附件替换过的 NSAttributedString
 * @param string 字符串
 * @param attrs attrs
 */
+ (NSAttributedString *)attachmentAttributedStringFrom:(NSString *)string attributes:(NSDictionary *)attrs;

@end
