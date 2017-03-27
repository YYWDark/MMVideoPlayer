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
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CALayer *line;
@property (nonatomic, strong) UIView * shadowView;
@end


@implementation VideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.photoView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.videoPalyerView];
        [self addSubview:self.thumbnailView];
        [self addSubview:self.titleLabel];
        [self.layer addSublayer:self.line];
        [self addSubview:self.shadowView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.photoView.frame = CGRectMake(_layout.horizontalMargin, _layout.verticalMargin, _layout.photoViewSide, _layout.photoViewSide);
    self.nameLabel.frame = CGRectMake(self.photoView.right + 5 , self.photoView.top, 150, _layout.nameLabelHeight);
    self.timeLabel.frame = CGRectMake(self.photoView.right + 5 , self.nameLabel.bottom, 150, _layout.timeLabelHeight);
    self.videoPalyerView.frame = CGRectMake(0, self.photoView.bottom + _layout.verticalMargin, kScreenWidth, _layout.videoPalyerViewHeight);
    self.thumbnailView.frame   = CGRectMake(0, self.videoPalyerView.top, kScreenWidth, _layout.videoPalyerViewHeight);
    self.titleLabel.frame = CGRectMake(self.photoView.left, self.videoPalyerView.bottom + _layout.verticalMargin, kScreenWidth - 2*_layout.horizontalMargin, _layout.titleLabelHeight);
    
    _actionButton.size = CGSizeMake(50, 50);
    _actionButton.center = _thumbnailView.center;
    self.line.frame = CGRectMake(0,_layout.totalHeight - 1.0/[UIScreen mainScreen].scale ,kScreenWidth, 1.0/[UIScreen mainScreen].scale);
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, _layout.totalHeight);
}

#pragma mark - set
- (void)setLayout:(VideoLayout *)layout {
    _layout = layout;
    self.nameLabel.text = layout.model.topicName;
    self.timeLabel.text = layout.model.ptime;
    self.titleLabel.text = layout.model.title;
    self.thumbnailView.hidden = layout.model.isPlaying;
    self.videoPalyerView.hidden = !layout.model.isPlaying;
    self.shadowView.hidden = layout.model.isPlaying;
    [self.thumbnailView sd_setImageWithURL:[NSURL URLWithString:layout.model.cover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}
#pragma mark - get
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor lightGrayColor];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

- (UIImageView *)photoView {
    if (_photoView == nil) {
        _photoView = [[UIImageView alloc] init];
        _photoView.image = [UIImage imageNamed:@"Icon_Photo"];
    }
    return _photoView;
}

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
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor lightGrayColor];
        
    }
    return _titleLabel;
}

- (CALayer *)line {
    if (_line == nil) {
        _line = [CALayer layer];
        _line.backgroundColor = [UIColor lightGrayColor].CGColor;
    }
    return _line;
}

- (UIView *)shadowView {
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = .8;
    }
    return _shadowView;
}
@end
