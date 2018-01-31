//
//  SearchCell.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/31.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
