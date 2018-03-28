/*!
 RFMessageManager (RFDisplay)
 
 Copyright (c) 2014, 2016, 2018 BB9z
 https://github.com/RFUI/Alpha
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import "RFMessageManager.h"

@interface RFMessageManager (RFDisplay)

/** 显示状态信息

 @param modal 是否以模态显示该信息，即显示时是否响应用户交互
 @param priority 状态优先级，会控制队列行为，优先显示高优先级的消息
 @param timeInterval 0 不自动隐藏
 @param identifier 标示，新加入的显示请求会替换掉排队中的有着相同标示的请求。为 nil 会被转换为 @""。
 */
- (void)showWithTitle:(nullable NSString *)title message:(nullable NSString *)message status:(RFNetworkActivityIndicatorStatus)status modal:(BOOL)modal priority:(RFNetworkActivityIndicatorMessagePriority)priority autoHideAfterTimeInterval:(NSTimeInterval)timeInterval identifier:(nullable NSString *)identifier groupIdentifier:(nullable NSString *)groupIdentifier userInfo:(nullable NSDictionary *)userInfo;

/** 显示请求进度

 @param progress 0～1，小于 0 表示进行中但无具体进度
 */
- (void)showProgress:(float)progress title:(nullable NSString *)title message:(nullable NSString *)message status:(RFNetworkActivityIndicatorStatus)status modal:(BOOL)modal identifier:(nullable NSString *)identifier userInfo:(nullable NSDictionary *)userInfo;

- (void)alertError:(nullable NSError *)error title:(nullable NSString *)title;
- (void)alertErrorWithMessage:(nullable NSString *)message;

@end
