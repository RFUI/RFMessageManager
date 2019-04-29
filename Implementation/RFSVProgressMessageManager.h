/*
 RFSVProgressMessageManager
 RFMessageManager
 
 Copyright © 2014, 2018-2019 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import "RFMessageManager.h"
#import "RFNetworkActivityIndicatorMessage.h"

/**
 RFMessageManager display using SVProgressHUD.
 
 All message object should be RFNetworkActivityIndicatorMessage.
 
 Limitation:
 
 - Only RFNetworkActivityIndicatorStatusLoading status support displayTimeInterval.
 - Message with RFNetworkActivityIndicatorStatusSuccess and RFNetworkActivityIndicatorStatusFail status displays using SVProgressHUD build-in duration.
 - Messages for downloading or uploading progress aren't dismiss automatically and have to hide manually or be replaced with success or fail message.
 */
@interface RFSVProgressMessageManager : RFMessageManager
@end
