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

////////////////////////////////// 共有控件 //////////////////////////////////

/** 用户头像imageView */
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
/** 用户昵称label */
@property (weak, nonatomic) IBOutlet UILabel *lblNick;
/** 消息内容视图 */
@property (weak, nonatomic) IBOutlet UIView *viewMsgContent;
/** cell勾选框 */
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;

////////////////////////////////// 共有约束 //////////////////////////////////

/** 昵称label的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblNickConstraintHeight;
/** 其他人（不是自己的）的头像的左间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLogoConstraintLeft;

////////////////////////////////// 共有属性 //////////////////////////////////

/** 是否处于多选模式下 */
@property (assign, nonatomic) BOOL multiChoiceMode;
/** 是否是我发送的 */
@property (assign, nonatomic) BOOL isMeSend;
/** 单元格数据源 */
@property (strong, nonatomic) CNChatMessage *cellData;

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
/**
 * @description 配置Cell的菜单
 */
- (NSArray *)configCellMenu;

@end
