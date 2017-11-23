//
//  ChatMsgCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/23.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatMsgCell.h"

static const CGFloat kDefaultArrowWidth = 22.0;
static const CGFloat kDefaultArrowHeight = 12.0;

@interface ChatMsgCell ()
@property (strong, nonatomic) YZChatMsgObject *msgObject;
@end

@implementation ChatMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewMsgBg.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsMeSend:(BOOL)isMeSend {
    _isMeSend = isMeSend;
    if (isMeSend == YES)
        [self rightArrowView];
    else
        [self leftArrowView];
}

#pragma mark - 共有方法
- (void)updateMessageData:(YZChatMsgObject *)msgData {
    
}

- (void)updateMessageData:(YZChatMsgObject *)msgData withMeMsg:(BOOL)isMe {
    self.msgObject = msgData;
    self.isMeSend = isMe;
    self.imgLogo.image = [UIImage imageNamed:@"DEFAULT_LOGO"];
    self.lblNick.text = self.msgObject.chatMessage.send_nick;
}

#pragma mark - 私有方法

/**
 * @description 左侧气泡箭头
 */
- (void)leftArrowView {
    CGSize size = CGSizeMake(kDefaultArrowWidth, kDefaultArrowHeight);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, size.width / 2.0)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    path.lineWidth = 1.0;
    
    CAShapeLayer *arrowLayer = [CAShapeLayer layer];
    arrowLayer.path = path.CGPath;
    self.viewArrow.layer.mask = arrowLayer;
}

/**
 * @description 右侧气泡箭头
 */
- (void)rightArrowView {
    CGSize size = CGSizeMake(kDefaultArrowWidth, kDefaultArrowHeight);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(size.width / 2.0, size.height)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    path.lineWidth = 1.0;
    
    CAShapeLayer *arrowLayer = [CAShapeLayer layer];
    arrowLayer.path = path.CGPath;
    self.viewArrow.layer.mask = arrowLayer;
}

@end
