//
//  AppDelegate.m
//  PurchaseMate
//
//  Created by Jacob Banks on 6/13/15.
//  Copyright (c) 2015 PurchaseMate. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "CWStatusBarNotification.h"

@interface AppDelegate ()

@property (strong, nonatomic) CWStatusBarNotification *networkErrorBar;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1.0] }
                                             forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1.0]];

    Reachability *reach = [Reachability reachabilityWithHostName:@"google.com"];
    reach.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideNetworkError];
            _isReachable = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showNetworkError];
            _isReachable = NO;
        });
    };
    
    [reach startNotifier];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showNetworkError{
    self.networkErrorBar = [CWStatusBarNotification new];
    
    _networkErrorBar.notificationLabelBackgroundColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:85.0/255.0 alpha:1.0];
    _networkErrorBar.notificationLabelTextColor = [UIColor whiteColor];
    self.networkErrorBar.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    self.networkErrorBar.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
    self.networkErrorBar.notificationStyle = CWNotificationStyleNavigationBarNotification;
    
    [_networkErrorBar displayNotificationWithMessage:@"No signal. Data connection required" completion:nil];
}

- (void)hideNetworkError {
    [self.networkErrorBar dismissNotification];
}

@end
