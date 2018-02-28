//
//  RemarksInfo.h
//  HYZChat
//
//  Created by 黄亚州 on 2018/2/28.
//  Copyright © 2018年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemarksInfo : NSObject
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

@end
