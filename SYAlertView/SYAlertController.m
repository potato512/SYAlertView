//
//  SYAlertController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/7/27.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "SYAlertController.h"

@interface SYAlertController ()

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation SYAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.47];
    
    self.alertWindow.rootViewController = self;
    [self hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - method

// 显示
- (void)show
{
    [self.alertWindow becomeKeyWindow];
    self.alertWindow.hidden = NO;
}

// 隐藏
- (void)hide
{
    [self.alertWindow resignKeyWindow];
    self.alertWindow.hidden = YES;
}

#pragma mark - setter

- (void)setShowContainerView:(UIView *)showContainerView
{
    _showContainerView = showContainerView;
    if (_showContainerView) {
        [self.contentView addSubview:_showContainerView];
        self.contentView.frame = CGRectMake((self.view.frame.size.width - _showContainerView.frame.size.width) / 2, (self.view.frame.size.height - _showContainerView.frame.size.height) / 2, _showContainerView.frame.size.width, _showContainerView.frame.size.height);
    }
}

#pragma mark - getter

- (UIWindow *)alertWindow
{
    if (_alertWindow == nil) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.windowLevel = UIWindowLevelAlert;
        _alertWindow.backgroundColor = [UIColor clearColor];
        [_alertWindow makeKeyAndVisible];
    }
    return _alertWindow;
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

@end
