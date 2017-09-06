//
//  ChatFunctionController.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/6.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatFunctionController.h"
#import "ChatFunctionData.h"
#import "UIView+HYZFrame.h"

@interface ChatFunctionController ()<ChatFunctionDataDelegate>

//chat function view
@property (strong, nonatomic) IBOutlet ChatFunctionData *chatFunctionData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewFunction;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlFunction;

@end

@implementation ChatFunctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.3
    //chat function view
    self.chatFunctionData.delegate = self;
    self.chatFunctionData.collectionViewFunctionHeight = self.collectionViewFunction.height;
    [self.chatFunctionData parseFunctionsPlistData];
    self.pageControlFunction.numberOfPages = self.chatFunctionData.functionPageNum;
    self.pageControlFunction.hidden = self.chatFunctionData.functionPageNum <= 1;
    [self.collectionViewFunction reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChatFunctionDataDelegate

- (void)pageControlValueChangeForFunction:(NSInteger)pageNum {
    self.pageControlFunction.currentPage = pageNum;
}

@end
