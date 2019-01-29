//
//  SYAlertViewController.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/6/4.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYAlertViewController

#import <UIKit/UIKit.h>

@interface SYAlertViewController : UIViewController

/// 内容视图（默认居中显示）
@property (nonatomic, strong) UIView *showContainerView;

/// 内容视图（需要调用方法addSubview添加子视图，及设置frame）
@property (nonatomic, strong) UIView *containerView;

/// 默认无动画（设置后默认放大缩小）
@property (nonatomic, assign) BOOL isAnimation;
/// 动画设置（默认放大缩小）
@property (nonatomic, strong) CAAnimation *animation;

/// 编辑时与键盘间距（默认10.0）
@property (nonatomic, assign) CGFloat originSpace;
/// 编辑时默认未适配键盘
@property (nonatomic, assign) BOOL adjustKeyboardHeight;

/// 显示
- (void)show;

/// 隐藏
- (void)hide;

@end
