//
//  ChatFunctionDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger emotionLineNum = 3;
static const NSInteger emotionLineSpacing = 7;
static const NSInteger emotionItemSpacing = 12;
static const NSInteger emotionCellWidth = 28 + 4 + 4;
static const NSInteger emotionCellTopSpace = 15;
static const NSInteger emotionCellBottomSpace = 26;

@protocol ChatFunctionDataSourceDelegate <NSObject>

@required
- (void)updateTopViewHeight:(CGFloat)height;
- (void)sendChatMessage:(NSString *)content;
- (void)pageControlValueChange:(NSInteger)pageNum withCollectionViewTag:(ChatBottomCollectionViewTag)tag;

@optional

@end

@interface ChatFunctionDataSource : NSObject <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
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
