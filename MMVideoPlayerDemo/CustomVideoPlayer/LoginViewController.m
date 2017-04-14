//
//  LoginViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/4/14.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "LoginViewController.h"
#import "MMPlayerLayerView.h"
#define  url  [[NSBundle mainBundle] URLForResource:@"a" withExtension:@"mp4"]

@interface LoginViewController () <MMPlayerLayerViewDelegate>
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MMPlayerLayerView *playerView = [[MMPlayerLayerView alloc]initWithFrame:self.view.bounds displayType:MMPlayerLayerViewDisplayNone sourceUrl:url];
    playerView.isMute = NO;
    playerView.layerViewDelegate = self;
    [self.view addSubview:playerView];
    [self.view addSubview:self.loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playerLayerViewFinishedPlay:(MMPlayerLayerView *)playerLayerView {
    [playerLayerView play];
}

- (void)respondsToTapAction:(UIButton *)sender {
    if (self.loginBlock) self.loginBlock();
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(25, self.view.frame.size.height - 60, self.view.frame.size.width - 50, 40);
        _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _loginButton.layer.borderWidth = 1.0f;
        [_loginButton addTarget:self action:@selector(respondsToTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitle:@"Touch  Me  Baby" forState:UIControlStateNormal];
    }
    return _loginButton;
}
@end
