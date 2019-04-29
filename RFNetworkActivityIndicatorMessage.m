
#import "RFNetworkActivityIndicatorMessage.h"

@implementation RFNetworkActivityIndicatorMessage

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; message = %@; identifier = %@; priority = %d>", self.class, (void *)self, self.message, self.identifier, (int)self.priority];
}

- (instancetype)initWithIdentifier:(NSString *)identifier message:(NSString *)message status:(RFNetworkActivityIndicatorStatus)status {
    NSParameterAssert(identifier);
    self = [super init];
    if (self) {
        _identifier = identifier;
        _message = message;
        _status = status;
    }
    return self;
}

@end
