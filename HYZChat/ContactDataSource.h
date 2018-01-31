//
//  ContactDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/1/30.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import "SuperDataSource.h"
#import "CNFriend+CoreDataClass.h"

@protocol ContactDataSourceDelegate <NSObject>

@optional
/**
 * @description 点击通讯录cell跳转详细资料界面
 * @param targetId 目标ID
 * @param type cell的类型
 */
- (void)didSelectCellEnterContactInfoUI:(long long)targetId withCellType:(ContactCellType)type;

@end

@interface ContactDataSource : SuperDataSource
/** 通讯录对应的代理 */
@property (weak, nonatomic) id <ContactDataSourceDelegate> delegate;
/** 通讯录列表 */
@property (strong, nonatomic) NSMutableDictionary *contactDict;
/** 是否处于勾选模式下,勾选模式下没有默认相关的cell */
@property (assign, nonatomic) BOOL checkMode;

@end
