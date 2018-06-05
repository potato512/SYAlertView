//
//  ViewController.m
//  DemoSubviews
//
//  Created by Herman on 2018/6/5.
//  Copyright © 2018年 Herman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *show = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStyleDone target:self action:@selector(showClick)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];
    self.navigationItem.rightBarButtonItems = @[done, show];
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, 10.0, 10.0)];
    [self.view addSubview:view0];
    //
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10.0, 40.0, 100.0, 60.0)];
    [self.view addSubview:view1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 30.0)];
    [view1 addSubview:label];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(70.0, 30.0, 30.0, 30.0)];
     [view1 addSubview:imageview];
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 30.0, 70.0, 30.0)];
    [view1 addSubview:textfield];
    //
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10.0, 120.0, 140.0, 120.0)];
    view2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view2];
    UIImageView *view21 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 120.0, 100.0)];
    view21.backgroundColor = [UIColor orangeColor];
    view21.userInteractionEnabled = YES;
    [view2 addSubview:view21];
    UILabel *view22 = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 100.0, 80.0)];
    view22.backgroundColor = [UIColor yellowColor];
    view22.userInteractionEnabled = YES;
    [view21 addSubview:view22];
    UIButton *view23 = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 10.0, 80.0, 60.0)];
    view23.backgroundColor = [UIColor greenColor];
    view23.userInteractionEnabled = YES;
    [view22 addSubview:view23];
    UITextView *view24 = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 10.0, 60.0, 40.0)];
    view24.backgroundColor = [UIColor blueColor];
    [view23 addSubview:view24];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneClick
{
    [self.view endEditing:YES];
}

- (void)showClick
{
    // 打印所有子视图
//    [self showSubview:self.navigationController.navigationBar level:1];
//    [self showSubview:self.view level:1];
    
    UIView *view = [self showSubview:self.view];
    NSLog(@"view = %@", view);
    [self showSuperview:view stop:self.view];
}

// 递归获取子视图（level从1开始）
- (void)showSubview:(UIView *)view level:(int)level
{
    for (UIView *subview in view.subviews) {
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++)
        {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        // 打印子视图类名
        NSLog(@"%@%d: %@[superview = %@]", blank, level, subview.class, subview.superview.class);
        if ([subview isKindOfClass:[UITextField class]] || [subview isKindOfClass:[UITextView class]]) {
            NSLog(@"%@%d: %@", blank, level, @(YES));
        }
        // 递归获取此视图的子视图
        [self showSubview:subview level:(level + 1)];
    }
}

- (UIView *)showSubview:(UIView *)view
{
    UIView *viewTmp = nil;
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UITextField class]] || [subview isKindOfClass:[UITextView class]]) {
            viewTmp = subview;
            break;
        }
        viewTmp = [self showSubview:subview];
    }
    return viewTmp;
}

- (void)showSuperview:(UIView *)view stop:(UIView *)equalview
{
    UIView *superview = view.superview;
    CGFloat originY = view.frame.origin.y + superview.frame.origin.y;
    NSLog(@"originY: %@, superview = %@", @(originY), superview);
    if (superview && ![superview isEqual:equalview]) {
        [self showSuperview:superview stop:equalview];
    }
}


@end
