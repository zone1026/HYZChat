//
//  RemarksController.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/2/27.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "RemarksController.h"
#import "RemarksInfo.h"
#import "UIView+HYZFrame.h"
#import "UIImageView+WebImage.h"

typedef NS_ENUM(NSInteger, CellSection) {
    CellSectionRemarks = 0, //备注
    CellSectionTags,        //标签
    CellSectionPhone,       //电话号码
    CellSectionDesc,        //描述
    CellSectionNum          //section总数
};

@interface RemarksController ()<UITextViewDelegate>
/** 好友的备注信息 */
@property (strong, nonatomic) RemarksInfo *friendRemarksInfo;
/** 好友的电话数量 */
@property (assign, nonatomic) NSInteger friendPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *lblRemarksTips;

@end

@implementation RemarksController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setEditing:YES animated:NO];
    self.friendRemarksInfo = [[RemarksInfo alloc] init];
    self.friendRemarksInfo.friendInfo = self.friendInfo;
    self.friendPhoneNum = self.friendRemarksInfo.phonesArr.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = (indexPath.section + 1)*1000 + indexPath.row;
    UIView *view = [cell viewWithTag:tag];
    if (nil != view) {
        switch (indexPath.section) {
            case CellSectionRemarks:
                if ([view isKindOfClass:[UITextField class]])
                    ((UITextField *)view).text = self.friendRemarksInfo.nickName;
                break;
             case CellSectionTags:
                if ([view isKindOfClass:[UILabel class]])
                    [self.friendRemarksInfo updateFriendTagsDescLabel:((UILabel *)view)];
                break;
            case CellSectionPhone:
                if ([view isKindOfClass:[UITextField class]])
                    [self.friendRemarksInfo updateFriendPhoneTextField:((UITextField *)view) withIndex:indexPath.row];
                break;
            case CellSectionDesc:
                if ([view isKindOfClass:[UITextView class]])
                    ((UITextView *)view).text = [HYZUtil isEmptyOrNull:self.friendRemarksInfo.remarksDesc] == YES ? @"" : self.friendRemarksInfo.remarksDesc;
                else if ([view isKindOfClass:[UIImageView class]])
                    [((UIImageView *)view) web_srcImageURLStr:self.friendRemarksInfo.remarksImage
                                         withThumbImageURLStr:self.friendRemarksInfo.remarksImage withPlaceholderImageName:@"IMG_REMARKS_TIPS"];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CellSectionPhone)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.friendPhoneNum --;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (CellSectionTags == indexPath.section ||
        (CellSectionPhone == indexPath.section && ([tableView numberOfRowsInSection:indexPath.section] - 1) == indexPath.row))
        return YES;
        
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CellSectionPhone){
        if (self.friendPhoneNum >= [tableView numberOfRowsInSection:indexPath.section] - 1) {
            if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1)//隐藏添加Cell
                return 0.01f;
        }
        else {
            if (indexPath.row != [tableView numberOfRowsInSection:indexPath.section] - 1) {
                if (self.friendPhoneNum <= indexPath.row)
                    return 0.01f;
            }
        }
    }
    else if (indexPath.section == CellSectionDesc) {
        if (0 == indexPath.row) {
            CGFloat textViewHeight = [HYZUtil autoFitSizeOfStr:self.friendRemarksInfo.remarksDesc withWidth:tableView.width - 40.0f
                                                      withFont:[UIFont systemFontOfSize:15.0f]].height;
            return MAX(textViewHeight, 24.0f) + 16.0f;
        }
        else if (1 == indexPath.row) {
            CGSize imgSize;
            CGFloat roate = 9.0f / 16.0f;
            if ([HYZUtil isEmptyOrNull:self.friendRemarksInfo.remarksImage] == YES) {
                imgSize = [UIImage imageNamed:@"IMG_REMARKS_TIPS"].size;
                roate = imgSize.height / imgSize.width;
            }
            else {
                
            }
            return (tableView.width - 32.0f)*roate + 16.0f;
        }
    }
    
    return 44.0f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row)
        return UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length >= 120)
        return NO;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.contentSize.width, CGFLOAT_MAX)];
    if (textView.height != size.height) {
        CGFloat height = size.height;
        [textView addHeight:height - textView.height];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:CellSectionDesc]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];//更新cell的高度
    }
    
    BOOL needScrollToLastLine = NO;
    if (textView.markedTextRange != nil) {//中文输入法输入的内容
        UITextPosition *beginning = textView.beginningOfDocument;
        NSInteger endLocation = [textView offsetFromPosition:beginning toPosition:textView.markedTextRange.end];
        if (endLocation == textView.text.length)
            needScrollToLastLine = YES;
    }
    else {
        if (textView.selectedRange.location >= textView.text.length)
            needScrollToLastLine = YES;
    }
    if (needScrollToLastLine)
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 1, 1)];
    
    if (self.navigationItem.rightBarButtonItem.isEnabled == NO)
        self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)barBtnCancelSelector:(UIBarButtonItem *)sender {
    if (self.navigationItem.rightBarButtonItem.isEnabled == YES) {
        [CNAlertView showWithTitle:@"保存本次编辑吗？" message:nil cancelButtonTitle:@"不保存" otherButtonTitles:@[@"保存"]
                          tapBlock:^(CNAlertView *alertView, NSInteger buttonIndex) {
                              if (alertView.firstOtherButtonIndex == buttonIndex)
                                  [self saveRemarksData];
                              [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)barBtnDoneSelector:(UIBarButtonItem *)sender {
    [self saveRemarksData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 事件

- (IBAction)tfEditingChanged:(UITextField *)sender {
    NSInteger tag = sender.tag;
    NSInteger section = (tag / 1000) - 1;
    NSInteger row = tag % 1000;
    if (CellSectionRemarks == section)
        self.friendRemarksInfo.nickName = sender.text;
    else if (CellSectionPhone == section) {
        switch (row) {
            case 0:
                break;
            default:
                break;
        }
    }
    if (self.navigationItem.rightBarButtonItem.isEnabled == NO)
        self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - 私有方法

/** 保存对好友备注信息 */
- (void)saveRemarksData {
    if ([HYZUtil isEmptyOrNull:self.friendRemarksInfo.remarksImage] == NO) {//需要上传图片
        
    }
}

@end
