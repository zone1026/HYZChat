//
//  RichLabel.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+TextAttachment.h"

// 链接类型
typedef NS_ENUM(NSInteger, LinkType)
{
    LinkTypeNormal,         // 普通文本,用于全文复制 eg:
    LinkTypeUserHandle,     //用户昵称  eg: @kingzwt
    LinkTypeHashTag,        //内容标签  eg: #hello
    LinkTypeURL,            //链接地址  eg: http://www.baidu.com
    LinkTypePhoneNumber     //电话号码  eg: 13888888888
};

// 可用于识别的链接类型
typedef NS_OPTIONS(NSUInteger, LinkDetectionTypes)
{
    LinkDetectionTypeUserHandle  = (1 << 0),
    LinkDetectionTypeHashTag     = (1 << 1),
    LinkDetectionTypeURL         = (1 << 2),
    LinkDetectionTypePhoneNumber = (1 << 3),
    
    LinkDetectionTypeNone        = 0,
    LinkDetectionTypeAll         = NSUIntegerMax
};

typedef void (^LinkHandler)(LinkType linkType, NSString *string, NSRange range);
typedef void (^LinkLongHandler)(LinkType linkType, NSString *string, NSRange range, CGPoint touchPoint);

@interface RichLabel : UILabel <NSLayoutManagerDelegate>

@property (assign, getter = isAutomaticLinkDetectionEnabled, nonatomic) BOOL automaticLinkDetectionEnabled;

@property (strong, nonatomic) UIColor *linkColor;

@property (strong, nonatomic) UIColor *linkHighlightColor;

@property (strong, nonatomic) UIColor *linkBackgroundColor;

@property (assign, nonatomic) LinkDetectionTypes linkDetectionTypes;

@property (copy, nonatomic) LinkHandler linkTapHandler;

@property (copy, nonatomic) LinkLongHandler linkLongHandler;

/**
 * @description 更新文本内容
 * @param content 文本内容
 */
- (void)updateTextContent:(NSString *)content;

@end
