//
//  WCSChatModel.m
//  WCSChatView
//
//  Created by Aaron Wright on 4/18/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import "WCSChatModel.h"

@implementation WCSChatModel

- (NSString*)description {
    return [NSString stringWithFormat:@"<<WCSChatModel:> timestamp=%@, message=%@, type=%@>",
            self.timestamp,
            self.message,
            self.typeString
            ];
}

- (NSString*)typeString {
    NSString * typeString = @"WCSMessageTypeUnknown";
    switch ( self.type ) {
        case WCSMessageTypeSent: {
            typeString = @"WCSMessageTypeSent";
            break;
        }
        case WCSMessageTypeReceived: {
            typeString = @"WCSMessageTypeReceived";
            break;
        }
    }
    return typeString;
}

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

@end
