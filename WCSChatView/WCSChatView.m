//
//  WCSChatView.m
//  WCSChatView
//
//  Created by Aaron Wright on 4/18/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import "WCSChatView.h"
#import "WCSChatCell.h"
#import "WCSChatModel.h"

#define kWCSChatViewTextBoxPadding 50

@interface WCSChatView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) NSMutableArray * messages;

@end

@implementation WCSChatView

- (NSString*)historyPath {
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsPath = [dirPaths objectAtIndex:0];
    NSString * historyPath = [documentsPath stringByAppendingPathComponent:@"history.plist"];
    return historyPath;
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidChangeFrame:)
     name:UIKeyboardWillChangeFrameNotification
     object:nil
     ];
    
    self.inputView = [[UITextField alloc] initWithFrame:CGRectMake(5, SCREEN_BOUNDS.size.height - kWCSChatViewTextBoxPadding, SCREEN_BOUNDS.size.width-10, 45)];
    self.inputView.delegate = self;
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
    self.inputView.borderStyle = UITextBorderStyleRoundedRect;
    self.inputView.placeholder = @"Start typing...";
    [self.view addSubview:self.inputView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height - kWCSChatViewTextBoxPadding - 5) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadChat];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)reloadChat
{
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)sendMessage:(NSString *)message
{
    WCSChatModel * model = [[WCSChatModel alloc] init];
    model.timestamp = [NSDate date];
    model.message = message;
    model.type = arc4random_uniform(2); // WCSMessageTypeSent;
    model.icon = [UIImage imageNamed:[NSString stringWithFormat:@"chat-user-%u", arc4random_uniform(2)]];
    
    WCSChatData * chatData = [WCSChatData new];
    chatData.model = model;
    [self.messages addObject:chatData];
    
    [self appendHistory:chatData.dictionary onCompletion:^(BOOL success) {
        [self.tableView reloadData];
        [self scrollToBottom];
    }];
}

- (void)scrollToBottom {
    if ( self.messages.count > 1 ) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)appendHistory:(NSDictionary*)dictionary onCompletion:(void(^)(BOOL success))completionBlock
{
    NSMutableArray * historyArchive;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.historyPath];
    if ( fileExists )
        historyArchive = [[[NSMutableArray alloc] initWithContentsOfFile:self.historyPath] mutableCopy];
    else
        historyArchive = [NSMutableArray new];
    
    [historyArchive addObject:dictionary];
    completionBlock([historyArchive writeToFile:self.historyPath atomically:true]);
}

- (NSMutableArray *)messages
{
    if ( _messages == nil )
    {
        NSArray * history = [NSArray arrayWithContentsOfFile:self.historyPath];
        
        NSInteger index = 0;
        
        NSMutableArray * tempArray = [NSMutableArray array];
        for ( NSDictionary * dictionary in history )
        {
            NSString * chatIcon = [NSString stringWithFormat:@"chat-user-%u", arc4random_uniform(2)];
            
            WCSChatModel * model = [WCSChatModel messageWithDictionary:dictionary];
            model.icon = [UIImage imageNamed:chatIcon];
            WCSChatData * lastModel = nil;
            
            if ( tempArray.count > 1 ) {
                 lastModel = [tempArray objectAtIndex:index - 1];
            }
            
            index++;
            
            if ( lastModel.model.timestamp != nil )
            {
                NSInteger minutes = [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute
                                                                     fromDate:lastModel.model.timestamp
                                                                       toDate:model.timestamp
                                                                      options:0] minute];
                model.hasTimestamp = minutes >= 5 ? true : false;
            }
            else
                model.hasTimestamp = true;
            
            WCSChatData * chatData = [WCSChatData new];
            chatData.model = model;
            
            [tempArray addObject:chatData];
        }
        _messages = tempArray;
    }
    return _messages;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCSChatData * chatData = self.messages[indexPath.row];
    return chatData.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCSChatCell * cell = [WCSChatCell messageCellWithTableView:tableView];
    WCSChatData * chatData = self.messages[indexPath.row];
    cell.chatData = chatData;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField.text.length >= 1 ) {
        [self sendMessage:textField.text];
        textField.text = @"";
    }
    return YES;
}

#pragma mark - Keyboard Observer

- (void)keyboardDidChangeFrame:(NSNotification *)noti
{
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyY = frame.origin.y;

    CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
    CGFloat keyDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:keyDuration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyY - screenH);
    }];
    
}

@end
