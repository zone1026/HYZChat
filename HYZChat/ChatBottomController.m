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
#import "ChatManager.h"
#import "NSAttributedString+TextAttachment.h"

@interface ChatBottomController ()<ChatBottomDataSourceDelegate>
@property (strong, nonatomic) IBOutlet ChatBottomDataSource *chatBottomData;

//chat top input view
@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet UIButton *btnAudio;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraintHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnEmotion;

//chat emotion view
@property (weak, nonatomic) IBOutlet UIView *viewEmotion;

//chat function view
@property (weak, nonatomic) IBOutlet UIView *viewFunction;

@property (assign, nonatomic) NSRange chatEmotionShouldChangeRange;//表情在输入框将要插入的光标Range
@property (assign, nonatomic) CGFloat emotionViewHeiht;
@end

@implementation ChatBottomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //input view
    self.textView.text = @"";
    [self.textView.layer setBorder:0.3 withColor:[UIColor lightGrayColor] withCorner:3.0];
    [self.btnRecord.layer setBorder:0.3 withColor:[UIColor lightGrayColor] withCorner:3.0];
    
    self.chatBottomData.delegate = self;
    self.viewEmotion.hidden = NO;
    self.viewFunction.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerMessageNotification];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //如果修改了表情collectionView的定义常量，功能collectionView的顶部和底部约束要做相应修改
    self.emotionViewHeiht = emotionCellTopSpacing + emotionLineNum*emotionCellWidth + (emotionLineNum - 1)*emotionItemSpacing + emotionCollectionView2EmotionTabSpacing + 38.0;
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
    if (self.btnRecord.isHidden == NO) {//录音模式
        [self.view endEditing:YES];
        [ChatManager sharedManager].bottomMode = ChatBottomTargetAudio;
        [self restoreInputTextViewHeight];
        [self handleNotiEmotionBtnDefaultStauts:nil];
    }
    else {
        CGFloat height = MIN(textViewMaxHeight, [self.textView sizeThatFits:CGSizeMake(self.textView.contentSize.width, CGFLOAT_MAX)].height);
        [self updateTopViewHeight:height];
        [self.textView becomeFirstResponder];
    }
}

- (IBAction)btnEmotionTouchUpInside:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    //切换表情／功能视图的展示
    if (self.viewEmotion.isHidden == YES) {
        self.viewEmotion.hidden = NO;
        self.viewFunction.hidden = YES;
    }
    if (self.btnRecord.isHidden == NO) {//隐藏音频按钮
        [self.btnAudio setSelected:NO];
        self.btnRecord.hidden = YES;
        self.textView.hidden = NO;
        CGFloat height = MIN(textViewMaxHeight, [self.textView sizeThatFits:CGSizeMake(self.textView.contentSize.width, CGFLOAT_MAX)].height);
        [self updateTopViewHeight:height];
    }
    
    self.chatBottomData.endLocationInput = (self.textView.selectedRange.location >= self.textView.text.length);
    self.chatEmotionShouldChangeRange = self.textView.selectedRange;
    if (sender.isSelected == YES) {
        if ([ChatManager sharedManager].bottomMode == ChatBottomTargetFunction) {
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, 0.0, self.viewEmotion.height);
            self.viewEmotion.transform = transform;
            [UIView animateWithDuration:chatAnimateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewEmotion.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {}];
        }
        else {
            [self.view endEditing:YES];
            InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
            data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
            data.inputViewHeight = self.viewTopConstraintHeight.constant + self.emotionViewHeiht;
            data.isEmotionModel = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于表情的出现 导致整个view的frame变化
        }
        [ChatManager sharedManager].bottomMode = ChatBottomTargetEmotion;
    }
    else {
        [ChatManager sharedManager].bottomMode = ChatBottomTargetText;
        InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
        data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
        data.inputViewHeight = self.viewTopConstraintHeight.constant;
        data.isEmotionModel = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于表情的消失 导致整个view的frame变化
        [self.textView becomeFirstResponder];
    }
}

- (IBAction)btnPlusTouchUpInside:(UIButton *)sender {
    //切换表情／功能视图的展示
    if (self.viewFunction.isHidden == YES) {
        self.viewEmotion.hidden = YES;
        self.viewFunction.hidden = NO;
    }
    
    if (self.btnRecord.isHidden == NO) {//隐藏音频按钮
        [self.btnAudio setSelected:NO];
        self.btnRecord.hidden = YES;
        self.textView.hidden = NO;
        CGFloat height = MIN(textViewMaxHeight, [self.textView sizeThatFits:CGSizeMake(self.textView.contentSize.width, CGFLOAT_MAX)].height);
        [self updateTopViewHeight:height];
    }
    
    [self handleNotiEmotionBtnDefaultStauts:nil];//表情按钮恢复默认状态
    
    if ([ChatManager sharedManager].bottomMode != ChatBottomTargetFunction) {
        if ([ChatManager sharedManager].bottomMode == ChatBottomTargetEmotion) {
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, 0.0, self.viewFunction.height);
            self.viewFunction.transform = transform;
            [UIView animateWithDuration:chatAnimateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewFunction.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {}];
        }
        else {
            [self.view endEditing:YES];
            InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
            data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
            data.inputViewHeight = self.viewTopConstraintHeight.constant + self.emotionViewHeiht;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于表情的出现 导致整个view的frame变化
        }
        [ChatManager sharedManager].bottomMode = ChatBottomTargetFunction;
    }
    else {
        [ChatManager sharedManager].bottomMode = ChatBottomTargetText;
        InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
        data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
        data.inputViewHeight = self.viewTopConstraintHeight.constant;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于表情的消失 导致整个view的frame变化
        [self.textView becomeFirstResponder];
    }
}

- (IBAction)btnRecordTouchUpInside:(UIButton *)sender {
    [self handleNotiEmotionBtnDefaultStauts:nil];//表情按钮恢复默认状态
    [sender setTitle:@"按住 说话" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)btnRecordTouchDown:(UIButton *)sender {
    [sender setTitle:@"松开 结束" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor lightGrayColor]];
}

- (IBAction)btnRecordTouchUpOutside:(UIButton *)sender {
    [self handleNotiEmotionBtnDefaultStauts:nil];//表情按钮恢复默认状态
    [sender setTitle:@"按住 说话" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - message notification

/** 注册消息通知 */
- (void)registerMessageNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiEmotionBtnDefaultStauts:)
                                                 name:NotiEmotionBtnDefaultStauts object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiUpdateInputTextByEmotionStr:)
                                                 name:NotiUpdateInputTextByEmotionStr object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiSendMsgByEmotionBtnSend:)
                                                 name:NotiSendMsgByEmotionBtnSend object:nil];
}

/** 移除消息通知 */
- (void)removeMessageNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiEmotionBtnDefaultStauts object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotiUpdateInputTextByEmotionStr object:nil];
}

/** 表情按钮默认状态通知响应方法 */
- (void)handleNotiEmotionBtnDefaultStauts:(NSNotification *)notification {
    if (self.btnEmotion.isSelected == NO)
        return;
    [self.btnEmotion setSelected:NO];
}

/** 向输入框内插入表情描述文本通知响应方法 */
- (void)handleNotiUpdateInputTextByEmotionStr:(NSNotification *)notification {
    if (notification.object != nil) {
        if ([notification.object isKindOfClass:[NSString class]]) {
            NSString *emotionStr = notification.object;
            if ([emotionStr isEqualToString:@"del"])
                [self willDeleteEmotion];
            else
                [self willInsertEmotion:emotionStr];
        }
    }
}

- (void)handleNotiSendMsgByEmotionBtnSend:(NSNotification *)notification {
    if ([HYZUtil isEmptyOrNull:self.textView.text] == YES)
        return;
    
    [self sendTextChatMsg2ChatView:self.textView.text];
    self.textView.text = @"";
}

#pragma mark - ChatBottomDataSourceDelegate

- (void)updateTopViewHeight:(CGFloat)height {
    self.viewTopConstraintHeight.constant = 8.0 + height + 8.0;//顶部输入框的高度
    InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
    data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
    data.inputViewHeight = [ChatManager sharedManager].bottomMode == ChatBottomTargetEmotion ?
    self.viewTopConstraintHeight.constant + self.viewEmotion.height : self.viewTopConstraintHeight.constant;
    data.isEmotionModel = [ChatManager sharedManager].bottomMode == ChatBottomTargetEmotion;
    data.isInputChanage = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];//由于输入字符换行 导致输入框view的frame变化
}

- (void)sendChatMessage:(NSString *)content {
    self.textView.text = @"";
    [self restoreInputTextViewHeight];
    [self handleNotiEmotionBtnDefaultStauts:nil];
    [self sendTextChatMsg2ChatView:content];
}

#pragma mark - 私有方法

/** 恢复到输入框默认高度 */
- (void)restoreInputTextViewHeight {
    self.viewTopConstraintHeight.constant = ChatViewTopInputViewDefaultHeight;
    InputViewFrameChanageData *data = [[InputViewFrameChanageData alloc] init];
    data.inputViewHeight = self.viewTopConstraintHeight.constant;
    data.inputTextViewHeight = self.viewTopConstraintHeight.constant;
    data.isEmotionModel = NO;
    data.isImmediatelyChanageInputHeight = YES;//还原输入view初始
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiInputViewFrameChanage object:data];
}

/**
 * @description 将要插入表情描述文本
 * @parm value 表情描述文本
 */
- (void)willInsertEmotion:(NSString *)value {
    NSMutableString *inputText = [[NSMutableString alloc] initWithString:self.textView.text];
    [inputText insertString:value atIndex:self.chatEmotionShouldChangeRange.location];
    self.textView.text = inputText;
    [self.chatBottomData textChangedByEmotionStr:self.textView];
    
    NSRange range = self.chatEmotionShouldChangeRange;
    range.location += value.length;
    self.chatEmotionShouldChangeRange = range;
}

/** 将要删除表情描述文本 */
- (void)willDeleteEmotion {
    NSMutableString *inputText = [[NSMutableString alloc] initWithString:self.textView.text];
    if (inputText.length > 0 && self.chatEmotionShouldChangeRange.location > 0) {
        NSRange rangeLeft = [inputText rangeOfString:attachmentMarkLeft options:NSBackwardsSearch range:NSMakeRange(0, self.chatEmotionShouldChangeRange.location)];
        NSRange rangeRight = [inputText rangeOfString:attachmentMarkRight options:NSBackwardsSearch range:NSMakeRange(0, self.chatEmotionShouldChangeRange.location)];
        if (rangeLeft.location == NSNotFound || rangeRight.location == NSNotFound) {//没找到表情描述文本，当作删除字符处理
            [inputText replaceCharactersInRange:NSMakeRange(self.chatEmotionShouldChangeRange.location - 1, 1) withString:@""];
            NSRange range = self.chatEmotionShouldChangeRange;
            range.location -= 1;
            self.chatEmotionShouldChangeRange = range;
        }
        else {
            if (rangeLeft.location < rangeRight.location) {
                NSRange rangeEmotion = NSMakeRange(rangeLeft.location, rangeRight.location - rangeLeft.location + 1);
                [inputText replaceCharactersInRange:rangeEmotion withString:@""];
                
                NSString *value = [self.textView.text substringWithRange:rangeEmotion];
                if (value && ![value isEqualToString:@""]) {
                    NSRange range = self.chatEmotionShouldChangeRange;
                    range.location -= value.length;
                    self.chatEmotionShouldChangeRange = range;
                }
            }
            else {//找到的 左右标识反了，当作删除字符处理
                [inputText replaceCharactersInRange:NSMakeRange(self.chatEmotionShouldChangeRange.location - 1, 1) withString:@""];
                NSRange range = self.chatEmotionShouldChangeRange;
                range.location -= 1;
                self.chatEmotionShouldChangeRange = range;
            }
        }
        
        self.textView.text = inputText;
        [self.chatBottomData textChangedByEmotionStr:self.textView];
    }
}

/**
 * @description 发送文本消息信息
 * @parm textContent 文本信息
 */
- (void)sendTextChatMsg2ChatView:(NSString *)textContent {
    self.chatEmotionShouldChangeRange = NSMakeRange(0, 0);
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiUpdateChatViewForSendMsg object:nil
                                                userInfo:@{@"type":@(ChatMsgTypeText), @"content":textContent}];
}

@end

