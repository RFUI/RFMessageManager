
#import "RFNetworkActivityIndicatorMessage.h"

@implementation RFNetworkActivityIndicatorMessage

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; title = %@; message = %@; identifier = %@; priority = %d>", self.class, (void *)self, self.title, self.message, self.identifier, (int)self.priority];
}

- (NSString *)title {
    if (_title) return _title;
    return @"不能完成请求";
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.identifier = @"";
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title message:(NSString *)message status:(RFNetworkActivityIndicatorStatus)status {
    self = [self init];
    if (self) {
        self.identifier = identifier;
        _title = title;
        _message = message;
        _status = status;
    }
    return self;
}

@end
