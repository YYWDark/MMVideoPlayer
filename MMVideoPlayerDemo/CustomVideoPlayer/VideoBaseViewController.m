//
//  VideoBaseViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/4/6.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoBaseViewController.h"

@interface VideoBaseViewController ()

@end

@implementation VideoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightTextColor],NSForegroundColorAttributeName,nil]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
