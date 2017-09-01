//
//  ChatFunctionDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatFunctionDataSourceDelegate <NSObject>

@required
- (void)updateTopViewHeight:(CGFloat)height;
- (void)sendChatMessage:(NSString *)content;

@optional

@end

@interface ChatFunctionDataSource : NSObject <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) ChatTextViewCurrentInputTarget target;
@property (weak, nonatomic) id <ChatFunctionDataSourceDelegate> delegate;

@end
