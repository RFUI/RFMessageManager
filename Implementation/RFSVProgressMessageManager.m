
#import "RFSVProgressMessageManager.h"
#import "SVProgressHUD.h"
#import "RFNetworkActivityIndicatorMessage.h"

@interface RFSVProgressMessageManager ()
@property id RFSVProgressMessageManager_dismissObserver;
@property (nonatomic) BOOL RFSVProgressMessageManager_autoDismissObserving;
@end

@implementation RFSVProgressMessageManager

- (void)afterInit {
    [super afterInit];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
}

- (void)dealloc {
    self.RFSVProgressMessageManager_autoDismissObserving = NO;
}

- (void)replaceMessage:(RFNetworkActivityIndicatorMessage *)displayingMessage withNewMessage:(RFNetworkActivityIndicatorMessage *)message {
    [super replaceMessage:displayingMessage withNewMessage:message];

    if (!message) {
        [SVProgressHUD dismiss];
        return;
    }

    NSString *stautsString = (message.title.length && message.message.length)? [NSString stringWithFormat:@"%@: %@", message.title, message.message] : [NSString stringWithFormat:@"%@%@", message.title?: @"", message.message?: @""];

    SVProgressHUDMaskType maskType = message.modal ? SVProgressHUDMaskTypeBlack : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:maskType];
    switch (message.status) {
        case RFNetworkActivityIndicatorStatusSuccess: {
            self.RFSVProgressMessageManager_autoDismissObserving = YES;
            [SVProgressHUD showSuccessWithStatus:stautsString];
            break;
        }
        case RFNetworkActivityIndicatorStatusFail: {
            self.RFSVProgressMessageManager_autoDismissObserving = YES;
            [SVProgressHUD showErrorWithStatus:stautsString];
            break;
        }
        case RFNetworkActivityIndicatorStatusDownloading:
        case RFNetworkActivityIndicatorStatusUploading: {
            self.RFSVProgressMessageManager_autoDismissObserving = NO;
            [SVProgressHUD showProgress:message.progress status:stautsString];
        }
        case RFNetworkActivityIndicatorStatusLoading:
        default: {
            [SVProgressHUD showWithStatus:stautsString];
            if (message.displayTimeInterval > 0) {
                self.RFSVProgressMessageManager_autoDismissObserving = YES;
                [SVProgressHUD dismissWithDelay:message.displayTimeInterval];
            }
        }
    }
}

- (void)setRFSVProgressMessageManager_autoDismissObserving:(BOOL)observing {
    if (_RFSVProgressMessageManager_autoDismissObserving == observing) return;
    if (_RFSVProgressMessageManager_autoDismissObserving) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.RFSVProgressMessageManager_dismissObserver];
        self.RFSVProgressMessageManager_dismissObserver = nil;
    }
    _RFSVProgressMessageManager_autoDismissObserving = observing;
    if (observing) {
        @weakify(self);
        self.RFSVProgressMessageManager_dismissObserver = [[NSNotificationCenter defaultCenter] addObserverForName:SVProgressHUDDidDisappearNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            @strongify(self);
            RFNetworkActivityIndicatorMessage *msg = self.displayingMessage;
            if (msg) {
                RFAssert(msg.identifier, @"message identifier must not be nil");
                [self hideWithIdentifier:msg.identifier];
            }
        }];
    }
}

@end
