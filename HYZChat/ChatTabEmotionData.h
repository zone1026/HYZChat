//
//  ChatTabEmotionData.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger emotionTabCellWidth = 22 + 8 + 8;

@protocol ChatTabEmotionDataDelegate <NSObject>
@required
- (void)openEmotionTab:(NSInteger)tab withEmotionTabValue:(NSString *)tabValue;

@optional

@end

@interface ChatTabEmotionData : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) id <ChatTabEmotionDataDelegate>delegate;
@end
