//
//  MsgController.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/12/13.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "MsgController.h"
#import "MsgDataSource.h"

@interface MsgController ()
@property (strong, nonatomic) IBOutlet MsgDataSource *msgDataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnAdd;

@end

@implementation MsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event

- (IBAction)barBtnAddSelector:(UIBarButtonItem *)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
