//
//  VideoListViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoModel.h"
#import "VideoCell.h"
#import "VideoLayout.h"
#import "MMPlayerLayerView.h"
#import <MJRefresh/MJRefresh.h>
#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"
static const CGFloat linePositionY = 200;
static NSString *cellID = @"VideoListViewController";
@interface VideoListViewController () <UITableViewDelegate, UITableViewDataSource, MMPlayerLayerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSIndexPath *lastPlayingIndexPath;
@property (nonatomic, strong) MMPlayerLayerView *playerView;
@property (nonatomic, strong) CALayer *line;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation VideoListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.indicatorView];
    [self _fetchDataFromNetWorking];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.playerView != nil) {
       [self.playerView play];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.playerView != nil) {
       [self.playerView pause];
    }
    
}
#pragma mark - private method
/** 获取到数据*/
- (void)_fetchDataFromNetWorking {
    NSURL *url = [NSURL URLWithString:videoListUrl];
    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            if (error != nil) {
                NSLog(@"网络无数据");
                return;
            }
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSArray *array = jsonDict[@"VAP4BFR16"];
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                VideoModel *model = [[VideoModel alloc] initWithSourceDictionary:dic];
                VideoLayout *layout = [[VideoLayout alloc] initWithSourceData:model];
                [self.dataArr addObject:layout];
            }];
            [self.view addSubview:self.tableView];
            [self.view.layer addSublayer:self.line];
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
    }];
    [task resume];
}

/** 滑动去切换播放*/
- (void)_updateCellVideoPlayer {
    NSIndexPath *currentIndexPath = [self _findThePlayerCellIndexPath];
    [self _exchangeVideoCurrentIndexPath:currentIndexPath lastIndexPath:self.lastPlayingIndexPath];
}


- (void)_exchangeVideoCurrentIndexPath:(NSIndexPath *)currentIndexPath
                        lastIndexPath:(NSIndexPath *)lastIndexPath {
    if (currentIndexPath.row == lastIndexPath.row && lastIndexPath != nil) return;
    if (self.lastPlayingIndexPath != nil) {
        VideoLayout *lastLayout = self.dataArr[lastIndexPath.row];
        lastLayout.model.isPlaying  = NO;
        [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    VideoLayout *layout = self.dataArr[currentIndexPath.row];
    layout.model.isPlaying = YES;
    [self.tableView reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    VideoCell *cell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
    [self playVideoWithTargetView:cell.videoPalyerView url:layout.model.mp4_url];
    self.lastPlayingIndexPath = currentIndexPath;
}

/** 找到绿色线的那个cell*/
- (NSIndexPath *)_findThePlayerCellIndexPath {
    for (VideoCell *cell in self.tableView.visibleCells) {
        CGRect rect = [self.tableView convertRect:cell.frame toView:self.view];
        if (CGRectContainsPoint(rect,CGPointMake(0, linePositionY))) {
            return [self.tableView indexPathForCell:cell];
        }
    }
    return nil;
}

/** 点击后滑动到顶部*/
- (void)_cellScrollToTopWithIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:1.0f animations:^{
      [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

/** 全屏播放*/
- (void)_animationToFullScreen {
    [[UIApplication sharedApplication].keyWindow addSubview:self.playerView];
    [UIView animateWithDuration:0.25 animations:^{
        self.playerView.frame = [[UIApplication sharedApplication].keyWindow bounds];
    }completion:^(BOOL finished) {
       [self.playerView addSubview:self.closeButton];
    }];
}

/** 小屏播放*/
- (void)_animationToSmallScreen {
    [self.closeButton removeFromSuperview];
    VideoCell *cell = [self.tableView cellForRowAtIndexPath:self.lastPlayingIndexPath];
    [cell.videoPalyerView addSubview:self.playerView];
    [UIView animateWithDuration:0.25 animations:^{
        self.playerView.frame = cell.videoPalyerView.bounds;
    }completion:^(BOOL finished) {
        
    }];
}
#pragma mark - UITableViewDataSource
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == 0) {
       [self _updateCellVideoPlayer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self _updateCellVideoPlayer];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   VideoLayout *layout = self.dataArr[indexPath.row];
    return layout.totalHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    VideoLayout *layout = self.dataArr[indexPath.row];
    cell.layout = layout;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoLayout *layout = self.dataArr[indexPath.row];
    if (!layout.model.isPlaying) {
        [self _cellScrollToTopWithIndexPath:indexPath];
        [self _exchangeVideoCurrentIndexPath:indexPath lastIndexPath:self.lastPlayingIndexPath];
    }
}

- (void)playVideoWithTargetView:(UIView *)targetView url:(NSURL *)url {
    if (self.playerView.superview ) {
        [self.playerView removeFromSuperview];
    }
    if (self.playerView == nil) {
        self.playerView = [[MMPlayerLayerView alloc]initWithFrame:targetView.bounds displayType:MMPlayerLayerViewDisplayWithOutTopBar sourceUrl:url];
        self.playerView.layerViewDelegate = self;
//        [self.playerView autoToPlay];
    }else{
        self.playerView.videoUrl = url;
    }
    [targetView addSubview:self.playerView];

}

#pragma mark - action
- (void)respondToCloseAction:(UIButton *)button {
    [self _animationToSmallScreen];
}

#pragma mark - MMVideoPlayerDelegate
/** 播放结束*/
- (void)playerLayerViewFinishedPlay:(MMPlayerLayerView *)playerLayerView {
    if (![self.playerView.superview isMemberOfClass:[UIWindow class]]) {
        NSUInteger row = (self.lastPlayingIndexPath.row == self.dataArr.count - 1 )?0:(self.lastPlayingIndexPath.row + 1);
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self _cellScrollToTopWithIndexPath:currentIndexPath];
        [self _exchangeVideoCurrentIndexPath:currentIndexPath lastIndexPath:self.lastPlayingIndexPath];
    }
}

- (void)playerLayerView:(MMPlayerLayerView *)playerLayerView currentViewOrientation:(MMPlayerLayerViewOrientation)viewOrientation {
    self.closeButton.hidden = (viewOrientation != MMPlayerLayerViewOrientationLandscapePortrait);
}

- (void)videoPlayerViewRespondsToTapPlayerViewAction:(MMPlayerLayerView *)playerLayerView {
   [self _animationToFullScreen];
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.decelerationRate = .01;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            NSLog(@"上啦加载更多");
            [_dataArr addObjectsFromArray:_dataArr];
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
        }];
        [_tableView registerClass:[VideoCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.size = CGSizeMake(30, 30);
        _indicatorView.center = self.view.center;
        _indicatorView.color = [UIColor blackColor];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

- (CALayer *)line {
    if (_line == nil) {
        _line = [CALayer layer];
        _line.frame = CGRectMake(0, linePositionY,kScreenWidth, 3.0/[UIScreen mainScreen].scale);
        _line.backgroundColor = [UIColor greenColor].CGColor;
    }
    return _line;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"Icon_Close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(respondToCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.frame = CGRectMake(0, 0, 40, 40);
    }
    return _closeButton;
}
@end
