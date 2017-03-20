//
//  VideoDetailViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/20.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "MMVideoPlayer.h"
@interface VideoDetailViewController ()
@property (nonatomic, strong) MMVideoPlayer *player;
@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [[MMVideoPlayer alloc] initWithURL:self.mp4_url topViewStatus:MMTopViewDisplayStatus];
    self.player.view.frame = self.view.frame;
    [self.view addSubview:self.player.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player stopPlay];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
