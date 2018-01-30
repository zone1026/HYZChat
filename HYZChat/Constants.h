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

//聊天视图的底部对象
typedef NS_ENUM(NSInteger, ChatBottomTarget)
{
    ChatBottomTargetFree = 0,
    ChatBottomTargetText,
    ChatBottomTargetEmotion,
    ChatBottomTargetFunction,
    ChatBottomTargetAudio
};

//消息类型
typedef NS_ENUM(NSInteger, ChatMsgType) {
    ChatMsgTypeFree,
    ChatMsgTypeText,
    ChatMsgTypeImage,
    ChatMsgTypeAudio,
    ChatMsgTypeVideo,
    ChatMsgTypeUpperLimit   //消息所支持的类型上限
};

//消息状态
typedef NS_ENUM(NSInteger, ChatMsgState) {
    ChatMsgStateNoSend,
    ChatMsgStateSending,
    ChatMsgStateSendSuccess,
    ChatMsgStateFailed
};

//聊天目标
typedef NS_ENUM(NSInteger, ChatTargetType) {
    ChatTargetTypeP2P,  //私聊
    ChatTargetTypeP2G,   //群聊
    ChatTargetTypeSubscription //订阅
};

//用户身份
typedef NS_ENUM(NSInteger, UserIdentity) {
    UserIdentityNormal,
    UserIdentityVIP
};

//用户性别
typedef NS_ENUM(NSInteger, UserSex) {
    UserSexMan,
    UserSexWoman
};

//会话的类型
typedef NS_ENUM(NSInteger, SessionType) {
    SessionTypeFriend,  //好友
    SessionTypeGroup,   //群组
    SessionTypeSystem,  //系统
    SessionTypeOrganization,    //企业/机构
    SessionTypeOfficial //公众号
};

#endif /* Constants_h */
