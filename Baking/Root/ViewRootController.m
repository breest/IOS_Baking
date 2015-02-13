//
//  ViewRootController.m
//  Baking
//
//  Created by Chang Wei on 15/1/29.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "UIImage+ImageEffects.h"
#import "ViewRootController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewRootController () {
    UIView *baseView;
    UIView *currentView;
    UIPanGestureRecognizer *panGestureRecognizer;
    CGPoint startPanPoint;
    BOOL panMovingLeftOrRight;
    UIButton *coverButton;
    BOOL isInited;
    float scaleratio;
}
@end

@implementation ViewRootController

static float canTouchAreaWidth = 0;

+ (instancetype)sharedInstance {
    static ViewRootController *sharedRVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRVC = [[self alloc] init];
    });
    return sharedRVC;
}

- (instancetype)init {
    return [self initWithNibName:nil bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _leftViewShowWidth = 4 * SCREEN_WIDTH/5;
        _rightViewShowWidth = 5 * SCREEN_WIDTH/6;
        scaleratio = 0.75;
        _animationDuration = 0.35;
        _needShowBoundsShadow = YES;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGestureRecognizer.delegate = self;
        panMovingLeftOrRight = NO;
        coverButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        [coverButton addTarget:self action:@selector(hideSlideViewController) forControlEvents:UIControlEventTouchUpInside];
        isInited = YES;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == panGestureRecognizer) {
        //控制是否从视图的边缘触发弹出侧边试图
        if (_needPanFromViewBounds && [gestureRecognizer locationInView:currentView].x >= canTouchAreaWidth && [gestureRecognizer locationInView:currentView].x < currentView.frame.size.width - canTouchAreaWidth) {
            return NO;
        }
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:baseView];
        if ([panGesture velocityInView:baseView].x < 600 && ABS(translation.x) / ABS(translation.y) > 1) {
            return YES;
        }
        return NO;
    }
    return YES;
}

//拦截下级视图的手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        startPanPoint = currentView.frame.origin;
        if (currentView.frame.origin.x == 0) {
            [self showShadow:_needShowBoundsShadow];
        }
        CGPoint velocity = [pan velocityInView:baseView];
        if (velocity.x > 0) {
            if (currentView.frame.origin.x >= 0 && _leftViewController && !_leftViewController.view.superview) {
                [self willShowLeftViewController];
            }
        } else if (velocity.x < 0) {
            if (currentView.frame.origin.x <= 0 && _rightViewController && !_rightViewController.view.superview) {
                [self willShowRightViewController];
            }
        }
        return;
    }
    CGPoint currentPostion = [pan translationInView:baseView];
    CGFloat xOffset = startPanPoint.x + currentPostion.x;
    if (xOffset > 0) {
        if (_leftViewController && _leftViewController.view.superview) {
            xOffset = xOffset > _leftViewShowWidth ? _leftViewShowWidth : xOffset;
        } else {
            xOffset = 0;
        }
    } else if (xOffset < 0) {
        if (_rightViewController && _rightViewController.view.superview) {
            xOffset = xOffset < -_rightViewShowWidth ? -_rightViewShowWidth : xOffset;
        } else {
            xOffset = 0;
        }
    }
    if (xOffset != currentView.frame.origin.x) {
        [self layoutCurrentViewWithOffset:xOffset];
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (currentView.frame.origin.x == 0) {
            [self showShadow:NO];
        } else {
            if (panMovingLeftOrRight && currentView.frame.origin.x > 20) {
                [self showLeftViewController:YES];
            } else if (!panMovingLeftOrRight && currentView.frame.origin.x < -20) {
                [self showRightViewController:YES];
            } else {
                [self hideSlideMenuViewController:YES];
            }
        }
    } else {
        CGPoint velocity = [pan velocityInView:baseView];
        if (velocity.x > 0) {
            panMovingLeftOrRight = YES;
        } else if (velocity.x < 0) {
            panMovingLeftOrRight = NO;
        }
    }
}

- (void)showShadow:(BOOL)show {
    currentView.layer.shadowOpacity = show ? 0.2f : 0.0f;
    if (show) {
        currentView.layer.cornerRadius = 0.0f;
        //currentView.layer.shadowOffset = CGSizeZero;
        currentView.layer.shadowOffset = CGSizeMake(-9, -9);
        currentView.layer.shadowRadius = 3.0f;
        currentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:currentView.bounds].CGPath;
    }
}

- (void)willShowLeftViewController {
    UIViewController *l;
    UIView * v;
    l = _leftViewController;
    v = _leftViewController.view.superview;
    if (!_leftViewController || _leftViewController.view.superview) {
        return;
    }
    _leftViewController.view.frame = baseView.bounds;
    [baseView insertSubview:_leftViewController.view belowSubview:currentView];
    if (_rightViewController && _rightViewController.view.superview) {
        [_rightViewController.view removeFromSuperview];
    }
}

- (void)showLeftViewController:(BOOL)animated {
    if (!_leftViewController) {
        return;
    }
    [self willShowLeftViewController];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_leftViewShowWidth - currentView.frame.origin.x) / _leftViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:_leftViewShowWidth];
        [currentView addSubview:coverButton];
        [self showShadow:_needShowBoundsShadow];
    }];
    canTouchAreaWidth = currentView.frame.size.width - _leftViewShowWidth;
}

- (void)willShowRightViewController {
    if (!_rightViewController || _rightViewController.view.superview) {
        return;
    }
    _rightViewController.view.frame = baseView.bounds;
    [baseView insertSubview:_rightViewController.view belowSubview:currentView];
    if (_leftViewController && _leftViewController.view.superview) {
        [_leftViewController.view removeFromSuperview];
    }
}

- (void)showRightViewController:(BOOL)animated {
    if (!_rightViewController) {
        return;
    }
    [self willShowRightViewController];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_rightViewShowWidth - currentView.frame.origin.x) / _rightViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:-_rightViewShowWidth];
        [currentView addSubview:coverButton];
        [self showShadow:_needShowBoundsShadow];
    }];
    canTouchAreaWidth = currentView.frame.size.width - _rightViewShowWidth;
}

- (void)hideSlideMenuViewController:(BOOL)animated {
    _needPanFromViewBounds = YES;
    [self showShadow:NO];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(currentView.frame.origin.x / (currentView.frame.origin.x > 0 ? _leftViewShowWidth:_rightViewShowWidth)) * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:0];
    } completion:^(BOOL finished) {
        [coverButton removeFromSuperview];
        [_leftViewController.view removeFromSuperview];
        [_rightViewController.view removeFromSuperview];
    }];
    canTouchAreaWidth = 0;
}

- (void)hideSlideViewController {
    canTouchAreaWidth = currentView.frame.size.width - _leftViewShowWidth;
    [self hideSlideMenuViewController:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.tag = 1;
    baseView = self.view;
    self.needSwipeShowMenu = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    if (!_mainViewController) {
        NSAssert(NO, @"You must set mainViewController!!");
    }
    if (isInited) {
        [self resetCurrentViewToMainViewController];
        isInited = NO;
    }
}

- (void)resetCurrentViewToMainViewController {
    if (currentView != _mainViewController.view) {
        CGRect frame = CGRectZero;
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (!currentView) {
            frame = baseView.bounds;
        } else {
            frame = currentView.frame;
            transform = currentView.transform;
        }
        [currentView removeFromSuperview];
        currentView = _mainViewController.view;
        [baseView addSubview:currentView];
        currentView.transform = transform;
        currentView.frame = frame;
        if (_leftViewController.view.superview || _rightViewController.view.superview) {
            [currentView addSubview:coverButton];
            [self showShadow:_needShowBoundsShadow];
        }
    }
}

//重写此方法可以自定义mainViewController的出入动画
- (void)layoutCurrentViewWithOffset:(CGFloat)xOffset {
    CGFloat totalWidth = baseView.frame.size.width;
    CGFloat totalHeight = baseView.frame.size.height;
    if (_needShowBoundsShadow) {
        currentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:currentView.bounds].CGPath;
    }/*
    if (_mainViewAnimationBlock) {
        //如果有自定义的动画,则执行自定义动画
        _mainViewAnimationBlock(currentView, baseView.bounds, xOffset);
        return;
    }*/
    //CGRect cg = currentView.frame;
    if (_animationType == SlideAnimationTypeMove) {
        currentView.frame=CGRectMake(xOffset, baseView.bounds.origin.y, totalWidth, totalHeight);
    } else {
        CGFloat scale = ABS(totalHeight - ABS(xOffset)) / totalHeight;
        scale = MAX(scaleratio, scale);
        currentView.transform = CGAffineTransformMakeScale(scale, scale);
        if (xOffset > 0) {//右滑
            currentView.frame = CGRectMake(xOffset, baseView.bounds.origin.y + (totalHeight * (1 - scale) / 2), totalWidth * scale, totalHeight * scale);
        } else {//左滑
            currentView.frame = CGRectMake(baseView.frame.size.width * (1 - scale) + xOffset, baseView.bounds.origin.y + (totalHeight * (1 - scale) / 2), totalWidth * scale, totalHeight * scale);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMainViewController:(TabMainController *)mainViewController {
    if (_mainViewController != mainViewController) {
        if (_mainViewController) {
            [_mainViewController removeFromParentViewController];
        }
        _mainViewController = mainViewController;
        if (_mainViewController) {
            [self addChildViewController:_mainViewController];
        }
        if (!isInited) {
            [self resetCurrentViewToMainViewController];
        }
    }
    
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (_leftViewController != leftViewController) {
        if (_leftViewController) {
            [_leftViewController removeFromParentViewController];
        }
        _leftViewController = (NaviLeftController *)leftViewController;
        if (_leftViewController) {
            [self addChildViewController:_leftViewController];
        }
    }
}

- (void)setNeedSwipeShowMenu:(BOOL)needSwipeShowMenu {
    _needSwipeShowMenu = needSwipeShowMenu;
    if (needSwipeShowMenu) {
        [baseView addGestureRecognizer:panGestureRecognizer];
    } else {
        [baseView removeGestureRecognizer:panGestureRecognizer];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
