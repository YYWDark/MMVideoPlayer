//
//  ViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/2/26.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "ViewController.h"
#import "VideoListViewController.h"
static const CGFloat kNavigationHeight = 0.0;
static NSString *cellID = @"UITableViewCell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Video Type";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListViewController *listViewController = [[VideoListViewController alloc] init];
    [self.navigationController pushViewController:listViewController animated:YES];
    
}
#pragma mark - Getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, self.view.frame.size.width, self.view.frame.size.height - kNavigationHeight ) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = YES;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        _dataArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    return _dataArr;
}

@end
/*
 //@property (nonatomic, strong) AVPlayer *player;
 @property (nonatomic, strong) UIView *containerView;
 @property (nonatomic, strong) MMVideoPlayer *player;
 //     static const NSString *PlayerItemStatusContext;
 //     NSURL *remoteUrl  =  [NSURL URLWithString:@"http://flv2.bn.netease.com/videolib3/1703/10/fzWKV7960/SD/fzWKV7960-mobile.mp4"];
 //     NSURL *locationUrl  = [[NSBundle mainBundle] URLForResource:@"b" withExtension:@"mp4"];
 //     self.player = [[MMVideoPlayer alloc] initWithURL:remoteUrl];
 //     self.player.view.frame = self.view.frame;
 //    [self.view addSubview:self.player.view];
 
 NSString * const kCTVideoViewKVOKeyPathPlayerItemStatus = @"player.currentItem.status";
 NSString * const kCTVideoViewKVOKeyPathPlayerItemDuration = @"player.currentItem.duration";
 NSString * const kCTVideoViewKVOKeyPathLayerReadyForDisplay = @"layer.readyForDisplay";
 
 //    NSArray *keys = @[
 //                      @"tracks",
 //                      @"duration",
 //                      @"commonMetadata",
 //                      @"availableMediaCharacteristicsWithMediaSelectionOptions"
 //                      ];
 //
 //    NSURL *assrtUrl = [[NSBundle mainBundle] URLForResource:@"a" withExtension:@"mp4"];
 //    AVAsset *asset = [AVAsset assetWithURL:assrtUrl];
 //    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keys];
 //add kvo
 //    [playerItem addObserver:self
 //                 forKeyPath:@"status"
 //                    options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
 //                    context:&PlayerItemStatusContext];
 //notification
 //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAVPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
 //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAVPlayerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:nil];
 
 //    self.player = [AVPlayer playerWithPlayerItem:playerItem];
 //    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
 //    playerLayer.frame=CGRectMake(0, 100, self.view.frame.size.width, 300);
 //    [self.view.layer addSublayer:playerLayer];
 //    [self.player play];
 
 
 //kvo
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
 // Only handle observations for the PlayerItemContext
 if (context != &PlayerItemStatusContext) {
 [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
 return;
 }
 
 if ([keyPath isEqualToString:@"status"]) {
 AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
 // Get the status change from the change dictionary
 NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
 if ([statusNumber isKindOfClass:[NSNumber class]]) {
 status = statusNumber.integerValue;
 }
 // Switch over the status
 switch (status) {
 case AVPlayerItemStatusReadyToPlay:
 // Ready to Play
 break;
 case AVPlayerItemStatusFailed:
 // Failed. Examine AVPlayerItem.error
 break;
 case AVPlayerItemStatusUnknown:
 // Not ready
 break;
 }
 }
 }
 
 #pragma mark - Notification
 - (void)didReceiveAVPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification {
 NSLog(@"播放结束了");
 }
 
 - (void)didReceiveAVPlayerItemPlaybackStalledNotification:(NSNotification *)notification {
 
 }
 */




 


 


