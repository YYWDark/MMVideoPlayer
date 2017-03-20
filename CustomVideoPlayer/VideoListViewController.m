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
#import "MMVideoPlayer.h"
#import "VideoDetailViewController.h"
#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"
static const CGFloat linePositionY = 200;
static NSString *cellID = @"VideoListViewController";
@interface VideoListViewController () <UITableViewDelegate, UITableViewDataSource, MMVideoPlayerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSIndexPath *lastPlayingIndexPath;
@property (nonatomic, strong) MMVideoPlayer *player;
@property (nonatomic, strong) CALayer *line;
@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.dataArr = [NSMutableArray array];
    [self _fetchDataFromNetWorking];
}

- (void)_fetchDataFromNetWorking {
    NSURL *url = [NSURL URLWithString:videoListUrl];
    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.tableView];
            [self.view.layer addSublayer:self.line];
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
    }];
    [task resume];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player stopPlay];
}


- (void)updateCellVideoPlayer {
    NSIndexPath *currentIndexPath = [self findThePlayerCellIndexPath];
    [self exchangeVideoCurrentIndexPath:currentIndexPath lastIndexPath:self.lastPlayingIndexPath];
}

- (void)exchangeVideoCurrentIndexPath:(NSIndexPath *)currentIndexPath
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

- (NSIndexPath *)findThePlayerCellIndexPath {
    for (VideoCell *cell in self.tableView.visibleCells) {
        CGRect rect = [self.tableView convertRect:cell.frame toView:self.view];
        if (CGRectContainsPoint(rect,CGPointMake(0, linePositionY))) {
            return [self.tableView indexPathForCell:cell];
        }
    }
    
    return nil;
}

- (void)cellScrollToTopWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark - UITableViewDataSource
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == 0) {
       [self updateCellVideoPlayer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCellVideoPlayer];
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
    if (layout.model.isPlaying) { //当播放的时候跳到下个页面
        VideoDetailViewController *detailVC = [[VideoDetailViewController alloc] init];
        detailVC.mp4_url = layout.model.mp4_url;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else {
        [self cellScrollToTopWithIndexPath:indexPath];
        [self exchangeVideoCurrentIndexPath:indexPath lastIndexPath:self.lastPlayingIndexPath];
    }
}

- (void)playVideoWithTargetView:(UIView *)targetView url:(NSURL *)url {
    if (self.player.view.superview ) {
        [self.player.view removeFromSuperview];
    }
    
    if (self.player == nil) {
        self.player = [[MMVideoPlayer alloc] initWithURL:url topViewStatus:MMTopViewHiddenStatus];
    }else{
        self.player.videoUrl = url;
    }
   
    self.player.view.frame = targetView.bounds;
    [targetView addSubview:self.player.view];

}

#pragma mark - MMVideoPlayerDelegate
- (void)videoPlayerFinished:(MMVideoPlayer *)videoPlayer {
   
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  ) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.decelerationRate = .01;
        [_tableView registerClass:[VideoCell class] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}

- (CALayer *)line {
    if (_line == nil) {
        _line = [CALayer layer];
        _line.frame = CGRectMake(0, linePositionY,kScreenWidth, 3.0/[UIScreen mainScreen].scale);
        _line.backgroundColor = [UIColor redColor].CGColor;
    }
    return _line;
}
@end
