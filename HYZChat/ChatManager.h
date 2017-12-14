//
//  ChatManager.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/10/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

static const CGFloat chatAnimateDuration = 0.3f;

@interface ChatManager : NSObject
/** 聊天视图的底部对象 */
@property (assign, nonatomic) ChatBottomTarget bottomMode;
/** 表情文本集合 */
@property (strong, nonatomic) NSMutableDictionary *emotionTextDict;

//单例模式
+ (instancetype)sharedManager;

@end
