//
//  ThumbnailsView.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/8.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "ThumbnailsView.h"
#import "MMVideoHeader.h"
static NSString *cellIdentifer = @"ThumbnailsCell";
@interface ThumbnailsCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *timeLabel;
@end
@implementation ThumbnailsCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 30, self.width, 30)];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)setImageContent:(ThumbnailsImage *)imageContent {
    _imageView.image = imageContent.image;
    _timeLabel.text =  [NSString formatSeconds:imageContent.photoTime];
}

@end

@interface ThumbnailsView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *collctionView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation ThumbnailsView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.indicatorView];
        [self _addNotification];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collctionView.frame = self.bounds;
    self.indicatorView.frame = self.bounds;
}

- (void)dealloc {
    NSLog(@"ThumbnailsView is dealloc");
}
#pragma mark - private method
- (void)_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseToNotification:)
                                                 name:kMMFinishedGeneratThumbnailsImageNotification
                                               object:nil];
}

#pragma mark - action
- (void)responseToNotification:(NSNotification *)notification {
    [self.indicatorView stopAnimating];
    self.dataArray = [notification object];
    [self addSubview:self.collctionView];
}

#pragma mark - UIcollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ThumbnailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.imageContent = _dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailsImage *image = self.dataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(thumbnailsView:theImageTime:)]) {
        [self.delegate thumbnailsView:self theImageTime:image.photoTime];
    }
    
}
#pragma mark - get
- (UICollectionView *)collctionView{
    if (!_collctionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kMMThumbnailsImageWidth, self.height);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collctionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collctionView.dataSource = self;
        _collctionView.delegate   =self;
        [_collctionView registerClass:[ThumbnailsCell class] forCellWithReuseIdentifier:cellIdentifer];
    }
    return _collctionView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}
@end
