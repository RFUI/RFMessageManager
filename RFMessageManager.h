/*!
 RFMessageManager
 
 Copyright (c) 2014, 2016, 2018 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import "RFRuntime.h"
#import "RFInitializing.h"

/**
 RFMessageDisplayPriority

 @enum RFMessageDisplayPriorityQueue 排队显示
 @enum RFMessageDisplayPriorityHigh 不改变队列，立即显示
 @enum RFMessageDisplayPriorityReset 立即显示，同时清空队列
 */
typedef NS_ENUM(NSInteger, RFMessageDisplayPriority) {
    RFMessageDisplayPriorityQueue = 0,
    RFMessageDisplayPriorityHigh = 750,
    RFMessageDisplayPriorityReset = 1000
};

@class RFMessage;

/**
 网络请求加载状态管理器
 
 具体表现需要重写本类
 引入 identifier 的意图是支持多个状态的管理，配对的方式来管理消隐。目前设计只能同时显示一个
 */
@interface RFMessageManager : NSObject <
    RFInitializing
>

- (void)showMessage:(nonnull __kindof RFMessage *)message;

@property (nullable) __kindof RFMessage *displayingMessage;

/**
 @param identifier nil 会取消所有显示，如果 show 时的 identifier 未传，应使用 @""
 */
- (void)hideWithIdentifier:(nullable NSString *)identifier;
/** 隐藏一组
 
 @param groupIdentifier nil 会取消所有显示，如果 show 时的 identifier 未传，应使用 @""
 */
- (void)hideWithGroupIdentifier:(nullable NSString *)groupIdentifier;

#pragma mark - Methods for overwrite.
/** 
 
 Must call super.
 
 @param displayingMessage 目前显示的信息
 @param message 将要显示的信息
 */
- (void)replaceMessage:(nullable __kindof RFMessage *)displayingMessage withNewMessage:(nullable __kindof RFMessage *)message;

@end

/**
 
 */
@interface RFMessage: NSObject <
    RFInitializing
>
@property (nonnull, copy) NSString *identifier;
@property (nullable, copy) NSString *groupIdentifier;
@property RFMessageDisplayPriority priority;

+ (nullable instancetype)messageWithConfiguration:(NS_NOESCAPE void (^__nullable)(__kindof RFMessage *__nonnull instance))configBlock error:(NSError *__nullable *__nullable)error;

- (BOOL)validateConfigurationError:(NSError *__nullable *__nonnull)error;
@end
