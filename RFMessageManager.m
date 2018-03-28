
#import "RFMessageManager.h"
#import "dout.h"

@interface RFMessageManager ()
@property (nonatomic) NSMutableArray<__kindof RFMessage *> *messageQueue;
@end

@implementation RFMessageManager
RFInitializingRootForNSObject

- (void)onInit {
}

- (void)afterInit {
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; displayingMessage = %@; messageQueue = %@>", self.class, (void *)self, self.displayingMessage, self.messageQueue];
}

- (NSMutableArray<__kindof RFMessage *> *)messageQueue {
    if (_messageQueue) return _messageQueue;
    _messageQueue = [NSMutableArray arrayWithCapacity:8];
    return _messageQueue;
}

- (void)hideWithGroupIdentifier:(NSString *)identifier {
    _dout_info(@"Hide message with group identifier: %@", identifier)

    if (!identifier) {
        [self.messageQueue removeAllObjects];
        [self hideWithIdentifier:self.displayingMessage.identifier];
        return;
    }

    [self.messageQueue filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K != %@", @keypathClassInstance(RFMessage, groupIdentifier), identifier]];

    if ([identifier isEqualToString:self.displayingMessage.groupIdentifier]) {
        [self hideWithIdentifier:self.displayingMessage.identifier];
    }

    _dout_info(@"After hideWithGroupIdentifier self = %@", self)
}

#pragma mark - Queue Manage
- (void)showMessage:(RFMessage *)message {
    _dout_info(@"Show message: %@", message)
    NSParameterAssert(message.identifier);

    // If not displaying any, display it
    if (!self.displayingMessage) {
        [self replaceMessage:self.displayingMessage withNewMessage:message];
        return;
    }

    if (message.priority >= RFMessageDisplayPriorityReset) {
        [self.messageQueue removeAllObjects];
        // Continue
    }

    if (message.priority >= RFMessageDisplayPriorityHigh) {
        [self replaceMessage:self.displayingMessage withNewMessage:message];
        return;
    }

    // Needs update queue, just add or replace
    NSUInteger ix = [self.messageQueue indexOfObject:message];
    if (ix != NSNotFound) {
        RFMessage *messageInQueue = (self.messageQueue)[ix];
        if (message.priority >= messageInQueue.priority) {
            // Readd it
            [self.messageQueue removeObject:message];
            [self.messageQueue addObject:message];
        }
        // Else ignore new message.
    }
    else {
        [self.messageQueue addObject:message];
    }
    _dout_info(@"After showMessage, self = %@", self);
}

- (void)hideWithIdentifier:(NSString *)identifier {
    _dout_info(@"Hide message with identifier: %@", identifier)

    if (!identifier) {
        [self.messageQueue removeAllObjects];
        [self replaceMessage:self.displayingMessage withNewMessage:[self popNextMessageToDisplay]];
        return;
    }

    RFMessage *toRemove = [RFMessage new];
    toRemove.identifier = identifier;
    [self.messageQueue removeObject:toRemove];

    if ([identifier isEqualToString:self.displayingMessage.identifier]) {
        [self replaceMessage:self.displayingMessage withNewMessage:[self popNextMessageToDisplay]];
    }
    _dout_info(@"After hideWithIdentifier, self = %@", self);
}

- (RFMessage *)popNextMessageToDisplay {
    RFMessageDisplayPriority ctPriority = (RFMessageDisplayPriority)NSIntegerMin;
    RFMessage *message;
    for (RFMessage *obj in self.messageQueue) {
        if (obj.priority > ctPriority) {
            ctPriority = obj.priority;
            message = obj;
        }
    }
    if (message) {
        [self.messageQueue removeObject:message];
    }
    return message;
}

#pragma mark - For overwrite
- (void)replaceMessage:(RFMessage *)displayingMessage withNewMessage:(RFMessage *)message {
    if (displayingMessage == message) return;
    self.displayingMessage = message;
}

@end

@implementation RFMessage
RFInitializingRootForNSObject

- (void)onInit {
}

- (void)afterInit {
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; identifier = %@; priority = %d>", self.class, (void *)self,  self.identifier, (int)self.priority];
}

+ (instancetype)messageWithConfiguration:(void (^)(__kindof RFMessage * _Nonnull))configBlock error:(NSError *__autoreleasing  _Nullable *)error {
    RFMessage *instance = self.new;
    if (configBlock) {
        configBlock(instance);
    }
    NSError *e = nil;
    if (![instance validateConfigurationError:&e]) {
        if (error) {
            *error = e;
        }
        return nil;
    }
    return instance;
}

- (BOOL)validateConfigurationError:(NSError *__autoreleasing  _Nullable *)error {
    if (!self.identifier) {
        *error = [NSError errorWithDomain:@"RFMessage" code:1 userInfo:@{ NSLocalizedDescriptionKey : @"RFMessage must have an identifier." }];
        return NO;
    }
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) return NO;
    return [self.identifier isEqualToString:[(RFMessage *)object identifier]];
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

@end
