
#import "RFMessageManager+RFDisplay.h"
#import "dout.h"

@implementation RFMessageManager (RFDisplay)

- (void)alertError:(NSError *)error title:(NSString *)title {
    NSMutableString *message = [NSMutableString string];
    if (error.localizedDescription) {
        [message appendFormat:@"%@\n", error.localizedDescription];
    }
    if (error.localizedFailureReason) {
        [message appendFormat:@"%@\n", error.localizedFailureReason];
    }
    if (error.localizedRecoverySuggestion) {
        [message appendFormat:@"%@\n", error.localizedRecoverySuggestion];
    }
#if RFDEBUG
    dout_error(@"Error: %@ (%d), URL:%@", error.domain, (int)error.code, error.userInfo[NSURLErrorFailingURLErrorKey]);
#endif

    [self showWithTitle:title message:message status:RFNetworkActivityIndicatorStatusFail modal:NO priority:RFMessageDisplayPriorityHigh autoHideAfterTimeInterval:0 identifier:nil groupIdentifier:nil userInfo:nil];
}

- (void)showWithTitle:(NSString *)title message:(NSString *)message status:(RFNetworkActivityIndicatorStatus)status modal:(BOOL)modal priority:(RFMessageDisplayPriority)priority autoHideAfterTimeInterval:(NSTimeInterval)timeInterval identifier:(NSString *)identifier groupIdentifier:(NSString *)groupIdentifier userInfo:(NSDictionary *)userInfo {
    
    RFNetworkActivityIndicatorMessage *obj = [RFNetworkActivityIndicatorMessage messageWithConfiguration:^(RFNetworkActivityIndicatorMessage *instance) {
        instance.identifier = identifier?: @"";
        instance.groupIdentifier = groupIdentifier?: @"";
        instance.title = title;
        instance.message = message;
        instance.modal = modal;
        instance.status = status;
        instance.priority = priority;
        instance.userInfo = userInfo;
        instance.displayTimeInterval = timeInterval;
    } error:nil];
    [self showMessage:obj];
}

- (void)showProgress:(float)progress title:(NSString *)title message:(NSString *)message status:(RFNetworkActivityIndicatorStatus)status modal:(BOOL)modal identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo {
    RFNetworkActivityIndicatorMessage *obj = [RFNetworkActivityIndicatorMessage messageWithConfiguration:^(RFNetworkActivityIndicatorMessage *instance) {
        instance.identifier = identifier?: @"";
        instance.title = title;
        instance.message = message;
        instance.modal = modal;
        instance.progress = progress;
        instance.status = status;
        instance.userInfo = userInfo;
    } error:nil];
    [self showMessage:obj];
}

- (void)alertErrorWithMessage:(NSString *)message {
    [self showWithTitle:nil message:message status:RFNetworkActivityIndicatorStatusFail modal:NO priority:RFMessageDisplayPriorityHigh autoHideAfterTimeInterval:0 identifier:nil groupIdentifier:nil userInfo:nil];
}

@end
