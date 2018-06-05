//
//  ViewController.m
//  DemoSYAlertView
//
//  Created by zhangshaoyu on 2018/6/5.
//  Copyright © 2018年 VSTECS. All rights reserved.
//

#import "ViewController.h"
#import "SYAlertView.h"
#import "AppDelegate.h"

static CGFloat const originXY = 20.0;
static CGFloat const heightButton = 40.0;
#define widthScreen (self.view.frame.size.width)

@interface ViewController ()

@property (nonatomic, strong) SYAlertView *alertView;

@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UIView *titleMessageView;
@property (nonatomic, strong) UIView *titleEidtView;
@property (nonatomic, strong) UIView *editView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __block UIView *currentView = nil;
    
    NSArray *array = @[@"提示内容", @"提示语/提示内容", @"提示语/输入内容", @"输入内容"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10.0, (currentView.frame.origin.y + currentView.frame.size.height + 10.0), (self.view.frame.size.width - 20.0), 40.0)];
        [self.view addSubview:button];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.tag = idx;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        currentView = button;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (0 == button.tag) {
        self.alertView.showContainerView = self.messageView;
        [self.alertView show];
    } else if (1 == button.tag) {
        self.alertView.containerView.frame = CGRectMake(originXY, (self.alertView.frame.size.height - self.titleMessageView.frame.size.height) / 2, (self.alertView.frame.size.width - originXY * 2), self.titleMessageView.frame.size.height);
        [self.alertView.containerView addSubview:self.titleMessageView];
        [self.alertView show];
    } else if (2 == button.tag) {
        self.alertView.containerView.frame = CGRectMake(20.0, 100.0, (self.alertView.frame.size.width - 40.0f), self.titleEidtView.frame.size.height);
        [self.alertView.containerView addSubview:self.titleEidtView];
        [self.alertView show];
    } else if (3 == button.tag) {
        self.alertView.containerView.frame = CGRectMake(20.0, 60.0, (self.alertView.frame.size.width - 40.0f), self.editView.frame.size.height);
        [self.alertView.containerView addSubview:self.editView];
        [self.alertView show];
    }
}

- (void)hideClick
{
    [self.alertView hide];
}

#pragma mark - getter

- (SYAlertView *)alertView
{
    if (_alertView == nil) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIView *view = delegate.window;
        _alertView = [[SYAlertView alloc] initWithView:view];
        _alertView.isAnimation = YES;
    }
    return _alertView;
}

- (UIView *)messageView
{
    if (_messageView == nil) {
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, (widthScreen - 40.0), 0.0)];
        _messageView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originXY, originXY, (_messageView.frame.size.width - originXY * 2), heightButton)];
        label.textColor = [UIColor blackColor];
        label.text = @"UIAlertController这个接口类是一个定义上的提升，它添加简单，展示Alert和ActionSheet使用统一的API。因为UIAlertController使UIViewController的子类，他的API使用起来也会比较熟悉！";
        
        UIView *currentView = label;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(currentView.frame.origin.x, (currentView.frame.origin.y + currentView.frame.size.height + originXY), currentView.frame.size.width, currentView.frame.size.height)];
        [button setTitle:@"知道了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor yellowColor];
        button.layer.cornerRadius = heightButton / 2;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(hideClick) forControlEvents:UIControlEventTouchUpInside];
        
        currentView = button;
        
        [_messageView addSubview:label];
        [_messageView addSubview:button];
        
        CGRect rect = _messageView.frame;
        rect.size.height = currentView.frame.origin.y + currentView.frame.size.height + originXY;
        _messageView.frame = rect;
    }
    return _messageView;
}



@end
