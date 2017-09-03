//
//  ChatFunctionDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger emotionRLineNum = 3;
static const NSInteger emotionLineSpacing = 10;
static const NSInteger emotionCellWidth = 24 + 4 + 4;
static const NSInteger emotionCellTopSpace = 15;
static const NSInteger emotionCellBottomSpace = 25;

@protocol ChatFunctionDataSourceDelegate <NSObject>

@required
- (void)updateTopViewHeight:(CGFloat)height;
- (void)sendChatMessage:(NSString *)content;

@optional

@end

@interface ChatFunctionDataSource : NSObject <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (assign, nonatomic) BOOL endLocationInput;
@property (assign, nonatomic) ChatTextViewCurrentInputTarget target;
@property (weak, nonatomic) id <ChatFunctionDataSourceDelegate> delegate;
@property (assign, nonatomic) NSInteger emotionPageNum;
@property (assign, nonatomic) CGFloat collectionViewEmotionHeight;

/**
 * @description 解析表情plist数据
 */
- (void)parseEmotionsPlistData;

@end
