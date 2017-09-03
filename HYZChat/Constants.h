//
//  Constants.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

typedef NS_ENUM(NSInteger, ChatTextViewCurrentInputTarget)
{
    ChatTextViewCurrentInputTargetFree = 0,
    ChatTextViewCurrentInputTargetText,
    ChatTextViewCurrentInputTargetEmotion
};

typedef NS_ENUM(NSInteger, ChatBottomCollectionViewTag) {
    ChatBottomCollectionViewTagEmotion = 100,
    ChatBottomCollectionViewTagFunction
};

#endif /* Constants_h */
