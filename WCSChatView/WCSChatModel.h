//
//  WCSChatModel.h
//  WCSChatView
//
//  Created by Aaron Wright on 4/18/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WCSChatView+Utilities.h"

typedef NS_ENUM(NSInteger, WCSMessageType) {
    WCSMessageTypeSent = 0,
    WCSMessageTypeReceived = 1
};

@interface WCSChatModel : NSObject

@property (nonatomic, assign) BOOL hasTimestamp;
@property (nonatomic, copy) NSDate * timestamp;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, assign) WCSMessageType type;
@property (nonatomic, strong) UIImage * icon;

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary;

@end
