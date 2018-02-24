//
//  ChatManager.m
//  HYZChat
//
//  Created by 黄亚州 on 2017/10/24.
//  Copyright © 2017年 黄亚州. All rights reserved.
//

#import "ChatManager.h"

@interface ChatManager ()

@end

@implementation ChatManager

+ (instancetype)sharedManager {
    static ChatManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSMutableDictionary *)emotionTextDict {
    if (_emotionTextDict == nil) {
        NSArray *emotions = [HYZUtil getPlistData:@"Emotions" inFile:@"Emotion"];
        _emotionTextDict = [NSMutableDictionary dictionary];
        if (emotions != nil || emotions.count > 0) {
            for (NSDictionary *dict in emotions)
                [_emotionTextDict setObject:dict[@"icon"] forKey:dict[@"value"]];
        }
    }
    return _emotionTextDict;
}

- (void)openChatView:(CNSession *)session withFromViewController:(UIViewController *)fromVc {
    if (nil == session) {
        [HYZAlert showInfo:@"数据为空，不能进入聊天页" underTitle:@"提示"];
        return;
    }
    
    self.chatSession = session;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"NaviChat"];
    [fromVc presentViewController:nc animated:YES completion:nil];
}

@end
