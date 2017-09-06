//
//  ChatEmotionController.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatEmotionController.h"
#import "ChatEmotionData.h"
#import "ChatTabEmotionData.h"
#import "UIView+HYZFrame.h"

@interface ChatEmotionController ()<ChatEmotionDataDelegate, ChatTabEmotionDataDelegate>

//chat emotion view
@property (strong, nonatomic) IBOutlet ChatEmotionData *chatEmotionData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewEmotion;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlEmotion;

//chat emotion tab view
@property (strong, nonatomic) IBOutlet ChatTabEmotionData *chatTabEmotionData;
@property (weak, nonatomic) IBOutlet UIView *viewEmotionTab;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEmotion;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewEmotionTab;
@property (weak, nonatomic) IBOutlet UIButton *btnSendEmotoin;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewEmotionTabConstraintHeight;

@end

@implementation ChatEmotionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //chat emotion view
    self.chatEmotionData.delegate = self;
//    self.viewEmotionTabConstraintHeight.constant = 0.0;
    self.chatEmotionData.collectionViewEmotionHeight = self.collectionViewEmotion.height;
    [self.chatEmotionData parseEmotionsPlistData];
    self.pageControlEmotion.numberOfPages = self.chatEmotionData.emotionPageNum;
    self.pageControlEmotion.hidden = self.chatEmotionData.emotionPageNum <= 1;
    [self.collectionViewEmotion reloadData];
    
    //chat emotion tab view
    self.chatTabEmotionData.delegate = self;
    [self.collectionViewEmotionTab reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChatEmotionDataDelegate

- (void)pageControlValueChangeForEmotion:(NSInteger)pageNum {
    self.pageControlEmotion.currentPage = pageNum;
}

#pragma mark - ChatTabEmotionDataDelegate

- (void)openEmotionTab:(NSInteger)tab withEmotionTabValue:(NSString *)tabValue {
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:self.chatEmotionData.selectedEmotionTab inSection:0];
    NSIndexPath *willSelectIndexPath = [NSIndexPath indexPathForItem:tab inSection:0];
    [self.collectionViewEmotionTab reloadItemsAtIndexPaths:@[selectedIndexPath, willSelectIndexPath]];
    self.chatEmotionData.selectedEmotionTab = tab;
#warning update collectionViewEmotion icon
    //    [self.collectionViewEmotion reloadData];
}

@end
