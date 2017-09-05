//
//  ChatBottomDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol ChatBottomDataSourceDelegate <NSObject>

@required
- (void)updateTopViewHeight:(CGFloat)height;
- (void)sendChatMessage:(NSString *)content;

@optional

@end

@interface ChatBottomDataSource : NSObject <UITextViewDelegate>
@property (assign, nonatomic) BOOL endLocationInput;
@property (assign, nonatomic) ChatTextViewCurrentInputTarget target;
@property (weak, nonatomic) id <ChatBottomDataSourceDelegate> delegate;
@property (assign, nonatomic) NSInteger selectedEmotionTab;

@end
