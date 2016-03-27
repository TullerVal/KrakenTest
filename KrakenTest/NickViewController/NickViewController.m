//
//  NickViewController.m
//  KrakenTest
//
//  Created by Valentin Tuller on 25.03.16.
//  Copyright © 2016 Valentin Tuller. All rights reserved.
//

#import "NickViewController.h"
#import "MessagesTableViewController.h"

@interface NickViewController () <UITextFieldDelegate> {
    IBOutlet UILabel *urlLabel;
    IBOutlet UITextField *nickTbx;
}

@end

@implementation NickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationItem.title = @"Введите ник";
    [nickTbx becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [nickTbx resignFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange: range withString: string];
    if( text.length > 30 )
        return NO;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( textField.text.length == 0 )
        return YES;
    [self openConnectionWithUrl: urlLabel.text andNick: textField.text];
    return YES;
}

#pragma mark Connection
-(void)openConnectionWithUrl:(NSString*)url andNick:(NSString*)nick {
    MessagesTableViewController *vc = [[MessagesTableViewController alloc] initWithNibName: @"MessagesTableViewController" bundle: nil];
    [vc startConnectionWithUrl: urlLabel.text andNick: nick];
    [self.navigationController pushViewController: vc animated: YES];
}

@end
