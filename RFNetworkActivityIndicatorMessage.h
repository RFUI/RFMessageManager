/*
 RFNetworkActivityIndicatorMessage
 RFMessageManager
 
 Copyright © 2018-2019 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import "RFMessageManager.h"

typedef NS_ENUM(short, RFNetworkActivityIndicatorStatus) {
    RFNetworkActivityIndicatorStatusLoading = 0,
    RFNetworkActivityIndicatorStatusSuccess,
    RFNetworkActivityIndicatorStatusFail,
    RFNetworkActivityIndicatorStatusInfo,
    
    RFNetworkActivityIndicatorStatusDownloading,
    RFNetworkActivityIndicatorStatusUploading
};

@interface RFNetworkActivityIndicatorMessage : NSObject <
    RFMessage
>
@property (copy, nonnull) NSString *identifier;
@property (copy, nonnull) NSString *groupIdentifier;
@property (copy, nullable) NSString *type;
@property (copy, nullable) NSString *message;

@property RFMessageDisplayPriority priority;
@property NSTimeInterval displayDuration;

@property RFNetworkActivityIndicatorStatus status;
@property BOOL modal;
@property float progress;

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithIdentifier:(nonnull NSString *)identifier message:(nullable NSString *)message status:(RFNetworkActivityIndicatorStatus)status NS_DESIGNATED_INITIALIZER;

@end
