//
//  ChatFunctionController.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatFunctionController.h"
#import "ChatFunctionDataSource.h"
#import "CALayer+HYZUtil.h"
#import "UIView+HYZFrame.h"
#import "InputViewFrameChanageData.h"

@interface ChatFunctionController ()<ChatFunctionDataSourceDelegate>
@property (strong, nonatomic) IBOutlet ChatFunctionDataSource *chatFunctionData;

@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraintHeight;

@property (weak, nonatomic) IBOutlet UIView *viewEmoji;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewEmoji;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlEmoji;

@end

@implementation ChatFunctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chatFunctionData.delegate = self;
    self.textView.text = @"";
    [self.textView.layer setBorder:0.3 withColor:[UIColor lightGrayColor] withCorner:3.0];
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

- (IBAction)btnAudioTouchUpInside:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}

- (IBAction)btnEmojiTouchUpInside:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}

- (IBAction)btnPlusTouchUpInside:(UIButton *)sender {
    
}

#pragma mark - message notification

- (void)registerMessageNotification {
    
}

- (void)removeMessageNotification {
    
}

#pragma mark - ChatFunctionDataSourceDelegate

- (void)updateTopViewHeight:(CGFloat)height {
    
    self.viewTopConstraintHeight.constant = 8.0 + height + 8.0;
    
    InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
    data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
    data.inputViewHeight = self.chatFunctionData.target == ChatTextViewCurrentInputTargetEmotion ? self.viewTopConstraintHeight.constant + self.collectionViewEmoji.height + emotionCellBottomSpace : self.viewTopConstraintHeight.constant;
    data.isEmotionModel = self.chatFunctionData.target == ChatTextViewCurrentInputTargetEmotion;
    data.isInputChanage = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于输入字符换行 导致输入框view的frame变化
}

- (void)sendChatMessage:(NSString *)content {
    
}

@end
