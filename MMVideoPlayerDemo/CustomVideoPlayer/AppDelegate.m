//
//  AppDelegate.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application beginReceivingRemoteControlEvents];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UITabBarController *rootViewController = [story instantiateViewControllerWithIdentifier:@"MainVC"];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.loginBlock = ^(void) {
        self.window.rootViewController = loginViewController;
    };
    self.window.rootViewController = rootViewController;
    return YES;
}




@end
