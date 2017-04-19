# WCSChatView

Simple chat view with data model.

<img src="http://www.wrightscsapps.com/wcsopensource/screen/wcschatview.png" />

## Usage

Subclass the view controller you want to turn into a chat view.

```objc
@interface ViewController : WCSChatView

@end
```

#### Send a Message

```objc
- (void)sendMessage:(NSString *)message
{
    WCSChatModel * model = [[WCSChatModel alloc] init];
    model.timestamp = [NSDate date];
    model.message = message;
    model.type = WCSMessageTypeSent;
    model.icon = [UIImage imageNamed:@"chat-user-0"];
    
    WCSChatData * chatData = [WCSChatData new];
    chatData.model = model;
    [self.messages addObject:chatData];
    
    [self.tableView reloadData];
}
```

## Note

This example is a quick and dirty way to build a chat view. It's missing a lot of features and is mostly not complete but shoud be a good starting point for your next chat project. The views also do not use constraints. Maybe later I will update that.

## @WrightsCS

Twitter: @WrightsCS

http://www.wrightscsapps.com 

## Apps using WCSChatView

If you are using this in your app, please let me know and I will add your app here!
