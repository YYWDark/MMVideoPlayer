//
//  VideoDetailViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/20.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "MMPlayerLayerView.h"

@interface VideoDetailViewController () <MMPlayerLayerViewDelegate>
@property (nonatomic, strong) MMPlayerLayerView *playerView;
@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = NO;
    self.playerView = [[MMPlayerLayerView alloc] initWithFrame:self.view.bounds displayType:MMPlayerLayerViewDisplayWithDefectiveTopBar  sourceUrl:self.mp4_url];
    self.playerView.layerViewDelegate = self;
    [self.playerView autoToPlay];
    [self.view addSubview:self.playerView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - MMVideoPlayerDelegate
/** 播放结束*/
- (void)playerLayerViewFinishedPlay:(MMPlayerLayerView *)playerLayerView {
    NSLog(@"播放结束");
}

- (void)videoPlayerViewRespondsToBackAction:(MMPlayerLayerView *)videoPlayer {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
