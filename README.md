# SYAlertView
自定义弹窗子视图UI
根据UI设计需求，自定义各种样式的弹窗子视图，既可以设置样式，也可以设置动画。


#### 效果图

#### 代码示例
1、导入头文件
```
#import "SYAlertView.h"
```

2、实例化
```
AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
UIView *view = delegate.window;
SYAlertView *alertView = [[SYAlertView alloc] initWithView:view];
alertView.isAnimation = YES;
alertView.timeAnimation = 0.6;
```

3、子视图设置
```
// 自定义的子视图
UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0f, 110.0f)];
UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 160.0f, 40.0f)];
message.text = @"弹窗信息";
[view addSubview:message];
UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 160.0f, 30.0f)];
[button setTitle:@"知道了" forState:UIControlStateNormal];
[button addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside]
[view addSubview:button];
```
（1）方法1
```
alertView.showContainerView = view;
```
（2）方法2
```
alertView.containerView.frame = CGRectMake(20.0f, (alertView.frame.size.height - view.frame.size.height) / 2, view.frame.size.width, view.frame.size.height);
[alertView.containerView addSubview:view];
```

4、方法调用
（1）显示
```
[alertView show];
```
（2）隐藏
```
[alertView hide];
```

#### 修改说明
* 20180605
  * 版本号：1.0.0
  * 添加源码
