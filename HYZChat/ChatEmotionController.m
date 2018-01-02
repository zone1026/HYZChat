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

- (void)viewWillAppear:(BOOL)animated {
    [self registerMessageNotification];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeMessageNotification];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event

- (IBAction)btnAddEmotionTouchUpInside:(UIButton *)sender {
    
}

- (IBAction)btnSendEmotoinTouchUpInside:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiSendMsgByEmotionBtnSend object:nil];
    [self updateSendButtonState:NO];
}

#pragma mark - message notification

/** 注册消息通知 */
- (void)registerMessageNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiUpdateBottomEmotionBtnSend:)
                                                 name:NotiUpdateBottomEmotionBtnSend object:nil];
}

/** 移除消息通知 */
- (void)removeMessageNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiUpdateBottomEmotionBtnSend object:nil];
}

- (void)handleNotiUpdateBottomEmotionBtnSend:(NSNotification *)notifcation {
    if (notifcation.object != nil) {
        BOOL btnEnable = [notifcation.object boolValue];
        [self updateSendButtonState:btnEnable];
    }
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

#pragma mark - 私有方法
/**
 * @description 更新发送按钮的状态
 * @param btnEnable 是否可点击
 */
- (void)updateSendButtonState:(BOOL)btnEnable {
    self.btnSendEmotoin.enabled = btnEnable;
    [self.btnSendEmotoin setBackgroundColor:(btnEnable == YES ? [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] :
                                             RGB_COLOR(250.0f, 250.0f, 250.0f))];
    [self.btnSendEmotoin setTitleColor:(btnEnable == YES ? [UIColor whiteColor] :
                                        [UIColor colorWithWhite:0.5f alpha:1.0f]) forState:UIControlStateNormal];
}

@end
