
#import "RFSVProgressMessageManager.h"
#import "SVProgressHUD.h"

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

- (NSString *)displayStringForMessage:(RFNetworkActivityMessage *)msg {
    return msg.message.length ? msg.message : nil;
}

- (void)replaceMessage:(id<RFMessage>)displayingMessage withNewMessage:(id<RFMessage>)aMessage {
    RFNetworkActivityMessage *message = aMessage;
    if (message) {
        NSParameterAssert([message isKindOfClass:RFNetworkActivityMessage.class]);
    }
    [super replaceMessage:displayingMessage withNewMessage:message];

    if (!message) {
        [SVProgressHUD dismiss];
        return;
    }

    NSString *stautsString = [self displayStringForMessage:message];

    SVProgressHUDMaskType maskType = message.modal ? SVProgressHUDMaskTypeBlack : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:maskType];
    switch (message.status) {
        case RFNetworkActivityStatusSuccess: {
            self.RFSVProgressMessageManager_autoDismissObserving = YES;
            [SVProgressHUD showSuccessWithStatus:stautsString];
            break;
        }
        case RFNetworkActivityStatusFail: {
            self.RFSVProgressMessageManager_autoDismissObserving = YES;
            [SVProgressHUD showErrorWithStatus:stautsString];
            break;
        }
        case RFNetworkActivityStatusInfo: {
            self.RFSVProgressMessageManager_autoDismissObserving = YES;
            [SVProgressHUD showInfoWithStatus:stautsString];
            break;
        }
        case RFNetworkActivityStatusDownloading:
        case RFNetworkActivityStatusUploading: {
            self.RFSVProgressMessageManager_autoDismissObserving = NO;
            [SVProgressHUD showProgress:message.progress status:stautsString];
            break;
        }
        case RFNetworkActivityStatusLoading:
        default: {
            [SVProgressHUD showWithStatus:stautsString];
            if (message.displayDuration > 0) {
                self.RFSVProgressMessageManager_autoDismissObserving = YES;
                [SVProgressHUD dismissWithDelay:message.displayDuration];
            }
            break;
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
            [self hideMessage:self.displayingMessage];
        }];
    }
}

@end
