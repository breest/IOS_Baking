//
//  ViewController.m
//  Baking
//
//  Created by Chang Wei on 15/1/22.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController2.h"
#import "ViewController.h"

@implementation ViewController{
    AppDelegate *App;
    NSMutableArray *arrRecipe, *arrRecipeIcon, *arrPercent;
    UITableView *tableRecipe, *tablePercent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 3;
    // Do any additional setup after loading the view, typically from a nib.
    App = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    App.dictL_02 = (NSMutableDictionary *)[App getDictionaryWithUniqueColumnValue:App.arrDataLevel_2 indexColumn:0];

    tableRecipe = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableRecipe.dataSource = self;
    tableRecipe.delegate =self;
    [self.view addSubview:tableRecipe];
    //self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewDidAppear:(BOOL)animated {
    int i=self.view.tag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return App.dictL_02.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }else{
        return 30;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat h = 30;
    if (section == 0) {
        h = 40;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App.screen.width, h)];//创建一个视图
    /*
     UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
     UIImage *image = [UIImage imageNamed:@"4-2.png"];
     [headerImageView setImage:image];
     [headerView addSubview:headerImageView];*/
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, h-30, App.screen.width, 30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont boldSystemFontOfSize:18.0];
    headerLabel.textColor = [UIColor blueColor];
    //headerLabel.text = [[App.arrayL_02 objectAtIndex:section] objectAtIndex:0];
    headerLabel.text = [App.arrDataLevel_1 objectAtIndex:section];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arrayTemp = [App.dictL_02 objectForKey:[App.arrDataLevel_1 objectAtIndex:section]];
    return arrayTemp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray *arrayTemp = [App.dictL_02 objectForKey:[App.arrDataLevel_1 objectAtIndex:indexPath.section]];
    cell.textLabel.text = [arrayTemp objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    NSString *strRecipe = [[App.dictL_02 objectForKey:[App.arrDataLevel_1 objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    App.arrayL_03 = (NSMutableArray *)[App getArrayWithIndex:App.arrDataLevel_3 indexObject:strRecipe indexColumn:0];
    vc2.title = strRecipe;
    [self.navigationController pushViewController:vc2 animated:YES];
}

@end
