//
//  ViewLeftSystemController.m
//  Baking
//
//  Created by Chang Wei on 15/1/31.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "ViewRootController.h"
#import "ViewSettingDBController.h"
#import "ViewSettingUIController.h"
#import "TabMainController.h"
#import "ViewLeftSystemController.h"

@interface ViewLeftSystemController (){
    NSArray *arraySetting;
    NSMutableArray *arrayCell;
}

@end

@implementation ViewLeftSystemController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arraySetting.count;
}

- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    arrayCell = [arraySetting objectAtIndex:indexPath.row];
    cell.imgTitle.image = [UIImage imageNamed:[arrayCell objectAtIndex:1]];
    cell.lblTitle.text = [arrayCell objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 9;
        [rootVC hideSlideViewController];
    }else if (indexPath.row == 1) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 10;
        [rootVC hideSlideViewController];
    }else if (indexPath.row == 2) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 11;
        [rootVC hideSlideViewController];
    }else if (indexPath.row == 3) {
        ViewRootController *rootVC = [ViewRootController sharedInstance];
        rootVC.mainViewController.selectedIndex = 12;
        [rootVC hideSlideViewController];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arraySetting = [NSArray arrayWithObjects:@[@"資料庫設定", @"12"], @[@"界面設定", @"20"], @[@"使用習慣設定", @"11"], @[@"個人資料設定",@"10"], nil];
    
    tableCurrent= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableCurrent.backgroundColor = [UIColor clearColor];
    tableCurrent.delegate = self;
    tableCurrent.dataSource = self;
    [self.view addSubview:tableCurrent];
    tableCurrent.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
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
