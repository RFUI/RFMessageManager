
#import "RFMessageManager+RFDisplay.h"
#import <RFKit/NSArray+RFKit.h>

@implementation RFMessageManager (RFDisplay)

- (void)alertError:(NSError *)error title:(NSString *)title {
    NSMutableArray<NSString *> *errorFields = [NSMutableArray.alloc initWithCapacity:3];
    [errorFields rf_addObject:error.localizedDescription];
    [errorFields rf_addObject:error.localizedFailureReason];
    [errorFields rf_addObject:error.localizedRecoverySuggestion];
    NSString *errorString = [errorFields componentsJoinedByString:@"\n"];
    NSString *message = title;
    if (message.length) {
        message = [message stringByAppendingFormat:@": %@", errorString];
    }
    else {
        message = errorString;
    }
    [self showWithMessage:message status:RFNetworkActivityIndicatorStatusFail modal:NO priority:RFMessageDisplayPriorityHigh autoHideAfterTimeInterval:0 identifier:nil groupIdentifier:nil];
}

- (void)showWithMessage:(NSString *)message status:(RFNetworkActivityIndicatorStatus)status modal:(BOOL)modal priority:(RFMessageDisplayPriority)priority autoHideAfterTimeInterval:(NSTimeInterval)timeInterval identifier:(NSString *)identifier groupIdentifier:(NSString *)groupIdentifier {
    
    RFNetworkActivityIndicatorMessage *instance = [RFNetworkActivityIndicatorMessage.alloc initWithIdentifier:identifier?: @"" message:message status:status];
    instance.groupIdentifier = groupIdentifier?: @"";
    instance.modal = modal;
    instance.priority = priority;
    instance.displayDuration = timeInterval;
    [self showMessage:instance];
}

- (void)showProgress:(float)progress message:(NSString *)message status:(RFNetworkActivityIndicatorStatus)status modal:(BOOL)modal identifier:(NSString *)identifier {
    RFNetworkActivityIndicatorMessage *instance = [RFNetworkActivityIndicatorMessage.alloc initWithIdentifier:identifier?: @"" message:message status:status];
    instance.modal = modal;
    instance.progress = progress;
    [self showMessage:instance];
}

- (void)alertErrorWithMessage:(NSString *)message {
    [self showWithMessage:message status:RFNetworkActivityIndicatorStatusFail modal:NO priority:RFMessageDisplayPriorityHigh autoHideAfterTimeInterval:0 identifier:nil groupIdentifier:nil];
}

@end
