//
//  SYAlertController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2018/6/4.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//  

#import "SYAlertController.h"

static CGFloat const heightSpace = 10.0f;

@interface SYAlertController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWindow *alertWindow;

// 初始化UI时的原点位置，便于结束编辑时恢复位置
@property (nonatomic, assign) CGFloat originYInitialize;
@property (nonatomic, assign) CGSize sizeKeyboard;
@property (nonatomic, weak) UIView *editingView;

@end

@implementation SYAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDefault];
    [self addGestureRecognizer];
    self.alertWindow.rootViewController = self;
    [self hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.editingView = nil;
    
    NSLog(@"释放了 %@", [self class]);
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.47];
}

#pragma mark - 初始化

- (void)initializeDefault
{
    // 初始化默认值
    self.isAnimation = NO;
    
    //
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    self.animation = animation;
}

#pragma mark - 手势响应

// 添加手势
- (void)addGestureRecognizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)tapClick
{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchview = touch.view;
    if ([touchview isEqual:self.view]) {
        return YES;
    }
    return NO;
}

#pragma mark - 键盘适配

- (void)addAdjustKeyboard
{
    __weak typeof(self) weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __strong typeof(self) strongSelf = weakSelf;
        //
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        //
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(editviewBeginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(editviewEndEdit:) name:UITextFieldTextDidEndEditingNotification object:nil];
        //
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(editviewBeginEdit:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(editviewEndEdit:) name:UITextViewTextDidEndEditingNotification object:nil];
    });
}

#pragma mark 键盘通知

- (void)keyboardShow:(NSNotification *)notification
{
    // 键盘高度
    NSDictionary *keyboardDict = [notification userInfo];
    self.sizeKeyboard = [[keyboardDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (!CGSizeEqualToSize(self.sizeKeyboard, CGSizeZero)) {
        // 重置编辑视图位置
        [self editViewFrame];
    }
}

- (void)keyboardHide:(NSNotification *)notification
{
    CGRect __block rect = self.containerView.frame;
    if (self.isAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            rect.origin.y = self.originYInitialize;
            self.containerView.frame = rect;
        }];
    } else {
        rect.origin.y = self.originYInitialize;
        self.containerView.frame = rect;
    }
    
    self.sizeKeyboard = CGSizeZero;
    self.originYInitialize = 0.0;
}

#pragma mark 视图处理

- (NSArray *)editSuperviews:(UIView *)edit base:(UIView *)baseview
{
    NSMutableArray *array = [NSMutableArray new];
    UIView *superview = edit.superview;
    while (superview) {
        if ([superview isEqual:baseview]) {
            superview = nil;
        } else {
            [array addObject:superview];
            superview = superview.superview;
        }
    }
    return array;
}

- (void)editViewFrame
{
    // 重置编辑窗口位置
    // 当前编辑视图的所有父视图
    NSArray *superviews = [self editSuperviews:self.editingView base:self.containerView];
    //    NSLog(@"superviews = %@", superviews);
    CGFloat __block originY = self.editingView.frame.origin.y;
    [superviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        originY += ((UIView *)obj).frame.origin.y;
    }];
    
    CGFloat height = (self.containerView.superview.frame.size.height - self.sizeKeyboard.height);
    CGFloat heightShow = (self.containerView.frame.origin.y + originY + self.editingView.frame.size.height);
    CGFloat space = (self.originSpace <= 0.0 ? heightSpace : self.originSpace);
    BOOL shouldChange = (height < (heightShow + space) ? YES : NO);
    BOOL shouldChangeWhileInitialize = (height < (self.originYInitialize + originY + self.editingView.frame.size.height + space) ? YES : NO);
    if (shouldChange || shouldChangeWhileInitialize) {
        CGRect __block rect = self.containerView.frame;
        if (self.isAnimation) {
            [UIView animateWithDuration:0.3 animations:^{
                rect.origin.y = (self.containerView.superview.frame.size.height - self.sizeKeyboard.height - space - originY - self.editingView.frame.size.height);
                // rect.origin.y = 10.0;
                self.containerView.frame = rect;
            }];
        } else {
            rect.origin.y = (self.containerView.superview.frame.size.height - self.sizeKeyboard.height - space - originY - self.editingView.frame.size.height);
            // rect.origin.y = 10.0;
            self.containerView.frame = rect;
        }
    }
}

#pragma mark 编辑

- (void)editviewBeginEdit:(NSNotification *)notification
{
    self.editingView = notification.object;
    if (([self.editingView isKindOfClass:[UITextView class]] || [self.editingView isKindOfClass:[UITextField class]]) && self.originYInitialize == 0.0f) {
        self.originYInitialize = self.containerView.frame.origin.y;
    }
    
    if (!CGSizeEqualToSize(self.sizeKeyboard, CGSizeZero)) {
        // 重置编辑视图位置
        [self editViewFrame];
    }
}

- (void)editviewEndEdit:(NSNotification *)notification
{
    self.editingView = nil;
}

#pragma mark - method

// 显示
- (void)show
{
    if (self.containerView.subviews.count <= 0) {
#if DEBUG
        NSLog(@"\n<------\n没有设置containerView的frame及添加子视图，或是没有设置属性showContainerView\n------>\n");
#endif
        return;
    }
    
    [self.alertWindow becomeKeyWindow];
    self.alertWindow.hidden = NO;
    
    if (self.isAnimation) {
        [self.containerView.layer addAnimation:self.animation forKey:nil];
    }
}

// 隐藏
- (void)hide
{
    [self.alertWindow resignKeyWindow];
    self.alertWindow.hidden = YES;
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - setter

- (void)setShowContainerView:(UIView *)showContainerView
{
    _showContainerView = showContainerView;
    if (_showContainerView) {
        [self.containerView addSubview:_showContainerView];
        self.containerView.frame = CGRectMake((self.view.frame.size.width - _showContainerView.frame.size.width) / 2, (self.view.frame.size.height - _showContainerView.frame.size.height) / 2, _showContainerView.frame.size.width, _showContainerView.frame.size.height);
    }
}

- (void)setAdjustKeyboardHeight:(BOOL)adjustKeyboardHeight
{
    _adjustKeyboardHeight = adjustKeyboardHeight;
    if (_adjustKeyboardHeight) {
        [self addAdjustKeyboard];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.editingView = nil;
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

- (UIView *)containerView
{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}

@end
