//
//  RemarksController.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/2/27.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "RemarksController.h"

typedef NS_ENUM(NSInteger, CellSection) {
    CellSectionRemarks = 0, //备注
    CellSectionTags,        //标签
    CellSectionPhone,       //电话号码
    CellSectionDesc,        //描述
    CellSectionNum          //section总数
};

@interface RemarksController ()
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
            return self.friendPhoneNum > 0 ? self.friendPhoneNum : 1;
            break;
            
        case CellSectionDesc:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == CellSectionPhone) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }  
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)barBtnCancelSelector:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)barBtnDoneSelector:(UIBarButtonItem *)sender {
    
}

@end
