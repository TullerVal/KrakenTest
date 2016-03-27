//
//  MessagesTableViewController.m
//  KrakenTest
//
//  Created by Valentin Tuller on 25.03.16.
//  Copyright © 2016 Valentin Tuller. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "WSDSocket.h"

@interface MessagesTableViewController () <UITableViewDataSource, UITableViewDelegate, WSDSocketDelegate, UITextFieldDelegate> {
    IBOutlet UITextField *messageTbx;
    IBOutlet UITableView *messagesTable;
    NSMutableArray *messages;
    WSDSocket *socket;
    NSString *userNick;
}
@end

@implementation MessagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationItem.title = @"Чат";
    [messageTbx becomeFirstResponder];
}

-(void)dealloc {
    [socket close];
    socket.delegate = nil;
    socket = nil;
}

#pragma mark Messages
-(void)startConnectionWithUrl:(NSString*)url andNick:(NSString*)nick {
    userNick = nick;
    socket = [[WSDSocket alloc] initWithUrl: url];
    socket.delegate = self;
    [socket open];
}

-(void)sendMessage:(NSString*)message withNick:(NSString*)nick isSystem:(BOOL)isSystem {
    if( isSystem == YES )
        [socket sendString: [NSString stringWithFormat: @"[\"%@\"]", message]];
    else
        [socket sendString: [NSString stringWithFormat: @"[\"%@: %@\"]", nick, message]];
}

-(void)appendMessage:(NSString*)message {
    [messages addObject: message];
    if( messages.count > 50 )
        [messages removeObjectAtIndex: 0];
    [messagesTable reloadData];
    [messagesTable scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: messages.count-1 inSection:0]
                          atScrollPosition: UITableViewScrollPositionBottom
                                  animated: YES];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange: range withString: string];
    if( text.length + userNick.length > 70 )
        return NO;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( textField.text.length == 0 )
        return YES;
    [self sendMessage: textField.text withNick: userNick isSystem: NO];
    textField.text = @"";
    return YES;
}

#pragma mark WSDSocketDelegate
- (void)socketDidOpen:(WSDSocket *)socket {
    messages = [NSMutableArray array];
    [self sendMessage: [NSString stringWithFormat: @"%@ joined", userNick] withNick: nil isSystem: YES];
}

- (void)socket:(WSDSocket *)socket didReceiveMessage:(NSString *)message {
    NSLog(@"didReceiveMessage %@", message);
    if( [message hasPrefix: @"a[\""] == YES && message.length > 4 ) {
        message = [message substringWithRange: NSMakeRange( 3, message.length-5)];
        [self appendMessage: message];
    }
}

- (void)socket:(WSDSocket *)socket didFailWithError:(NSError *)error {
//    [self appendMessage: [NSString stringWithFormat: @"didFailWithError %ld", (long)error.code]];
    [self showBackAlertWithMessage: @"Connection failed. Reconnect?"];
}

- (void)socket:(WSDSocket *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
//    [self appendMessage: [NSString stringWithFormat: @"didCloseWithCode %ld", code]];
    [self showBackAlertWithMessage: @"Connection closed. Reconnect?"];
}

-(void)showBackAlertWithMessage:(NSString*)message {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: nil message: message
                                  preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                             [alert dismissViewControllerAnimated: NO completion:nil];
                            [self.navigationController popViewControllerAnimated: YES];
    }];
    [alert addAction: okAction];
    [self presentViewController: alert animated: YES completion: nil];
}

#pragma mark Table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = messages[indexPath.row];
    
    return cell;
}


@end
