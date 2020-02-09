
#import "RFMessageManager+RFDisplay.h"
#import <RFKit/NSArray+RFKit.h>

@implementation RFMessageManager (RFDisplay)

- (void)alertError:(NSError *)error title:(NSString *)title fallbackMessage:(NSString *)fallbackMessage {
    NSMutableArray<NSString *> *errorFields = [NSMutableArray.alloc initWithCapacity:3];
    [errorFields rf_addObject:error.localizedDescription];
    [errorFields rf_addObject:error.localizedFailureReason];
    [errorFields rf_addObject:error.localizedRecoverySuggestion];
    if (!errorFields.count) {
        // If error has no text to display, use fallback one.
        [errorFields rf_addObject:fallbackMessage];
    }
    if (title.length) {
        // Display title at first.
        [errorFields insertObject:title atIndex:0];
    }
    NSString *message = [errorFields componentsJoinedByString:@"\n"];
    [self alertErrorWithMessage:message];
}

- (void)showWithMessage:(NSString *)message status:(RFNetworkActivityStatus)status modal:(BOOL)modal priority:(RFMessageDisplayPriority)priority autoHideAfterTimeInterval:(NSTimeInterval)timeInterval identifier:(NSString *)identifier groupIdentifier:(NSString *)groupIdentifier {
    
    RFNetworkActivityMessage *instance = [RFNetworkActivityMessage.alloc initWithIdentifier:identifier?: @"" message:message status:status];
    instance.groupIdentifier = groupIdentifier?: @"";
    instance.modal = modal;
    instance.priority = priority;
    instance.displayDuration = timeInterval;
    [self showMessage:instance];
}

- (void)showProgress:(float)progress message:(NSString *)message status:(RFNetworkActivityStatus)status modal:(BOOL)modal identifier:(NSString *)identifier {
    RFNetworkActivityMessage *instance = [RFNetworkActivityMessage.alloc initWithIdentifier:identifier?: @"" message:message status:status];
    instance.modal = modal;
    instance.progress = progress;
    [self showMessage:instance];
}

- (void)alertErrorWithMessage:(NSString *)message {
    [self showWithMessage:message status:RFNetworkActivityStatusFail modal:NO priority:RFMessageDisplayPriorityHigh autoHideAfterTimeInterval:0 identifier:nil groupIdentifier:nil];
}

@end
