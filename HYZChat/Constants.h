//
//  Constants.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/** 聊天视图顶部输入框的默认高度 50.0 */
static const CGFloat ChatViewTopInputViewDefaultHeight = 50.0;
/** 聊天视图的昵称默认高度 16.0 */
static const CGFloat ChatNickNameDefaultHeight = 16.0;

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
