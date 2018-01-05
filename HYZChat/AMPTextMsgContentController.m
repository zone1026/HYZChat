//
//  AMPTextMsgContentController.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/5.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "AMPTextMsgContentController.h"
#import "RichLabel.h"
#import "AMPMsgCell.h"

@interface AMPTextMsgContentController ()<UITableViewDelegate, UITableViewDataSource>
/** 消息内容所用的滑动视图 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 消息内容文本 */
@property (strong, nonatomic) RichLabel *lblTempMsg;

@end

@implementation AMPTextMsgContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMPMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ampMsgCell" forIndexPath:indexPath];
    cell.lblMsg.attributedText = [self getMsgContentAttributedString];
    cell.lblMsg.textAlignment = [self msgCellHeight] > 20.0f ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MAX([self msgCellHeight], tableView.frame.size.height);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view removeFromSuperview];
}

#pragma mark - 私有方法

/** 消息所对应的属性字符串 */
- (NSAttributedString *)getMsgContentAttributedString {
    if ([HYZUtil isEmptyOrNull:self.msgContent] == YES)
        self.msgContent = @"抱歉，是空消息";
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0f], NSFontAttributeName, nil];
    //设置换行模式，表情图标出界自动换行
    [attributes setValuesForKeysWithDictionary:[HYZUtil getWrapModeAttributes]];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0;
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSAttributedString *attributedString = [NSAttributedString attachmentAttributedStringFrom:self.msgContent attributes:attributes];
    return attributedString;
}

/** 消息所对应的高度 */
- (CGFloat)msgCellHeight {
    NSAttributedString *attributedString = [self getMsgContentAttributedString];
    
    CGFloat textWidth = kScreenWidth;
    CGFloat textHeight = 0.0f;
    
    if (nil == self.lblTempMsg) {
        self.lblTempMsg = [[RichLabel alloc] initWithFrame:CGRectZero];
        self.lblTempMsg.automaticLinkDetectionEnabled = YES;
        self.lblTempMsg.numberOfLines = 0;
    }
    
    [self.lblTempMsg setFrame:CGRectMake(0.0f, 0.0f, textWidth, textHeight)];
    self.lblTempMsg.attributedText = attributedString;
    [self.lblTempMsg sizeToFit];
    
    textHeight = self.lblTempMsg.frame.size.height + 3.0f;
    return textHeight;
}

@end
