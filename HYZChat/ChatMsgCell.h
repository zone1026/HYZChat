//
//  ChatMsgCell.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/23.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNChatMessage+CoreDataClass.h"

@interface ChatMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblNick;
@property (weak, nonatomic) IBOutlet UIView *viewMsgContent;
@property (weak, nonatomic) IBOutlet UIView *viewArrow;
@property (weak, nonatomic) IBOutlet UIView *viewMsgBg;

/** 是否是我发送的 */
@property (assign, nonatomic) BOOL isMeSend;

/**
 * @description 更新聊天消息内容
 * @param msgData 聊天消息数据
 * @param isMe 是否是自己发送的
 */
- (void)updateMessageData:(CNChatMessage *)msgData withMeMsg:(BOOL)isMe;
/**
 * @description 更新聊天消息内容，不需要指定发送方
 * @param msgData 聊天消息数据
 */
- (void)updateMessageData:(CNChatMessage *)msgData;

@end
