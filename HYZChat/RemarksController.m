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
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lblRemarksTips;
/** 好友的备注信息 */
@property (strong, nonatomic) RemarksInfo *friendRemarksInfo;
/** 好友的电话数量 */
@property (assign, nonatomic) NSInteger friendPhoneNum;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CellSectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case CellSectionRemarks:
            return 1;
            break;
        case CellSectionTags:
            return 1;
            break;
        case CellSectionPhone:
            return 6;
            break;
        case CellSectionDesc:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

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
    if (indexPath.section == CellSectionPhone && !(0 == indexPath.row && [self.friendInfo checkFriendFristPhoneIsContactPhone]))//第一个是好友绑定手机号码，不可编辑
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITextField *tf = [cell viewWithTag:((indexPath.section + 1)*1000 + indexPath.row)];
        [self.friendRemarksInfo removeOnePhone:tf.text];
        self.friendPhoneNum = self.friendRemarksInfo.phonesArr.count;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
        [self addOneFriendPhone];
    [self enabledRightBarBtnItemState];
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
    if (CellSectionPhone == indexPath.section)
        [self addOneFriendPhone];
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
            CGFloat textViewHeight = [self.textView sizeThatFits:CGSizeMake(self.textView.contentSize.width, CGFLOAT_MAX)].height;
            return MAX(textViewHeight, 32.0f) + 16.0f + 1.0f;//多加1.0，放大滚动区域；不可滚动
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

/** accessoryButton 响应事件 */
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (CellSectionPhone == indexPath.section && 0 == indexPath.row)
        [HYZAlert showInfo:nil underTitle:@"从手机通讯录中匹配的号码，无法删除"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if (0.0f == cell.alpha)
            cell.alpha = 1.0f;
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] || (text.length > 0 && textView.text.length >= 120))
        return NO;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.friendRemarksInfo.remarksDesc = textView.text;
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.contentSize.width, CGFLOAT_MAX)];
    if (fabs((size.height - textView.height)) > 6.0f) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
    self.lblRemarksTips.hidden = textView.text.length > 0;
    [self enabledRightBarBtnItemState];
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
    [self enabledRightBarBtnItemState];
}

#pragma mark - 私有方法

/** 保存对好友备注信息 */
- (void)saveRemarksData {
    if ([HYZUtil isEmptyOrNull:self.friendRemarksInfo.remarksImage] == NO) {//需要上传图片
        
    }
}

/** 更新导航右按钮的激活状态 */
- (void)enabledRightBarBtnItemState {
    if (self.navigationItem.rightBarButtonItem.isEnabled == NO)
        self.navigationItem.rightBarButtonItem.enabled = YES;
}

/** 新增一个好友手机号码 */
- (void)addOneFriendPhone {
    [self.friendRemarksInfo addOnePhone:[NSString stringWithFormat:@"++%ld", (long)self.friendPhoneNum]];
    self.friendPhoneNum = self.friendRemarksInfo.phonesArr.count;
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.friendPhoneNum - 1) inSection:CellSectionPhone]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

@end
