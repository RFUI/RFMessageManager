/*!
RFMessage

Copyright © 2019-2020 BB9z
https://github.com/RFUI/RFMessageManager

The MIT License (MIT)
http://www.opensource.org/licenses/mit-license.php
*/

#import <RFKit/RFRuntime.h>

/// Display priority. Messages with higher priority will be displayed first.
typedef NS_ENUM(NSInteger, RFMessageDisplayPriority) {
    /// Default, add to a queue if there are message displaying.
    RFMessageDisplayPriorityQueue = 0,
    /// Show immediately, does not change the queue.
    RFMessageDisplayPriorityHigh  = 750,
    /// Show immediately and clear the queue.
    RFMessageDisplayPriorityReset = 1000
};


/**
 Define message interface.
 */
@protocol RFMessage <NSObject>
@required

/// A string identifier for this message. May be used to update or hide messages.
@property (copy, nonnull) NSString *identifier;

/// The group identifier of this message. May be used to hide messages.
@property (copy, nullable) NSString *groupIdentifier;

/// Type string. Can be used to distinguish the display.
@property (copy, nullable) NSString *type;

/// Text to display.
@property (copy, nullable) NSString *message;

/// Display priority.
@property RFMessageDisplayPriority priority;

@optional

/// If great than zero, manager should automatically hide message after this time.
@property NSTimeInterval displayDuration;
@end
