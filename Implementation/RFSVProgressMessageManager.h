/*
 RFSVProgressMessageManager
 RFMessageManager
 
 Copyright © 2014, 2018-2019 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import "RFMessageManager.h"
#import "RFNetworkActivityMessage.h"

/**
 RFMessageManager display using SVProgressHUD.
 
 All message object should be RFNetworkActivityMessage.
 
 Limitation:
 
 - Only RFNetworkActivityStatusLoading status support displayTimeInterval.
 - Message with RFNetworkActivityStatusSuccess and RFNetworkActivityStatusFail status displays using SVProgressHUD build-in duration.
 - Messages for downloading or uploading progress aren't dismiss automatically and have to hide manually or be replaced with success or fail message.
 */
@interface RFSVProgressMessageManager : RFMessageManager
@end
