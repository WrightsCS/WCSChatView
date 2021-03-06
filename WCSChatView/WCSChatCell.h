//
//  WCSChatCell.h
//  WCSChatView
//
//  Created by Aaron Wright on 4/18/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCSChatModel.h"


@interface WCSChatData : NSObject

@property (nonatomic, strong) WCSChatModel * model;
@property (nonatomic, assign, readonly) CGRect timestampFrame;
@property (nonatomic, assign, readonly) CGRect contentFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) NSDictionary * dictionary;

@end

@interface WCSChatCell : UITableViewCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableview;

@property (nonatomic, strong) WCSChatData * chatData;

@end
