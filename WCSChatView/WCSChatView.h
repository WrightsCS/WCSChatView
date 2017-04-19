//
//  WCSChatView.h
//  WCSChatView
//
//  Created by Aaron Wright on 4/18/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface WCSChatView : UIViewController

- (void)reloadChat;
- (void)sendMessage:(NSString *)message;

@end
