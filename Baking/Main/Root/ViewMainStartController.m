//
//  ViewMainStartController.m
//  Baking
//
//  Created by Chang Wei on 15/2/3.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyArray.h"
#import "ViewMainStartController.h"

@interface ViewMainStartController ()

@end

@implementation ViewMainStartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *lblWelcome = [[UILabel alloc]initWithFrame:self.view.frame];
    lblWelcome.text = @"Welcome!";
    [self.view addSubview:lblWelcome];
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
