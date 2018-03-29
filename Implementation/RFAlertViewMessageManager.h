/*!
 RFAlertViewMessageManager
 RFMessageManager
 
 Copyright (c) 2014, 2018 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import "RFMessageManager.h"
#import "RFNetworkActivityIndicatorMessage.h"

/**
 RFMessageManager display using UIAlertView.
 
 All message object should be RFNetworkActivityIndicatorMessage.
 
 - Only display message which status is RFNetworkActivityIndicatorStatusFail.
 */
@interface RFAlertViewMessageManager : RFMessageManager <
    UIAlertViewDelegate
>

@end
