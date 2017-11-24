//
//  ChatTableCellInfo.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/11/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatTableCellInfo : NSObject

/** cell 的所对应的消息类型 */
@property (assign, nonatomic) ChatMsgType type;
/** cell 的所对应的类名称 */
@property (copy, nonatomic) NSString *className;
/** cell 的所对应的标识 */
@property (copy, nonatomic) NSString *indentifier;

@end
