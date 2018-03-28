/*!
 RFMessageManager
 
 Copyright (c) 2014, 2016, 2018 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import "RFRuntime.h"
#import "RFInitializing.h"

typedef NS_ENUM(short, RFNetworkActivityIndicatorStatus) {
    RFNetworkActivityIndicatorStatusLoading = 0,
    RFNetworkActivityIndicatorStatusSuccess,
    RFNetworkActivityIndicatorStatusFail,

    RFNetworkActivityIndicatorStatusDownloading,
    RFNetworkActivityIndicatorStatusUploading
};

/**  RFNetworkActivityIndicatorMessagePriority

 @enum RFNetworkActivityIndicatorMessagePriorityQueue 排队显示
 @enum RFNetworkActivityIndicatorMessagePriorityHigh 不改变队列，立即显示
 @enum RFNetworkActivityIndicatorMessagePriorityReset 立即显示，同时清空队列
 */
typedef NS_ENUM(NSInteger, RFNetworkActivityIndicatorMessagePriority) {
    RFNetworkActivityIndicatorMessagePriorityQueue = 0,
    RFNetworkActivityIndicatorMessagePriorityHigh = 750,
    RFNetworkActivityIndicatorMessagePriorityReset = 1000
};

@class RFNetworkActivityIndicatorMessage;

/**
 网络请求加载状态管理器
 
 具体表现需要重写本类
 引入 identifier 的意图是支持多个状态的管理，配对的方式来管理消隐。目前设计只能同时显示一个
 */
@interface RFMessageManager : NSObject <
    RFInitializing
>

- (void)showMessage:(nonnull RFNetworkActivityIndicatorMessage *)message;

@property (nullable) RFNetworkActivityIndicatorMessage *displayingMessage;

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
- (void)replaceMessage:(nullable RFNetworkActivityIndicatorMessage *)displayingMessage withNewMessage:(nullable RFNetworkActivityIndicatorMessage *)message;

@end


@interface RFNetworkActivityIndicatorMessage : NSObject
@property (nonnull, copy) NSString *identifier;
@property (nullable, copy) NSString *groupIdentifier;
@property (nullable, copy) NSString *title;
@property (nullable, copy) NSString *message;
@property RFNetworkActivityIndicatorStatus status;

@property RFNetworkActivityIndicatorMessagePriority priority;
@property BOOL modal;
@property float progress;
@property NSTimeInterval displayTimeInterval;

@property (nullable) NSDictionary *userInfo;

- (nonnull instancetype)initWithIdentifier:(nonnull NSString *)identifier title:(nullable NSString *)title message:(nullable NSString *)message status:(RFNetworkActivityIndicatorStatus)status;
@end
