/*!
 RFMessageManager
 
 Copyright © 2014, 2016, 2018-2020 BB9z
 https://github.com/RFUI/RFMessageManager
 
 The MIT License (MIT)
 http://www.opensource.org/licenses/mit-license.php
 */

#import <RFKit/RFRuntime.h>
#import <RFInitializing/RFInitializing.h>
#import "RFMessage.h"

/**
 RFMessageManager is an abstract class which can manage a set of message objects.

 Only one message will be displayed at the same time.

 Subclass to control how messages are displayed and changed.
 */
@interface RFMessageManager : NSObject <
    RFInitializing
>

/// Curently displaying message.
@property (readonly, nullable, nonatomic) id<RFMessage> displayingMessage;

/// Queued messages.
@property (readonly, nonnull, nonatomic) NSArray<id<RFMessage>> *queuedMessages;

/**
 Add a message about to display.

 Messages in manager could have the same identifier. But, it is not recommended to add multiple messages with the same identifier.

 @param message The identifier must not be nil.
 */
- (void)showMessage:(nonnull id<RFMessage>)message;

/**
 Hide message.
 
 @param message If nil, do nothing.
 */
- (void)hideMessage:(nullable id<RFMessage>)message;

/**
 Hide the currently displayed message and remove all queued messages.
 */
- (void)hideAll;

/**
 Hide all messages with the same identifier as the given parameter.
 */
- (void)hideWithIdentifier:(nonnull NSString *)identifier;

/**
 Hide all messages with the same group identifier as the given parameter.
 */
- (void)hideWithGroupIdentifier:(nonnull NSString *)groupIdentifier;

/**
 Update a message that is being displayed or the first in the queue with the same identifier.
 */
- (void)updateMessageOfIdentifier:(nonnull NSString *)identifier withMessage:(nonnull id<RFMessage>)message;

#pragma mark - Methods for overwrite.

/**
 Subclass should override this method to control how messages are displayed and changed.

 The default implementation of this method does nothing.
 
 @param displayingMessage The message currently displayed.
    If nil means there are no message is displaying.
 @param message A message to be displayed.
    May be the same as displayingMessage, which means the message is updated.
 */
- (void)replaceMessage:(nullable id<RFMessage>)displayingMessage withNewMessage:(nullable id<RFMessage>)message;

@end
