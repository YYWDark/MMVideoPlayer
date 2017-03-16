//
//  VideoCell.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoCell.h"
#import "MMVideoHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VideoCell ()
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButton;

@end
@implementation VideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.videoPalyerView];
        [self addSubview:self.thumbnailView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.videoPalyerView.frame = CGRectMake(0, 0, kScreenWidth, _layout.videoPalyerViewHeight);
    self.thumbnailView.frame   = CGRectMake(0, 0, kScreenWidth, _layout.videoPalyerViewHeight);
    self.titleLabel.frame = CGRectMake(0, self.videoPalyerView.bottom, kScreenWidth, _layout.titleLabelHeight);
    _actionButton.size = CGSizeMake(50, 50);
    _actionButton.center = _thumbnailView.center;
    
}

#pragma mark - set
- (void)setLayout:(VideoLayout *)layout {
    _layout = layout;
    self.titleLabel.text = layout.model.title;
    self.thumbnailView.hidden = layout.model.isPlaying;
    self.videoPalyerView.hidden = !layout.model.isPlaying;
    [self.thumbnailView sd_setImageWithURL:[NSURL URLWithString:layout.model.cover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}
#pragma mark - get
- (UIView *)videoPalyerView {
    if (_videoPalyerView == nil) {
        _videoPalyerView = [[UIView alloc] init];
    }
    return _videoPalyerView;
}

- (UIImageView *)thumbnailView {
    if (_thumbnailView == nil) {
        _thumbnailView = [[UIImageView alloc] init];
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setImage:[UIImage imageNamed:@"Icon_Play"] forState:UIControlStateNormal];
        [_thumbnailView addSubview:_actionButton];
    }
    return _thumbnailView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
