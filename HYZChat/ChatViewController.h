//
//  ChatViewController.h
//  HyzChat
//
//  Created by 黄亚州 on 2017/8/31.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatMessageAttribute;
@interface ChatViewController : UIViewController
/**
 * @description 添加消息内容配置，比如：本文的颜色、消息的背景色等
 */
- (void)addChatMessageAttribute:(ChatMessageAttribute *)attribute;

@end
