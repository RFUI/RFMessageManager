/*!
 RFNetworkActivityIndicatorMessage
 RFMessageManager
 
 Copyright (c) 2018 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import "RFMessageManager.h"

typedef NS_ENUM(short, RFNetworkActivityIndicatorStatus) {
    RFNetworkActivityIndicatorStatusLoading = 0,
    RFNetworkActivityIndicatorStatusSuccess,
    RFNetworkActivityIndicatorStatusFail,
    
    RFNetworkActivityIndicatorStatusDownloading,
    RFNetworkActivityIndicatorStatusUploading
};

@interface RFNetworkActivityIndicatorMessage : RFMessage
@property (nonatomic, null_resettable, copy) NSString *title;
@property (nullable, copy) NSString *message;
@property RFNetworkActivityIndicatorStatus status;
@property BOOL modal;
@property float progress;
@property NSTimeInterval displayTimeInterval;

@property (nullable) NSDictionary *userInfo;

- (nonnull instancetype)initWithIdentifier:(nonnull NSString *)identifier title:(nullable NSString *)title message:(nullable NSString *)message status:(RFNetworkActivityIndicatorStatus)status API_DEPRECATED_WITH_REPLACEMENT("messageWithConfiguration:error:", macos(10.6, 10.13), ios(2.0, 11.0), watchos(2.0, 4.0), tvos(9.0, 11.0));
@end
