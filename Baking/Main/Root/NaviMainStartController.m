//
//  NaviMainStartController.m
//  Baking
//
//  Created by Chang Wei on 15/2/4.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "ViewMainStartController.h"
#import "NaviMainStartController.h"

@interface NaviMainStartController ()

@end

@implementation NaviMainStartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ViewMainStartController *vc = [[ViewMainStartController alloc] init];
    [self pushViewController:vc animated:NO];
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
