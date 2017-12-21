//
//  NotificationName.h
//  HYZChat
//
//  Created by 黄亚州 on 2017/9/1.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#ifndef NotificationName_h
#define NotificationName_h

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////                                  通知标记定义                               ////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * @description 输入框的高度发生变化的通知
 */
#define NotiInputViewFrameChanage               @"NotiInputViewFrameChanage"
/**
 * @description 聊天底部功能按钮的点击通知
 */
#define NotiChatFunctionBtnClick                @"NotiChatFunctionBtnClick"
/**
 * @description 恢复文本／表情按钮默认状态通知
 */
#define NotiEmotionBtnDefaultStauts             @"NotiEmotionBtnDefaultStauts"
/**
 * @description 通过表情描述信息更新输入文本
 */
#define NotiUpdateInputTextByEmotionStr         @"NotiUpdateInputTextByEmotionStr"
/**
 * @description 通过表情的发送按钮发送消息
 */
#define NotiSendMsgByEmotionBtnSend             @"NotiSendMsgByEmotionBtnSend"
/**
 * @description 通过聊天消息更新聊天表格
 */
#define NotiUpdateChatViewForSendMsg            @"NotiUpdateChatViewForSendMsg"
/**
 * @description 收缩聊天底部面板通知
 */
#define NotiChatBottomPanelShrinkage            @"NotiChatBottomPanelShrinkage"
/**
 * @description 聊天消息内容长按手势通知
 */
#define NotiMsgContentLongPressGesture          @"NotiMsgContentLongPressGesture"
/**
 * @description 用户头像手势通知
 */
#define NotiLogoImageGesture                    @"NotiLogoImageGesture"


#endif /* NotificationName_h */
