//
//  WCSChatView+Utilities.m
//  WCSChatViewE
//
//  Created by Aaron Wright on 4/18/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

@import Foundation;
@import UIKit;

#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]

@interface NSString (WCSChatView)
@end


@interface UIImage (WCSChatView)
+ (UIImage *)resizeWithImageName:(NSString *)name;
@end


@interface NSDate (TimeAgo)
- (NSString *) timeAgoSimple;
- (NSString *) timeAgo;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter;

// this method only returns "{value} {unit} ago" strings and no "yesterday"/"last month" strings
- (NSString *)dateTimeAgo;

// this method gives when possible the date compared to the current calendar date: "this morning"/"yesterday"/"last week"/..
// when more precision is needed (= less than 6 hours ago) it returns the same output as dateTimeAgo
- (NSString *)dateTimeUntilNow;
@end
