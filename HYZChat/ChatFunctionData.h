//
//  ChatFunctionData.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger functionLineNum = 2;
static const NSInteger functionHeaderOrFooterSpacing = 20;
static const NSInteger functionItemSpacing = 1;
static const NSInteger functionCellWidth = 70;
static const NSInteger functionCellHeight = 90;

@protocol ChatFunctionDataDelegate <NSObject>

@required
- (void)pageControlValueChangeForFunction:(NSInteger)pageNum;

@optional

@end

@interface ChatFunctionData : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) id <ChatFunctionDataDelegate> delegate;
@property (assign, nonatomic) NSInteger functionPageNum;
@property (assign, nonatomic) CGFloat collectionViewFunctionHeight;

/**
 * @description 解析功能按钮plist数据
 */
- (void)parseFunctionsPlistData;

@end
