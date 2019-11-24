/*
 RFMessageManager
 
 Copyright © 2014, 2016, 2018-2019 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import <RFKit/RFRuntime.h>
#import <RFInitializing/RFInitializing.h>

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

@protocol RFMessage;

/**
 RFMessageManager is an abstract class which can manage a set of message object.
 
 You should write subclass to let the manage know how to display a message.
 
 引入 identifier 的意图是支持多个状态的管理，配对的方式来管理消隐。目前设计只能同时显示一个
 */
@interface RFMessageManager : NSObject <
    RFInitializing
>

@property (readonly, nullable, nonatomic) id<RFMessage> displayingMessage;
@property (readonly, nonnull, nonatomic) NSArray<id<RFMessage>> *queuedMessages;

- (void)showMessage:(nonnull id<RFMessage>)message;

/**
 Hide message
 
 @param message if nil, do nothing.
 */
- (void)hideMessage:(nullable id<RFMessage>)message;

- (void)hideAll;

/**
 Hide all messages with the same identifier as the given parameter
 */
- (void)hideWithIdentifier:(nonnull NSString *)identifier;

/**
 Hide all messages with the same group identifier as the given parameter
 */
- (void)hideWithGroupIdentifier:(nonnull NSString *)groupIdentifier;

#pragma mark - Methods for overwrite.

/**
 
 The default implementation of this method does nothing.
 
 @param displayingMessage 目前显示的信息
 @param message 将要显示的信息
 */
- (void)replaceMessage:(nullable id<RFMessage>)displayingMessage withNewMessage:(nullable id<RFMessage>)message;

@end

@protocol RFMessage <NSObject>
@required
@property (copy, nonnull) NSString *identifier;
@property (copy, nonnull) NSString *groupIdentifier;
@property (copy, nullable) NSString *type;
@property (copy, nullable) NSString *message;
@property RFMessageDisplayPriority priority;

@optional
@property NSTimeInterval displayDuration;
@end
