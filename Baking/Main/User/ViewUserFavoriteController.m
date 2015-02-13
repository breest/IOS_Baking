//
//  ViewUserFavoriteController.m
//  Baking
//
//  Created by Chang Wei on 15/2/4.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyArray.h"
#import "ViewUserFavoriteController.h"

@interface ViewUserFavoriteController ()

@end

@implementation ViewUserFavoriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的最愛";
    self.view.backgroundColor = [UIColor redColor];
    NSMutableArray *arr;
    arr = [NSMutableArray new];
    NSInteger b;
    arr = [App.arrDataRecipeDetail getSubArrayWithArray_CC:@[@3,@4]];
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
