//
//  Constants.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

typedef NS_ENUM(NSInteger, ChatBottomTarget)
{
    ChatBottomTargetFree = 0,
    ChatBottomTargetText,
    ChatBottomTargetEmotion,
    ChatBottomTargetFunction,
    ChatBottomTargetAudio
};

typedef NS_ENUM(NSInteger, ChatMsgType) {
    ChatMsgTypeFree,
    ChatMsgTypeText,
    ChatMsgTypeImage,
    ChatMsgTypeAudio,
    ChatMsgTypeVideo,
    ChatMsgTypeUpperLimit   //消息所支持的类型上限
};

typedef NS_ENUM(NSInteger, ChatMsgState) {
    ChatMsgStateNoSend,
    ChatMsgStateSending,
    ChatMsgStateSendSuccess,
    ChatMsgStateFailed
};

typedef NS_ENUM(NSInteger, ChatTargetType) {
    ChatTargetTypeP2P,//私聊
    ChatTargetTypeP2G//群聊
};

#endif /* Constants_h */
