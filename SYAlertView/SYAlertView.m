//
//  SYAlertView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/6/4.
//  Copyright © 2018年 VSTECS. All rights reserved.
//

#import "SYAlertView.h"

static CGFloat const heightSpace = 10.0f;
static NSTimeInterval const timeAnimation = 0.4f;

@interface SYAlertView ()

@property (nonatomic, assign) BOOL isKeyboardHide;
@property (nonatomic, assign) CGFloat originYContainer;

@end

@implementation SYAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        [self setUI];
        
        if (view) {
            self.frame = view.bounds;
            [view addSubview:self];
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@"释放了 %@", [self class]);
}

#pragma mark - 视图

- (void)setUI
{
    self.isAnimation = NO;
    //
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = timeAnimation;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    self.animation = animation;    
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.47];
    self.hidden = YES;
    
    [self addSubview:self.containerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 方法

- (void)hide
{
    if (self.hidden) {
        
    } else {
        self.hidden = YES;
    }
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)show
{
    if (self.containerView.subviews.count <= 0) {
        NSLog(@"\n<------\n没有设置containerView的frame及添加子视图，或是没有设置属性showContainerView\n------>\n");
        return;
    }
    
    self.hidden = NO;
    if (self.isAnimation) {
        [self.containerView.layer addAnimation:self.animation forKey:nil];
    }
}

#pragma mark - 键盘处理

- (NSDictionary *)editView:(UIView *)view
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:NSStringFromCGRect(view.frame) forKey:NSStringFromClass([view class])];
    
    NSArray *views = view.subviews;
    if (views && views.count > 0) {
        BOOL isEditUI = NO;
        for (UIView *subview in views) {
            if ([subview isKindOfClass:[UITextField class]] || [subview isKindOfClass:[UITextView class]]) {
                isEditUI = YES;
                break;
            }
        }
        if (isEditUI) {
            for (UIView *subview in views) {
                if ([subview isKindOfClass:[UITextField class]] || [subview isKindOfClass:[UITextView class]]) {
                    if ([subview isFirstResponder]) {
                        [dict setObject:NSStringFromCGRect(subview.frame) forKey:NSStringFromClass([subview class])];
                        break ;
                    }
                }
            }
        } else {
            for (UIView *subview in views) {
                NSDictionary *dictTmp = [self editView:subview];
                if (dictTmp.count > 0) {
                    [dict setDictionary:dictTmp];
                    break;
                }
            }
        }
    }
    return dict;
}

- (void)keyboardShow:(NSNotification *)notification
{
    NSDictionary *dict = [self editView:self.containerView];
    NSLog(@"<------\n dict %@\nkeys %@\nvalues %@\n------>\n", dict, dict.allKeys, dict.allValues);

    
    if (self.isKeyboardHide) {
        self.originYContainer = self.containerView.frame.origin.y;
        self.isKeyboardHide = NO;
    }

    // 当前编辑视图的位置的大小
    // 说明：使用递归算法遍历所有子视图的子视图，直到找到编辑视图或不再有子视图为止
    UIView *editView = nil;
    CGFloat editOriginY = editView.frame.origin.y;
    CGFloat editHeight = editView.frame.size.height;
    
    
    // 键盘高度
    NSDictionary *keyboardDict = [notification userInfo];
    CGSize keyboardSize = [[keyboardDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = keyboardSize.height;
    
    CGFloat height = self.containerView.superview.frame.size.height - keyboardHeight;
    CGFloat heightShow = self.originYContainer + editOriginY + editHeight;
    if (heightSpace > heightShow - height) {
        CGRect __block rect = self.containerView.frame;
        if (self.isAnimation) {
            [UIView animateWithDuration:0.3 animations:^{
//                rect.origin.y = (height - heightSpace - editOriginY - editHeight);
                rect.origin.y = 10.0;
                self.containerView.frame = rect;
            }];
        } else {
//            rect.origin.y = (height - heightSpace - editOriginY - editHeight);
            rect.origin.y = 10.0;
            self.containerView.frame = rect;
        }
    }
}

- (void)keyboardHide:(NSNotification *)notification
{
    self.isKeyboardHide = YES;
    
    CGRect __block rect = self.containerView.frame;
    
    if (self.isAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            rect.origin.y = self.originYContainer;
            self.containerView.frame = rect;
        }];
    } else {
        rect.origin.y = self.originYContainer;
        self.containerView.frame = rect;
    }
}

#pragma mark - setter

- (void)setShowContainerView:(UIView *)showContainerView
{
    _showContainerView = showContainerView;
    if (_showContainerView) {
        self.containerView.frame = CGRectMake(20.0f, (self.frame.size.height - _showContainerView.frame.size.height) / 2, _showContainerView.frame.size.width, _showContainerView.frame.size.height);
        [self.containerView addSubview:_showContainerView];
    }
}

#pragma mark - getter

- (UIView *)containerView
{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

@end
