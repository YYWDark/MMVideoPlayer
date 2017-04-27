//
//  LoginViewController.h
//  CustomVideoPlayer
//
//  Created by wyy on 2017/4/14.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LoginBlock)(void);
@interface LoginViewController : UIViewController
@property (nonatomic, copy) LoginBlock loginBlock;
@end
