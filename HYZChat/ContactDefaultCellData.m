//
//  ContactDefaultCellData.m
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/31.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "ContactDefaultCellData.h"

@implementation DefaultCellInfo

@end

@implementation ContactDefaultCellData

- (id)init {
    if (self = [super init]) {
        _defaultCellInfoArr = nil;
    }
    return self;
}

- (NSMutableArray <DefaultCellInfo *> *)defaultCellInfoArr {
    if (nil == _defaultCellInfoArr)
        _defaultCellInfoArr = [self assemblyDefaultCellArray];
    return _defaultCellInfoArr;
}

- (NSMutableArray *)assemblyDefaultCellArray {
    NSMutableArray *cellArr = [NSMutableArray array];
    
    NSArray *defaultCellPlist = [HYZUtil getPlistData:@"DefaultCell" inFile:@"Contact"];
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"cellIdentify" ascending:YES]];
    defaultCellPlist = [defaultCellPlist sortedArrayUsingDescriptors:sortDesc];
    
    for (NSDictionary *dict in defaultCellPlist) {
        DefaultCellInfo *info = [[DefaultCellInfo alloc] init];
        info.imgName = dict[@"imgName"];
        info.name = dict[@"name"];
        info.cellIdentify = [dict[@"cellIdentify"] integerValue];
        [cellArr addObject:info];
    }
    
    return cellArr;
}

@end
