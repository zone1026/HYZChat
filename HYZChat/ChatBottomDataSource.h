//
//  ChatBottomDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

static const CGFloat textViewMaxHeight = 88.0;

@protocol ChatBottomDataSourceDelegate <NSObject>

@required
/**
 * @description 更新顶部视图的高度
 * @param height 高度
 */
- (void)updateTopViewHeight:(CGFloat)height;
/**
 * @description 发送消息
 * @param content 发送内容
 */
- (void)sendChatMessage:(NSString *)content;

@optional

@end

@interface ChatBottomDataSource : NSObject <UITextViewDelegate>
/** 是否在尾部进行的输入 */
@property (assign, nonatomic) BOOL endLocationInput;
/** 聊天底部代理 */
@property (weak, nonatomic) id <ChatBottomDataSourceDelegate> delegate;
/**
 * @description 通过表情描述文本改变输入文本的内容
 * @param textView 输入框
 */
- (void)textChangedByEmotionStr:(UITextView *)textView;

@end
