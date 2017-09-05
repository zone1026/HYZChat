//
//  ChatEmotionData.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger emotionLineNum = 3;
static const NSInteger emotionLineSpacing = 7;
static const NSInteger emotionItemSpacing = 12;
static const NSInteger emotionCellWidth = 28 + 4 + 4;
static const NSInteger emotionCellTopSpacing = 22;
static const NSInteger emotionCollectionView2EmotionTabSpacing = 37;

@protocol ChatEmotionDataDelegate <NSObject>
@required
- (void)pageControlValueChangeForEmotion:(NSInteger)pageNum;

@optional

@end

@interface ChatEmotionData : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) id <ChatEmotionDataDelegate> delegate;
@property (assign, nonatomic) NSInteger emotionPageNum;
@property (assign, nonatomic) CGFloat collectionViewEmotionHeight;

/**
 * @description 解析表情plist数据
 */
- (void)parseEmotionsPlistData;

@end
