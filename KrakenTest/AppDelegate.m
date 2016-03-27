//
//  AppDelegate.m
//  KrakenTest
//
//  Created by Valentin Tuller on 25.03.16.
//  Copyright © 2016 Valentin Tuller. All rights reserved.
//

#import "AppDelegate.h"
#import "NickViewController.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    NickViewController *vc = [[NickViewController alloc] initWithNibName: @"NickViewController" bundle: nil];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController: vc];
    self.window.rootViewController = navVc;

    return YES;
}


@end
