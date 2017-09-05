//
//  ChatBottomController.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatBottomController.h"
#import "ChatBottomDataSource.h"
#import "CALayer+HYZUtil.h"
#import "UIView+HYZFrame.h"
#import "InputViewFrameChanageData.h"
#import "ChatEmotionData.h"
#import "ChatTabEmotionData.h"
#import "ChatFunctionData.h"

@interface ChatBottomController ()<ChatBottomDataSourceDelegate , ChatEmotionDataDelegate, ChatTabEmotionDataDelegate>
@property (strong, nonatomic) IBOutlet ChatBottomDataSource *chatBottomData;

//chat top input view
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraintHeight;

//chat emotion view
@property (strong, nonatomic) IBOutlet ChatEmotionData *chatEmotionData;
@property (weak, nonatomic) IBOutlet UIView *viewEmotion;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewEmotion;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlEmotion;

//chat emotion tab view
@property (strong, nonatomic) IBOutlet ChatTabEmotionData *chatTabEmotionData;
@property (weak, nonatomic) IBOutlet UIView *viewEmotionTab;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEmotion;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewEmotionTab;
@property (weak, nonatomic) IBOutlet UIButton *btnSendEmotoin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewEmotionTabConstraintHeight;

//chat function view
@property (strong, nonatomic) IBOutlet ChatFunctionData *chatFunctionData;
@property (weak, nonatomic) IBOutlet UIView *viewFunction;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewFunction;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlFunction;

@property (nonatomic) NSRange chatEmotionShouldChangeRange;//表情在输入框将要插入的光标Range

@end

@implementation ChatBottomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //input view
    self.textView.text = @"";
    [self.textView.layer setBorder:0.3 withColor:[UIColor lightGrayColor] withCorner:3.0];
    [self.btnRecord.layer setBorder:0.3 withColor:[UIColor lightGrayColor] withCorner:3.0];
    [self.view layoutIfNeeded];
    self.chatBottomData.delegate = self;
    
    //chat emotion view
    self.chatEmotionData.delegate = self;
    self.viewEmotionTabConstraintHeight.constant = 0.0;
    self.chatEmotionData.collectionViewEmotionHeight = self.collectionViewEmotion.height;
    [self.chatEmotionData parseEmotionsPlistData];
    self.pageControlEmotion.numberOfPages = self.chatEmotionData.emotionPageNum;
    [self.collectionViewEmotion reloadData];
    
    //chat emotion tab view
    self.chatTabEmotionData.delegate = self;
    [self.collectionViewEmotionTab reloadData];
    
    self.viewEmotion.hidden = NO;
    self.viewFunction.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerMessageNotification];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeMessageNotification];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - event

- (IBAction)btnAudioTouchUpInside:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    self.btnRecord.hidden = !sender.isSelected;
    self.textView.hidden = sender.isSelected;
}

- (IBAction)btnEmotionTouchUpInside:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    self.chatBottomData.endLocationInput = (self.textView.selectedRange.location >= self.textView.text.length);
    self.chatEmotionShouldChangeRange = self.textView.selectedRange;
    if (self.chatBottomData.target == ChatTextViewCurrentInputTargetText) {
        self.chatBottomData.target = ChatTextViewCurrentInputTargetEmotion;
        self.viewEmotionTabConstraintHeight.constant = 38.0;
        [self.view endEditing:YES];
        InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
        data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
        data.inputViewHeight = self.viewTopConstraintHeight.constant + (emotionCellTopSpacing + emotionLineNum*emotionCellWidth + (emotionLineNum - 1)*emotionItemSpacing) + emotionCollectionView2EmotionTabSpacing + self.viewEmotionTabConstraintHeight.constant;
        data.isEmotionModel = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于表情的出现 导致整个view的frame变化
    }
    else if (self.chatBottomData.target == ChatTextViewCurrentInputTargetEmotion) {
        self.chatBottomData.target = ChatTextViewCurrentInputTargetText;
        self.viewEmotionTabConstraintHeight.constant = 0.0;
        [self.textView becomeFirstResponder];
        InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
        data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
        data.inputViewHeight = self.viewTopConstraintHeight.constant;
        data.isEmotionModel = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于表情的消失 导致整个view的frame变化
    }
}

- (IBAction)btnPlusTouchUpInside:(UIButton *)sender {
    
}

- (IBAction)btnRecordTouchUpInside:(UIButton *)sender {
    [sender setTitle:@"按住 说话" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)btnRecordTouchDown:(UIButton *)sender {
    [sender setTitle:@"松开 结束" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor lightGrayColor]];
}

- (IBAction)btnRecordTouchUpOutside:(UIButton *)sender {
    [sender setTitle:@"按住 说话" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - message notification

- (void)registerMessageNotification {
    
}

- (void)removeMessageNotification {
    
}

#pragma mark - ChatBottomDataSourceDelegate

- (void)updateTopViewHeight:(CGFloat)height {
    
    self.viewTopConstraintHeight.constant = 8.0 + height + 8.0;
    
    InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
    data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
    data.inputViewHeight = self.chatBottomData.target == ChatTextViewCurrentInputTargetEmotion ? self.viewTopConstraintHeight.constant + self.collectionViewEmotion.height + emotionCollectionView2EmotionTabSpacing + self.viewEmotionTabConstraintHeight.constant : self.viewTopConstraintHeight.constant;
    data.isEmotionModel = self.chatBottomData.target == ChatTextViewCurrentInputTargetEmotion;
    data.isInputChanage = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于输入字符换行 导致输入框view的frame变化
}

- (void)sendChatMessage:(NSString *)content {
}

#pragma mark - ChatEmotionDataDelegate

- (void)pageControlValueChangeForEmotion:(NSInteger)pageNum {
    self.pageControlEmotion.currentPage = pageNum;
}

#pragma mark - ChatTabEmotionDataDelegate

- (void)openEmotionTab:(NSInteger)tab withEmotionTabValue:(NSString *)tabValue {
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:self.chatBottomData.selectedEmotionTab inSection:0];
    NSIndexPath *willSelectIndexPath = [NSIndexPath indexPathForItem:tab inSection:0];
    [self.collectionViewEmotionTab reloadItemsAtIndexPaths:@[selectedIndexPath, willSelectIndexPath]];
    self.chatBottomData.selectedEmotionTab = tab;
#warning update collectionViewEmotion icon
//    [self.collectionViewEmotion reloadData];
}

@end