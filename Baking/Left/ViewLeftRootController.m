//
//  ViewLeftController1.m
//  Baking
//
//  Created by Chang Wei on 15/1/31.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "ViewLeftRootController.h"
#import "ViewLeftRecipeController.h"
#import "ViewLeftSystemController.h"
#import "ViewSettingMatController.h"
#import "ViewSettingRecipeController.h"
#import "TabMainController.h"
#import "ViewRootController.h"

@interface ViewLeftRootController () {
    NSArray *arrayRoot, *arraySection;
    NSArray *arrayFavorites, *arrayRecipe, *arrayShare, *arraySystem;
    NSMutableArray *arrayCell;
}

@end

@implementation ViewLeftRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 2;
    // Do any additional setup after loading the view.
    arraySection = [NSArray arrayWithObjects:@"我的項目", @"配方分類", @"分享", @"系統設定", nil];
    arrayFavorites = [NSArray arrayWithObjects:@[@"我的最愛", @"03"], @[@"最近配方", @"27"], @[@"本地收藏", @"28"], @[@"單位換算表",@"26"], nil];
    arrayRecipe = [NSArray arrayWithObjects:@[@"西點", @"55"], @[@"蛋糕", @"55"], @[@"甜點", @"55"], @[@"麵包",@"55"], nil];
    arrayShare = [NSArray arrayWithObjects:@[@"分享到Facebook", @"50"], @[@"分享到Line", @"52"], nil];
    arraySystem = [NSArray arrayWithObjects:@[@"配方設定", @"12"], @[@"原料設定", @"23"], @[@"程式設定", @"04"], @[@"退出", @"24"], nil];
    arrayRoot = [NSArray arrayWithObjects:arrayFavorites, arrayRecipe, arrayShare, arraySystem, nil];
    
    tableCurrent= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableCurrent.backgroundColor = [UIColor clearColor];
    tableCurrent.delegate = self;
    tableCurrent.dataSource = self;
    [self.view addSubview:tableCurrent];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arraySection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[arrayRoot objectAtIndex:section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader;
    UILabel *lblHeader;
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 21)];
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.text = [arraySection objectAtIndex:section];
    [viewHeader addSubview:lblHeader];
    return viewHeader;
}

- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    arrayCell = [[arrayRoot objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imgTitle.image = [UIImage imageNamed:[arrayCell objectAtIndex:1]];
    cell.lblTitle.text = [arrayCell objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    arrayCell = [[arrayRoot objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 0;
        [rootVC hideSlideViewController];
    }else if (indexPath.section == 0&& indexPath.row == 1) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 1;
        [rootVC hideSlideViewController];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 2;
        [rootVC hideSlideViewController];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 3;
        [rootVC hideSlideViewController];
    }else if (indexPath.section == 1) {
        ViewLeftRecipeController *vc = [[ViewLeftRecipeController alloc] init];
        vc.title = [arrayCell objectAtIndex:0];        
        [self.navigationController pushViewController:vc animated:NO];
    }else if (indexPath.section == 2&& indexPath.row == 0) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 5;
        [rootVC hideSlideViewController];
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 6;
        [rootVC hideSlideViewController];
    }else if (indexPath.section == 3 && indexPath.row == 0) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 7;
        [rootVC hideSlideViewController];
    }else if (indexPath.section == 3 && indexPath.row == 1) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 8;
        [rootVC hideSlideViewController];
    }else if (indexPath.section == 3 && indexPath.row == 2) {
        ViewLeftSystemController *vc = [[ViewLeftSystemController alloc] init];
        vc.title = [arrayCell objectAtIndex:0];
        [self.navigationController pushViewController:vc animated:NO];
    }else if (indexPath.section == 1) {
        ;
    }else if (indexPath.section == 1) {
        ;
    }else if (indexPath.section == 1) {
        ;
    }
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
