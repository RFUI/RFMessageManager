
#import "RFMessageManager.h"
#import "NSArray+RFKit.h"

@interface RFMessageManager ()
@property (nonatomic) NSMutableArray<__kindof RFMessage *> *_RFMessageManager_messageQueue;
@property (nullable) __kindof RFMessage *_RFMessageManager_displayingMessage;
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

- (RFMessage *)displayingMessage {
    return self._RFMessageManager_displayingMessage;
}

- (NSArray<RFMessage *> *)queuedMessages {
    return self._RFMessageManager_messageQueue.copy;
}

#pragma mark - Queue Manage

- (NSMutableArray<__kindof RFMessage *> *)_RFMessageManager_messageQueue {
    if (__RFMessageManager_messageQueue) return __RFMessageManager_messageQueue;
    __RFMessageManager_messageQueue = [NSMutableArray arrayWithCapacity:8];
    return __RFMessageManager_messageQueue;
}

- (void)showMessage:(RFMessage *)message {
    NSParameterAssert(message.identifier);

    // If not displaying any, display it
    RFMessage *dm = self._RFMessageManager_displayingMessage;
    if (!dm) {
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

    // Needs update queue, just add or replace
    NSUInteger ix = [mq indexOfObject:message];
    if (ix != NSNotFound) {
        RFMessage *messageInQueue = mq[ix];
        if (message.priority >= messageInQueue.priority) {
            // Readd it
            [mq removeObject:message];
            [mq addObject:message];
        }
        // Else ignore new message.
    }
    else {
        [mq addObject:message];
    }
}

- (void)hideMessage:(__kindof RFMessage *)message {
    if (!message) return;
    RFMessage *dm = self._RFMessageManager_displayingMessage;
    if (dm == message) {
        [self _RFMessageManager_replaceMessage:dm withNewMessage:self._RFMessageManager_popNextMessageToDisplay];
        return;
    }
    else {
        [self._RFMessageManager_messageQueue removeObject:message];
    }
}

- (void)hideWithIdentifier:(NSString *)identifier {
    RFMessage *dm = self._RFMessageManager_displayingMessage;
    if (!identifier) {
        [self._RFMessageManager_messageQueue removeAllObjects];
        [self _RFMessageManager_replaceMessage:dm withNewMessage:self._RFMessageManager_popNextMessageToDisplay];
        return;
    }

    [self._RFMessageManager_messageQueue removeObjectsPassingTest:^BOOL(__kindof RFMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.identifier isEqualToString:identifier];
    }];

    if ([identifier isEqualToString:dm.identifier]) {
        [self _RFMessageManager_replaceMessage:dm withNewMessage:self._RFMessageManager_popNextMessageToDisplay];
    }
}

- (void)hideWithGroupIdentifier:(NSString *)identifier {
    RFMessage *dm = self._RFMessageManager_displayingMessage;
    if (!identifier) {
        [self._RFMessageManager_messageQueue removeAllObjects];
        [self hideWithIdentifier:dm.identifier];
        return;
    }
    
    [self._RFMessageManager_messageQueue filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K != %@", @keypathClassInstance(RFMessage, groupIdentifier), identifier]];
    
    if ([dm.groupIdentifier isEqualToString:identifier]) {
        [self hideWithIdentifier:dm.identifier];
    }
}

- (RFMessage *)_RFMessageManager_popNextMessageToDisplay {
    RFMessageDisplayPriority ctPriority = (RFMessageDisplayPriority)NSIntegerMin;
    NSMutableArray *mq = self._RFMessageManager_messageQueue;
    RFMessage *message = nil;
    for (RFMessage *obj in mq) {
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

- (void)_RFMessageManager_replaceMessage:(RFMessage *)displayingMessage withNewMessage:(RFMessage *)message {
    if (displayingMessage == message) return;
    self._RFMessageManager_displayingMessage = message;
    [self replaceMessage:displayingMessage withNewMessage:message];
}

- (void)replaceMessage:(nullable __kindof RFMessage *)displayingMessage withNewMessage:(nullable __kindof RFMessage *)message {
    // for overwrite
}

@end

static NSString *const RFMessageIdentifierNotSet = @"_no_identifier_";

@implementation RFMessage

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        if (RFMessageIdentifierNotSet != identifier) {
            _identifier = identifier;
        }
        [self onInit];
        [self performSelector:@selector(afterInit) withObject:self afterDelay:0];
    }
    return self;
}

- (instancetype)init {
    return [self initWithIdentifier:RFMessageIdentifierNotSet];
}

- (void)onInit {
}

- (void)afterInit {
    if (!self.identifier) {
        NSLog(@"%@ don't have an identifier.", self);
    }
}

- (NSString *)description {
    NSMutableArray *part = [NSMutableArray.alloc initWithCapacity:4];
    [part addObject:[NSString stringWithFormat:@"identifier = %@", self.identifier]];
    if (self.groupIdentifier) {
        [part addObject:[NSString stringWithFormat:@"groupIdentifier = %@", self.groupIdentifier]];
    }
    [part addObject:[NSString stringWithFormat:@"priority = %d", (int)self.priority]];
    return [NSString stringWithFormat:@"<%@: %p; %@>", self.class, (void *)self, [part componentsJoinedByString:@"; "]];
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
