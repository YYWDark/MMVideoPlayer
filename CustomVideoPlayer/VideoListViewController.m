//
//  VideoListViewController.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoListViewController.h"
#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"
@interface VideoListViewController ()

@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _fetchDataFromNetWorking];
}

- (void)_fetchDataFromNetWorking {
    NSURL *url = [NSURL URLWithString:videoListUrl];
    NSURLSession *session  = [NSURLSession sharedSession];
    //dataTask所有的任务都是由session引起的
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]);
        NSLog(@"%@",[NSThread currentThread]);
    }];
    [task resume];
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
