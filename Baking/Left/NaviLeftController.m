//
//  NaviLeftController.m
//  Baking
//
//  Created by Chang Wei on 15/1/31.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "ViewLeftRootController.h"
#import "NaviLeftController.h"

@interface NaviLeftController ()

@end

@implementation NaviLeftController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ViewLeftRootController *viewLeft = [[ViewLeftRootController alloc]init];
    self.view.tag = 10;
    [self pushViewController:viewLeft animated:NO];
    //self.navigationBar.barTintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.01];
    //self.navigationBar.alpha = 0.3;
    //self.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
