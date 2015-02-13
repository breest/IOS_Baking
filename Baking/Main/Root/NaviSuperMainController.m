//
//  NaviSuperMainController.m
//  Baking
//
//  Created by Chang Wei on 15/2/4.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "ViewRootController.h"
#import "ViewMainController.h"
#import "NaviSuperMainController.h"

@interface NaviSuperMainController ()

@end

@implementation NaviSuperMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorWithRed:129.0/255.0 green:216.0/255.0 blue:208.0/225.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
}

- (void)viewDidAppear:(BOOL)animated {
    for (UIViewController *vc in self.childViewControllers) {
        vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"49"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleSideView)];
        vc.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"51"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightView)];
        vc.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleSideView {
    //若该实例实现了viewWillDisappear方法，则调用
    if ([self.visibleViewController respondsToSelector:@selector(viewWillMoveHidden)]) {
        [(ViewMainController *)self.visibleViewController viewWillMoveHidden];
    }
    [[ViewRootController sharedInstance] showLeftViewController:YES];
}

- (void)showRightView {
    if ([self.visibleViewController respondsToSelector:@selector(viewWillMoveHidden)]) {
        [(ViewMainController *)self.visibleViewController viewWillMoveHidden];
    }
    [[ViewRootController sharedInstance] showRightViewController:YES];
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
