//
//  RichLabel.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "RichLabel.h"

@interface RichLabel ()
/** 布局管理者 */
@property (strong, nonatomic) NSLayoutManager *layoutManager;
/** 文本容器 */
@property (strong, nonatomic) NSTextContainer *textContainer;
/** 文本存储 */
@property (strong, nonatomic) NSTextStorage *textStorage;
/** 文本中有关链接的位置集合 */
@property (copy, nonatomic) NSArray *linkRanges;
/** touch过程中是否移动 */
@property (assign, nonatomic) BOOL isTouchMoved;
@end

@implementation RichLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self setupTextSystem];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self setupTextSystem];
    
    return self;
}

#pragma mark - setter function

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.textContainer.size = self.bounds.size;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.textContainer.size = self.bounds.size;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    [super setNumberOfLines:numberOfLines];
    self.textContainer.maximumNumberOfLines = numberOfLines;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:[self attributesFromProperties]];
    [self updateTextStoreWithAttributedString:attributedText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    [mutableAttributeString addAttributes:[self attributesFromProperties] range:NSMakeRange(0, mutableAttributeString.length)];
    [self updateTextStoreWithAttributedString:mutableAttributeString];
}

- (void)setAutomaticLinkDetectionEnabled:(BOOL)decorating {
    _automaticLinkDetectionEnabled = decorating;
    [self updateTextStoreWithText];
}

- (void)setLinkDetectionTypes:(LinkDetectionTypes)linkDetectionTypes {
    _linkDetectionTypes = linkDetectionTypes;
    [self updateTextStoreWithText];
}

- (void)setLinkColor:(UIColor *)linkColor {
    _linkColor = linkColor;
    [self updateTextStoreWithText];
}

- (void)setLinkBackgroundColor:(UIColor *)linkBackgroundColor {
    _linkBackgroundColor = linkBackgroundColor;
    [self updateTextStoreWithText];
}

- (void)setLinkHighlightColor:(UIColor *)linkHighlightColor {
    _linkHighlightColor = linkHighlightColor;
    [self updateTextStoreWithText];
}

#pragma mark - layout subview

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainer.size = self.bounds.size;
}

- (void)setupTextSystem {
    self.textContainer = [[NSTextContainer alloc] init];
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = 0;
    self.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textContainer.size = self.frame.size;
    
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.layoutManager.delegate = self;
    [self.layoutManager addTextContainer:self.textContainer];
    
    [self.textContainer setLayoutManager:self.layoutManager];
    
    self.userInteractionEnabled = YES;
    
    _automaticLinkDetectionEnabled = YES;
    
    _linkDetectionTypes = LinkDetectionTypeAll;
    
    _linkColor = [UIColor colorWithRed:0.0f green:0.6f blue:1.0f alpha:1.0f];
    _linkHighlightColor = [UIColor colorWithRed:0.0f green:0.6f blue:1.0f alpha:1.0f];
    _linkBackgroundColor = [UIColor colorWithRed:108.0f/255.0f green:206.0f/255.0f blue:64.0f/255.0f alpha:1.0f];;
    
    [self updateTextStoreWithText];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressLabel:)];
    longPressGesture.cancelsTouchesInView = YES;
    longPressGesture.minimumPressDuration = 0.5f;//设置长按时间，默认0.5秒
    [self addGestureRecognizer:longPressGesture];
    
    //默认的回调
    self.linkTapHandler = ^(LinkType linkType, NSString *string, NSRange range) {
    };
    self.linkLongHandler = ^(LinkType linkType, NSString *string, NSRange range, CGPoint touchPoint){
    };
}

/*
 * linkType : 链接类型
 * range    : 链接区域
 * link     : 链接文本
 */
- (NSDictionary *)getLinkAtLocation:(CGPoint)location {
    // Do nothing if we have no text
    if (self.textStorage.string.length == 0)
        return nil;
    
    // Work out the offset of the text in the view
    CGPoint textOffset;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self calcTextOffsetForGlyphRange:glyphRange];
    
    // Get the touch location and use text offset to convert to text cotainer coords
    location.x -= textOffset.x;
    location.y -= textOffset.y;
    
    NSUInteger touchedChar = [self.layoutManager glyphIndexForPoint:location inTextContainer:self.textContainer];
    
    // If the touch is in white space after the last glyph on the line we don't
    // count it as a hit on the text
    NSRange lineRange;
    CGRect lineRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:touchedChar effectiveRange:&lineRange];
    if (CGRectContainsPoint(lineRect, location) == NO) {//触摸区域没有信息
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(LinkTypeNormal), @"linkType",@"",@"link",nil];
        return dict;
    }
    
    // Find the word that was touched and call the detection block
    for (NSDictionary *dictionary in self.linkRanges) {
        NSRange range = [[dictionary objectForKey:@"range"] rangeValue];
        
        if ((touchedChar >= range.location) && touchedChar < (range.location + range.length))
            return dictionary;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(LinkTypeNormal), @"linkType",@"",@"link",nil];
    return dict;
}

// Applies background colour to selected range. Used to hilight touched links
- (void)setSelectedRange:(NSRange)range {
    //删除之前选中的链接属性
    if (self.selectedRange.length && !NSEqualRanges(self.selectedRange, range)) {
        [self.textStorage removeAttribute:NSBackgroundColorAttributeName
                                    range:self.selectedRange];
//        [self.textStorage addAttribute:NSForegroundColorAttributeName
//                                 value:self.linkColor
//                                 range:self.selectedRange];
    }
    
    //选中链接绘制新颜色
    if (range.length) {
        [self.textStorage addAttribute:NSBackgroundColorAttributeName
                                 value:self.linkBackgroundColor
                                 range:range];
//        [self.textStorage addAttribute:NSForegroundColorAttributeName
//                                 value:self.linkHighlightColor
//                                 range:range];
    }
    _selectedRange = range;
    [self setNeedsDisplay];
}

- (void)updateTextStoreWithText {
    if (self.attributedText != nil) {
        NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [mutableAttributeString addAttributes:[self attributesFromProperties] range:NSMakeRange(0, mutableAttributeString.length)];
        [self updateTextStoreWithAttributedString:mutableAttributeString];
    }
    else if (self.text != nil)
        [self updateTextStoreWithAttributedString:[[NSAttributedString alloc] initWithString:self.text attributes:[self attributesFromProperties]]];
    else
        [self updateTextStoreWithAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:[self attributesFromProperties]]];

    [self setNeedsDisplay];
}

- (void)updateTextStoreWithAttributedString:(NSAttributedString *)attributedString {
    if (attributedString.length != 0)
        attributedString = [self sanitizeAttributedString:attributedString];
    
    if (self.isAutomaticLinkDetectionEnabled && (attributedString.length != 0)) {
        //获取所有类型的链接
        self.linkRanges = [self getRangesForLinks:attributedString];
        //对所有连接添加链接属性
        attributedString = [self addLinkAttributesToAttributedString:attributedString linkRanges:self.linkRanges];
    } else
        self.linkRanges = nil;
    
    if (self.textStorage != nil)
        [self.textStorage setAttributedString:attributedString];
    else {
        self.textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
        [self.textStorage addLayoutManager:self.layoutManager];
        [self.layoutManager setTextStorage:self.textStorage];
    }
}

/*
 * 链接文本属性
 */
- (NSAttributedString *)addLinkAttributesToAttributedString:(NSAttributedString *)string linkRanges:(NSArray *)linkRanges {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : self.linkColor};
    
    for (NSDictionary *dictionary in linkRanges) {
        NSRange range = [[dictionary objectForKey:@"range"] rangeValue];
        [attributedString addAttributes:attributes range:range];
    }
    return attributedString;
}

/*
 * 普通文本属性
 */
- (NSDictionary *)attributesFromProperties {
    //阴影属性
    NSShadow *shadow = [[NSShadow alloc] init];
    if (self.shadowColor != nil){
        shadow.shadowColor = self.shadowColor;
        shadow.shadowOffset = self.shadowOffset;
    } else {
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowColor = nil;
    }
    
    //颜色属性
    UIColor *color = self.textColor;
    if (!self.isEnabled)
        color = [UIColor lightGrayColor];
    else if (self.isHighlighted)
        color = self.highlightedTextColor;
    
    //段落属性
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = self.textAlignment;
    paragraph.lineSpacing = 3.0;
    
    //属性字典
    NSDictionary *attributes = @{
                                 NSFontAttributeName : self.font,
                                 NSForegroundColorAttributeName : color,
                                 NSShadowAttributeName : shadow,
                                 NSParagraphStyleAttributeName : paragraph
                                 };
    return attributes;
}

/*
 * 修正换行模式
 */
- (NSAttributedString *)sanitizeAttributedString:(NSAttributedString *)attributedString {
    NSRange range;
    NSParagraphStyle *paragraphStyle = [attributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&range];
    
    if (paragraphStyle == nil)
        return attributedString;
    
    // Remove the line breaks
    NSMutableParagraphStyle *mutableParagraphStyle = [paragraphStyle mutableCopy];
    mutableParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Apply new style
    NSMutableAttributedString *restyled = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [restyled addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle range:NSMakeRange(0, restyled.length)];
    
    return restyled;
}

/*
 * 可扩展部分,不同的Link类型
 */
- (NSArray *)getRangesForLinks:(NSAttributedString *)text {
    NSMutableArray *rangesForLinks = [[NSMutableArray alloc] init];
    //用户昵称
    if (self.linkDetectionTypes & LinkDetectionTypeUserHandle) {
        //        [rangesForLinks addObjectsFromArray:[self getRangesForUserHandles:text.string]];
    }
    //内容标签
    if (self.linkDetectionTypes & LinkDetectionTypeHashTag) {
        //        [rangesForLinks addObjectsFromArray:[self getRangesForHashTags:text.string]];
    }
    //链接地址
    if (self.linkDetectionTypes & LinkDetectionTypeURL)
        [rangesForLinks addObjectsFromArray:[self getRangesForURLs:self.attributedText]];

    //电话号码
    if (self.linkDetectionTypes & LinkDetectionTypePhoneNumber)
        [rangesForLinks addObjectsFromArray:[self getRangesForPhoneNumbers:text.string]];
    
    //......
    
    return rangesForLinks;
}

/*
 * 所有用户昵称
 */
- (NSArray *)getRangesForUserHandles:(NSString *)text {
    NSMutableArray *rangesForUserHandles = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(?<!\\w)@([\\w\\_]+)?"
                                                                      options:0
                                                                        error:&error];
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        NSString *matchString = [text substringWithRange:matchRange];
        
        [rangesForUserHandles addObject:@{
                                          @"linkType" : @(LinkTypeUserHandle),
                                          @"range"    : [NSValue valueWithRange:matchRange],
                                          @"link"     : matchString
                                          }];
    }
    return rangesForUserHandles;
}

/*
 * 所有内容标签
 */
- (NSArray *)getRangesForHashTags:(NSString *)text {
    NSMutableArray *rangesForHashTags = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(?<!\\w)#([\\w\\_]+)?"
                                                                      options:0
                                                                        error:&error];
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        NSString *matchString = [text substringWithRange:matchRange];
        
        [rangesForHashTags addObject:@{
                                       @"linkType" : @(LinkTypeHashTag),
                                       @"range"    : [NSValue valueWithRange:matchRange],
                                       @"link"     : matchString
                                       }];
    }
    return rangesForHashTags;
}

/*
 * 所有链接地址
 */
- (NSArray *)getRangesForURLs:(NSAttributedString *)text {
    NSMutableArray *rangesForURLs = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:&error];
    
    NSString *plainText = text.string;
    NSArray *matches = [detector matchesInString:plainText
                                         options:0
                                           range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        
        NSString *realURL = [text attribute:NSLinkAttributeName
                                    atIndex:matchRange.location
                             effectiveRange:nil];
        if (realURL == nil)
            realURL = [plainText substringWithRange:matchRange];
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            [rangesForURLs addObject:@{
                                       @"linkType" : @(LinkTypeURL),
                                       @"range"    : [NSValue valueWithRange:matchRange],
                                       @"link"     : realURL
                                       }];
        }
    }
    return rangesForURLs;
}

/*
 * 所有电话号码
 */
- (NSArray *)getRangesForPhoneNumbers:(NSString *)text
{
    NSMutableArray *rangesForPhoneNumbers = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSArray *matches = [detector matchesInString:text
                                         options:0
                                           range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        NSString *matchString = [text substringWithRange:matchRange];
        
        if ([match resultType] == NSTextCheckingTypePhoneNumber) {
            [rangesForPhoneNumbers addObject:@{
                                               @"linkType" : @(LinkTypePhoneNumber),
                                               @"range"    : [NSValue valueWithRange:matchRange],
                                               @"link"     : matchString
                                               }];
        }
    }
    return rangesForPhoneNumbers;
}

#pragma mark - Layout and Rendering
/*
 * 绘制文本相关方法
 */
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    // Use our text container to calculate the bounds required. First save our
    // current text container setup
    CGSize savedTextContainerSize = self.textContainer.size;
    NSInteger savedTextContainerNumberOfLines = self.textContainer.maximumNumberOfLines;
    
    // Apply the new potential bounds and number of lines
    self.textContainer.size = bounds.size;
    self.textContainer.maximumNumberOfLines = numberOfLines;
    
    // Measure the text with the new state
    CGRect textBounds;
    @try
    {
        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
        textBounds = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
        
        // Position the bounds and round up the size for good measure
        textBounds.origin = bounds.origin;
        textBounds.size.width = ceilf(textBounds.size.width);
        textBounds.size.height = ceilf(textBounds.size.height);
    }
    @finally
    {
        // Restore the old container state before we exit under any circumstances
        self.textContainer.size = savedTextContainerSize;
        self.textContainer.maximumNumberOfLines = savedTextContainerNumberOfLines;
    }
    return textBounds;
}

- (void)drawTextInRect:(CGRect)rect {
    // Don't call super implementation. Might want to uncomment this out when
    // debugging layout and rendering problems.
    //        [super drawTextInRect:rect];
    
    // Calculate the offset of the text in the view
    CGPoint textOffset;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self calcTextOffsetForGlyphRange:glyphRange];
    
    // Drawing code
    [self.layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
    [self.layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
}

// Returns the XY offset of the range of glyphs from the view's origin
- (CGPoint)calcTextOffsetForGlyphRange:(NSRange)glyphRange {
    CGPoint textOffset = CGPointZero;
    
    CGRect textBounds = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
    CGFloat paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2.0f;
    if (paddingHeight > 0)
        textOffset.y = paddingHeight;
    
    return textOffset;
}

#pragma mark - Layout manager delegate

/*
 * 链接是否换行
 */
-(BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByWordBeforeCharacterAtIndex:(NSUInteger)charIndex {
    for (NSDictionary *dictionary in self.linkRanges) {
        NSRange range = [[dictionary objectForKey:@"range"] rangeValue];
        LinkType linkType = [[dictionary objectForKey:@"linkType"] integerValue];
        if (linkType == LinkTypeURL) {
            if ((charIndex > range.location) && charIndex <= (range.location + range.length))
                return NO;
        }
    }
    return YES;
    
    //在链接内的文本不换行
    //    NSRange range;
    //    NSURL *linkURL = [layoutManager.textStorage attribute:NSLinkAttributeName
    //                                                  atIndex:charIndex
    //                                           effectiveRange:&range];
    //
    //    return !(linkURL && (charIndex > range.location) && (charIndex <= NSMaxRange(range)));
}

#pragma mark - Interactions

- (IBAction)longPressLabel:(UILongPressGestureRecognizer *)recognizer
{
    if ((recognizer.view != self) || (recognizer.state != UIGestureRecognizerStateBegan))
        return;
    
    CGPoint location = [recognizer locationInView:self];
    NSDictionary *link = [self getLinkAtLocation:location];
    if (link != nil) {
        NSRange range = [[link objectForKey:@"range"] rangeValue];
        NSString *linkString = [link objectForKey:@"link"];
        LinkType linkType = (LinkType)[[link objectForKey:@"linkType"] intValue];
        self.linkLongHandler(linkType, linkString, range, location);//[recognizer locationInView:self.superview]
        self.selectedRange = NSMakeRange(0, self.text.length);
    }
}

/*
 * 触摸事件
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isTouchMoved = NO;
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    NSDictionary *touchedLink = [self getLinkAtLocation:touchLocation];
    
    if (touchedLink != nil)
        self.selectedRange = [[touchedLink objectForKey:@"range"] rangeValue];
    else
        [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.isTouchMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    //如果拖动手指的话就不识别
    if (self.isTouchMoved) {
        [self cancelSelectedRange];
        return;
    }
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    NSDictionary *touchedLink = [self getLinkAtLocation:touchLocation];
    
    if (touchedLink){
        NSRange range = [[touchedLink objectForKey:@"range"] rangeValue];
        NSString *touchedSubstring = [touchedLink objectForKey:@"link"];
        LinkType linkType = (LinkType)[[touchedLink objectForKey:@"linkType"] intValue];
        
        self.linkTapHandler(linkType, touchedSubstring, range);
    } else
        [super touchesBegan:touches withEvent:event];
    
    [self cancelSelectedRange];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
//    [self cancelSelectedRange];
}

#pragma mark - 私有方法

/** 取消选中区域 */
- (void)cancelSelectedRange {
    __weak typeof (self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        weakSelf.selectedRange = NSMakeRange(0, 0);
    });
}

#pragma mark - 共有方法

- (void)updateTextContent:(NSString *)content {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
    //设置换行模式，表情图标出界自动换行
    [attributes setValuesForKeysWithDictionary:[HYZUtil getWrapModeAttributes]];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0;
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSAttributedString *attributedString = [NSAttributedString attachmentAttributedStringFrom:content attributes:attributes];
    self.attributedText = attributedString;
}

@end
