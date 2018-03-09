//
//  HYZUtil.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "HYZUtil.h"
#import <CoreText/CoreText.h>
#import "NSDate+Calendar.h"

@implementation HYZUtil

#pragma mark - /// 时间相关静态方法 ///

+ (NSTimeInterval)getCurrentTimestamp {
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return timestamp;
}

+ (NSDate *)dateFromStr:(NSString *)str withFormatterStr:(NSString *)fStr {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = fStr;
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date = [df dateFromString:str];
    if (nil == date)
        NSLog(@"dateFromStr 参数格式不对！！");
    return date;
}

+ (NSString *)dateStringByDate:(NSDate *)date {
    return [self dateStringByDate:date withFormatterStr:@"yyyy-MM-dd"];
}

+ (NSString *)dateStringByDate:(NSDate *)date withFormatterStr:(NSString *)fStr {
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:fStr];
    NSString* timeString = [formatter stringFromDate:date];
    return timeString;
}

+ (NSString *)timeStringByDate:(NSDate *)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeString = [formatter stringFromDate:date];
    return timeString;
}

+ (NSString *)timeStampFormatDesc:(CGFloat)timeStamp {
    if (timeStamp <= 0)
        return @"未知";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];

    NSDate *timeStampDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString *timeStampDateStr = [self dateStringByDate:timeStampDate];
    timeStampDate = [formatter dateFromString:timeStampDateStr];//日期
    
    NSDate *todayDate = [formatter dateFromString:[self dateStringByDate:[NSDate date]]];//今天
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//公历日历
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour
                                               fromDate:timeStampDate toDate:todayDate options:0];
    NSInteger day = [components day];//两个之间相差几天。以小时为单位计算的
    
    if (day >= 7) //超出一周
        return [self dateStringByDate:timeStampDate withFormatterStr:@"yyyy/M/dd"];
    else if (day > 1 && day < 7) //星期几
        return [NSDate weekStringFromNumber:[timeStampDate weekValueForDate]];
    else if (1 == day)//昨天的
        return @"昨天";
    
    //今天的
    timeStampDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:timeStampDate];
}

#pragma mark - /// 其他相关静态方法 ///

+ (BOOL)isEmptyOrNull:(NSString *)str {
    if (!str) // null object
        return YES;
    else
    {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([trimedString length] == 0)
            // empty string
            return YES;
        else if ([trimedString isEqualToString:@"null"])
            // is neither empty nor null
            return YES;
        else if ([trimedString isEqualToString:@"(null)"])
            // is neither empty nor null
            return YES;
        else if ([trimedString isEqualToString:@"<null>"])
            // is neither empty nor null
            return YES;
        else
            return NO;
    }
}

+ (id)getPlistData:(NSString *)key inFile:(NSString *)filename {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:filename ofType:@"plist"];
    return [[[NSDictionary alloc] initWithContentsOfFile:plistPath] objectForKey:key];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGSize)autoFitSizeOfStr:(NSString *)str withWidth:(CGFloat)width withFont:(UIFont *)font {
    if (nil == str) {
        str = @" ";
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(width, 0.0f) options:NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    textSize.height = ceil(textSize.height);
    textSize.width = ceil(textSize.width);
    return textSize;
}

+ (NSString *)getUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(NSString*)CFBridgingRelease(uuid_string_ref)];
    return uuid;
}

+ (NSDictionary *)getWrapModeAttributes {
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting settings[] = {
        lineBreakMode
    };
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    
    CFRelease(style);
    return attributes;
}

// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentWindowViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

// 获取根视图
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController])
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    
    if ([rootVC isKindOfClass:[UITabBarController class]])
    {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }
    else
    {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    if ([mobileNum length] != 11) //不为11位 不是手机号
        return NO;
    
    //运用正则匹配
    NSString *patternStr = [NSString stringWithFormat:@"^(0?1[34578]\\d{9})$|^((0(10|2[1-3]|[3-9]\\d{2}))?[1-9]\\d{6,7})$"];
    NSRegularExpression *regularexpression=[[NSRegularExpression alloc]initWithPattern:patternStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSUInteger numberOfMatch = [regularexpression numberOfMatchesInString:mobileNum
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, mobileNum.length)];
    if (numberOfMatch > 0)
        return YES;
    return NO;
}

+ (UIViewController *)instantiateViewController:(NSString *)identifier withStoryboardName:(NSString *)name {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

+ (NSString *)chineseCharactersChange2UpperPhoneticize:(NSString *)chineseStr {
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:chineseStr];
    //带声仄；不能注释掉
    if (CFStringTransform((__bridge CFMutableStringRef)mStr, 0,kCFStringTransformMandarinLatin, NO)) {}
    
    if (CFStringTransform((__bridge CFMutableStringRef)mStr, 0,kCFStringTransformStripDiacritics, NO))
        return [mStr uppercaseString]; // bigStr 是转换成功后的拼音
    return mStr;
}

@end
