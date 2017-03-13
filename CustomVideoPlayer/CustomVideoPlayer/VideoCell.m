//
//  VideoCell.m
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "VideoCell.h"
#import "MMVideoHeader.h"
#import <SDWebImage/SD>
@interface VideoCell ()
@property (nonatomic, strong) UIView *videoPalyerView;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation VideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.videoPalyerView];
        [self addSubview:self.thumbnailView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.videoPalyerView.frame = CGRectMake(0, 0, kScreenWidth, _layout.videoPalyerViewHeight);
    self.titleLabel.frame = CGRectMake(0, self.videoPalyerView.bottom, kScreenWidth, _layout.titleLabelHeight);
}
#pragma mark - set
- (void)setLayout:(VideoLayout *)layout {
    _layout = layout;
    
    self.titleLabel.text = layout.model.title;
//    self.thumbnailView
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
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Icon_Play"] forState:UIControlStateNormal];
        [_thumbnailView addSubview:button];
    }
    return _thumbnailView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}
@end
