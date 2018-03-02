//
//  RemarksDataSource.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/3/2.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CellSection) {
    CellSectionRemarks = 0, //备注
    CellSectionTags,        //标签
    CellSectionPhone,       //电话号码
    CellSectionDesc,        //描述
    CellSectionNum          //section总数
};

@interface RemarksDataSource : NSObject

/** 备注昵称 */
@property (copy, nonatomic) NSString *nickName;
/** 标签Tag */
@property (strong, nonatomic) NSMutableArray *tagsArr;
/** 电话号码 */
@property (strong, nonatomic) NSMutableArray *phonesArr;
/** 备注描述 */
@property (copy, nonatomic) NSString *remarksDesc;
/** 备注图片 */
@property (copy, nonatomic) NSString *remarksImage;
/** 好友信息 */
@property (weak, nonatomic) CNFriend *friendInfo;

/**
 * @description 更新好友标签描述label
 * @param lblDesc 标签label
 */
- (void)updateFriendTagsDescLabel:(UILabel *)lblDesc;
/**
 * @description 更新好友电话号码
 * @param tf 号码textfield
 * @param index 号码的索引
 */
- (void)updateFriendPhoneTextField:(UITextField *)tf withIndex:(NSInteger)index;
/**
 * @description 移除一个手机号码
 * @param index 号码索引
 */
- (void)removeOnePhone:(NSInteger)index;
/**
 * @description 添加一个手机号码
 */
- (void)addOnePhone;
/**
 * @description 获取真实有效的电话号码个数
 */
- (NSInteger)obtainValidPhoneNum;
/**
 * @description 获取已添加过的电话号码个数（包括phone_）
 */
- (NSInteger)obtainHasAddedPhoneNum;
/**
 * @description 获取一个手机号码
 * @param index 号码索引
 */
- (NSString *)obtainPhoneStrByIndex:(NSInteger)index;
/**
 * @description 检测一个手机号码是否处于隐藏状态
 * @param index 号码索引
 */
- (BOOL)checkPhoneIsHideByIndex:(NSInteger)index;
/**
 * @description 更新手机号
 * @param phone 号码
 * @param index 号码索引
 */
- (void)updatePhoneNum:(NSString *)phone withIndex:(NSInteger)index;
/**
 * @description 保存编辑后的信息
 */
- (void)saveEidtInfo;

@end
