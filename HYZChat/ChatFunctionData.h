//
//  ChatFunctionData.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/5.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger functionLineNum = 3;
static const NSInteger functionLineSpacing = 7;
static const NSInteger functionItemSpacing = 12;
static const NSInteger functionCellWidth = 28 + 4 + 4;
static const NSInteger functionCellTopSpacing = 22;
static const NSInteger functionColl2BottomSpacing = 37;

@protocol ChatFunctionDataDelegate <NSObject>

@required

@optional

@end

@interface ChatFunctionData : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) id <ChatFunctionDataDelegate> delegate;
@property (assign, nonatomic) NSInteger functionPageNum;
@property (assign, nonatomic) CGFloat collectionViewFunctionHeight;

@end
