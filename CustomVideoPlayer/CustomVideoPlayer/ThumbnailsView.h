//
//  ThumbnailsView.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/8.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailsImage.h"

@interface ThumbnailsCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ThumbnailsImage *imageContent;
@end


@protocol ThumbnailsViewDelegate;
@interface ThumbnailsView : UIView
@property (nonatomic, weak) id<ThumbnailsViewDelegate> delegate;
@end



@protocol ThumbnailsViewDelegate <NSObject>
- (void)thumbnailsView:(ThumbnailsView *)view theImageTime:(NSTimeInterval)time;
@end
