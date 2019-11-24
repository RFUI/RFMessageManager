
#import "RFMessageManager.h"
#import "NSArray+RFKit.h"

@interface RFMessageManager ()
@property (nonatomic) NSMutableArray<id<RFMessage>> *_RFMessageManager_messageQueue;
@property (nullable) id<RFMessage> _RFMessageManager_displayingMessage;
@end

@implementation RFMessageManager
RFInitializingRootForNSObject

- (void)onInit {
}

- (void)afterInit {
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; displayingMessage = %@; messageQueue = %@>", self.class, (void *)self, self._RFMessageManager_displayingMessage, self._RFMessageManager_messageQueue];
}

- (id<RFMessage>)displayingMessage {
    return self._RFMessageManager_displayingMessage;
}

- (NSArray<id<RFMessage>> *)queuedMessages {
    return self._RFMessageManager_messageQueue.copy;
}

#pragma mark - Queue Manage

- (NSMutableArray<__kindof id<RFMessage>> *)_RFMessageManager_messageQueue {
    if (__RFMessageManager_messageQueue) return __RFMessageManager_messageQueue;
    __RFMessageManager_messageQueue = [NSMutableArray arrayWithCapacity:8];
    return __RFMessageManager_messageQueue;
}

- (void)showMessage:(id<RFMessage>)message {
    NSParameterAssert(message.identifier);

    id<RFMessage>dm = self._RFMessageManager_displayingMessage;
    if (!dm) {
        // If not displaying any, display it
        [self _RFMessageManager_replaceMessage:dm withNewMessage:message];
        return;
    }

    NSMutableArray *mq = self._RFMessageManager_messageQueue;
    if (message.priority >= RFMessageDisplayPriorityReset) {
        [mq removeAllObjects];
        // Continue
    }
    
    if (message.priority >= RFMessageDisplayPriorityHigh) {
        [self _RFMessageManager_replaceMessage:dm withNewMessage:message];
        return;
    }

    if (![mq containsObject:message]) {
        [mq addObject:message];
    }
}

- (void)hideMessage:(__kindof id<RFMessage>)message {
    if (!message) return;
    id<RFMessage>dm = self._RFMessageManager_displayingMessage;
    if (dm == message) {
        [self _RFMessageManager_replaceMessage:dm withNewMessage:self._RFMessageManager_popNextMessageToDisplay];
        return;
    }
    else {
        [self._RFMessageManager_messageQueue removeObject:message];
    }
}

- (void)hideAll {
    [self._RFMessageManager_messageQueue removeAllObjects];
    id<RFMessage>dm = self._RFMessageManager_displayingMessage;
    if (dm) {
        [self _RFMessageManager_replaceMessage:dm withNewMessage:nil];
    }
}

- (void)hideWithIdentifier:(NSString *)identifier {
    if (!identifier) return;
    
    [self._RFMessageManager_messageQueue removeObjectsPassingTest:^BOOL(__kindof id<RFMessage> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.identifier isEqualToString:identifier];
    }];

    id<RFMessage>dm = self._RFMessageManager_displayingMessage;
    if ([identifier isEqualToString:dm.identifier]) {
        [self _RFMessageManager_replaceMessage:dm withNewMessage:self._RFMessageManager_popNextMessageToDisplay];
    }
}

- (void)hideWithGroupIdentifier:(NSString *)identifier {
    if (!identifier) return;

    [self._RFMessageManager_messageQueue removeObjectsPassingTest:^BOOL(id<RFMessage>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.groupIdentifier isEqualToString:identifier];
    }];
    
    id<RFMessage>dm = self._RFMessageManager_displayingMessage;
    if ([identifier isEqualToString:dm.groupIdentifier]) {
        [self _RFMessageManager_replaceMessage:dm withNewMessage:self._RFMessageManager_popNextMessageToDisplay];
    }
}

- (id<RFMessage>)_RFMessageManager_popNextMessageToDisplay {
    RFMessageDisplayPriority ctPriority = (RFMessageDisplayPriority)NSIntegerMin;
    NSMutableArray *mq = self._RFMessageManager_messageQueue;
    id<RFMessage>message = nil;
    for (id<RFMessage>obj in mq) {
        if (obj.priority > ctPriority) {
            ctPriority = obj.priority;
            message = obj;
        }
    }
    if (message) {
        [mq removeObject:message];
    }
    return message;
}

#pragma mark - For overwrite

- (void)_RFMessageManager_replaceMessage:(id<RFMessage>)displayingMessage withNewMessage:(id<RFMessage>)message {
    // Don't guard equal, it may show an message current displaying.
    self._RFMessageManager_displayingMessage = message;
    if (displayingMessage || message) {
        [self replaceMessage:displayingMessage withNewMessage:message];
    }
}

- (void)replaceMessage:(nullable __kindof id<RFMessage>)displayingMessage withNewMessage:(nullable __kindof id<RFMessage>)message {
    // for overwrite
}

@end
