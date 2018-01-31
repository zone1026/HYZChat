//
//  ContactHeaderView.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/31.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "ContactHeaderView.h"

@interface ContactHeaderView ()

@end

@implementation ContactHeaderView

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI {
    self.searchBar.backgroundImage = [[UIImage alloc] init];
}

@end
