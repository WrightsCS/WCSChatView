//
//  ViewController.m
//  WCSChatView
//
//  Created by Aaron Wright on 4/18/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"WCSChatView Example";
    
    [self sendMessage:@"ViewCotroller loaded."];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
