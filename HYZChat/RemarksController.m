//
//  RemarksController.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/2/27.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "RemarksController.h"
#import "RemarksDataSource.h"
#import "UIView+HYZFrame.h"
#import "UIImageView+WebImage.h"

@interface RemarksController ()<UITextViewDelegate>
/** controller的数据源 */
@property (strong, nonatomic) IBOutlet RemarksDataSource *cDataSource;
@property (weak, nonatomic) IBOutlet UITextView *textView;
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
    self.cDataSource.friendInfo = self.friendInfo;
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
                    ((UITextField *)view).text = self.cDataSource.nickName;
                break;
             case CellSectionTags:
                if ([view isKindOfClass:[UILabel class]])
                    [self.cDataSource updateFriendTagsDescLabel:((UILabel *)view)];
                break;
            case CellSectionPhone:
                if ([view isKindOfClass:[UITextField class]])
                    [self.cDataSource updateFriendPhoneTextField:((UITextField *)view) withIndex:indexPath.row];
                break;
            case CellSectionDesc:
                if ([view isKindOfClass:[UITextView class]]) {
                    ((UITextView *)view).text = [HYZUtil isEmptyOrNull:self.cDataSource.remarksDesc] == YES ? @"" : self.cDataSource.remarksDesc;
                    self.lblRemarksTips.hidden = [HYZUtil isEmptyOrNull:self.cDataSource.remarksDesc] == NO;
                }
                else if ([view isKindOfClass:[UIImageView class]])
                    [((UIImageView *)view) web_srcImageURLStr:self.cDataSource.remarksImage
                                         withThumbImageURLStr:self.cDataSource.remarksImage withPlaceholderImageName:@"IMG_REMARKS_TIPS"];
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
        [self.cDataSource removeOnePhone:indexPath.row];
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:CellSectionPhone] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
        [self addOneFriendPhone];
    [self enabledRightBarBtnItemState];
}

#pragma mark - table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (CellSectionTags == indexPath.section ||
        (CellSectionPhone == indexPath.section && ([tableView numberOfRowsInSection:indexPath.section] - 1) == indexPath.row)
        || (CellSectionDesc == indexPath.section && ([tableView numberOfRowsInSection:indexPath.section] - 1) == indexPath.row))
        return YES;
        
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (CellSectionPhone == indexPath.section)
        [self addOneFriendPhone];
    else if (CellSectionDesc == indexPath.section)
        [HYZAlert showInfo:@"打开相册没有做" underTitle:@"提示"];
    [self enabledRightBarBtnItemState];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CellSectionPhone) {
        if ([self.cDataSource obtainHasAddedPhoneNum] >= [tableView numberOfRowsInSection:indexPath.section] - 1) {//此时添加cell应该被隐藏
            if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1)//隐藏添加Cell
                return 0.01f;
        }
        else {
            if (indexPath.row != [tableView numberOfRowsInSection:indexPath.section] - 1) {//不是添加cell
                if ([self.cDataSource checkPhoneIsHideByIndex:indexPath.row] == YES)
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
            if ([HYZUtil isEmptyOrNull:self.cDataSource.remarksImage] == YES) {
                imgSize = [UIImage imageNamed:@"IMG_REMARKS_TIPS"].size;
                roate = imgSize.height / imgSize.width;
            }
            else {
                UIImageView *tempImage = [[UIImageView alloc] init];
                [tempImage web_srcImageURLStr:self.cDataSource.remarksImage withThumbImageURLStr:self.cDataSource.remarksImage
                     withPlaceholderImageName:@"IMG_REMARKS_TIPS"];
                if (nil != tempImage.image) {
                    imgSize = tempImage.image.size;
                    roate = imgSize.height / imgSize.width;
                }
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
    self.cDataSource.remarksDesc = textView.text;
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
        self.cDataSource.nickName = sender.text;
    else if (CellSectionPhone == section)
        [self.cDataSource updatePhoneNum:sender.text withIndex:row];
    [self enabledRightBarBtnItemState];
}

#pragma mark - 私有方法

/** 保存对好友备注信息 */
- (void)saveRemarksData {
    if ([HYZUtil isEmptyOrNull:self.cDataSource.remarksImage] == NO) {}//需要上传图片
    [self.cDataSource saveEidtInfo];
}

/** 更新导航右按钮的激活状态 */
- (void)enabledRightBarBtnItemState {
    if (self.navigationItem.rightBarButtonItem.isEnabled == NO)
        self.navigationItem.rightBarButtonItem.enabled = YES;
}

/** 新增一个好友手机号码 */
- (void)addOneFriendPhone {
    [self.cDataSource addOnePhone];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:CellSectionPhone] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

@end
