//
//  VideoCell.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/3/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoLayout.h"
@interface VideoCell : UITableViewCell
@property (nonatomic, strong) VideoLayout *layout;
@property (nonatomic, strong) UIView *videoPalyerView;
@end
