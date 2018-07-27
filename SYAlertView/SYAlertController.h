//
//  SYAlertController.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/7/27.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYAlertController : UIViewController

/// 内容视图
@property (nonatomic, strong) UIView *showContainerView;

/// 显示
- (void)show;

/// 隐藏
- (void)hide;

@end
