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
#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"
static NSString *cellID = @"VideoListViewController";
@interface VideoListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSIndexPath *lastPlayingIndexPath;
@property (nonatomic, strong) MMVideoPlayer *player;
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
    //dataTask所有的任务都是由session引起的
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"网络无数据");
            return;
        }
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *array = jsonDict[@"VAP4BFR16"];
        [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            VideoModel *model = [VideoModel videomodelWithCover:dic[@"cover"]
                                                       videoUrl:dic[@"mp4_url"]
                                                     videoTitle:dic[@"title"]];
            VideoLayout *layout = [[VideoLayout alloc] initWithSourceData:model];
            [self.dataArr addObject:layout];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.tableView];
        });
    }];
    [task resume];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player stopPlay];
}
#pragma mark - UITableViewDataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.lastPlayingIndexPath != nil) {
        VideoCell *cell = [self.tableView cellForRowAtIndexPath:self.lastPlayingIndexPath];
        if (![self.tableView.visibleCells containsObject:cell]) {
            VideoLayout *layout = self.dataArr[self.lastPlayingIndexPath.row];
            layout.model.isPlaying = NO;
            [self.tableView reloadRowsAtIndexPaths:@[self.lastPlayingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            self.lastPlayingIndexPath = nil;
            [self.player stopPlay];
            self.player = nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   VideoLayout *layout = self.dataArr[indexPath.row];
    return layout.totalHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    VideoLayout *layout = self.dataArr[indexPath.row];
    cell.layout = layout;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.lastPlayingIndexPath.row == indexPath.row) return;
    VideoLayout *layout = self.dataArr[indexPath.row];
    if (layout.model.isPlaying) {
        
    }else {
        layout.model.isPlaying = YES;
        
        if (self.lastPlayingIndexPath != nil) {
              VideoLayout *layout = self.dataArr[self.lastPlayingIndexPath.row];
              layout.model.isPlaying = NO;
              [self.tableView reloadRowsAtIndexPaths:@[self.lastPlayingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        self.lastPlayingIndexPath = indexPath;
        
        VideoCell *cell = [self.tableView cellForRowAtIndexPath:self.lastPlayingIndexPath];
        [self playVideoWithTargetView:cell.videoPalyerView url:layout.model.mp4_url];
    }
}

- (void)playVideoWithTargetView:(UIView *)targetView url:(NSURL *)url{
//    NSURL *locationUrl  = [[NSBundle mainBundle] URLForResource:@"中国合伙人" withExtension:@"mp4"];
    if (self.player.view.superview ) {
        [self.player.view removeFromSuperview];
    }
    
    if (self.player == nil) {
        self.player = [[MMVideoPlayer alloc] initWithURL:url topViewStatus:MMTopViewHiddenStatus];
    }else{
        self.player.videoUrl = url;
    }
   
        self.player.view.frame = targetView.frame;
        [targetView addSubview:self.player.view];

}
#pragma mark - Getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  ) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VideoCell class] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}
@end
