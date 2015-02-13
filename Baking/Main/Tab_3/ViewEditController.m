//
//  ViewEditController.m
//  Baking
//
//  Created by Chang Wei on 15/1/26.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewEditController.h"
#import "ViewEditController2.h"
#import "ViewEditController3.h"
#import "TableViewCell.h"
#import "NavigationController3.h"

@interface ViewEditController ()

@end

@implementation ViewEditController{
    AppDelegate *App;
    NavigationController3 *nvc;
    UIBarButtonItem *itemL, *itemR;
    UIView *viewTitle;
    UITableView *tableCurrent;
    NSMutableArray *arrayCategory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    App = [[UIApplication sharedApplication] delegate];
    //App.dictMaterial = (NSMutableDictionary *)[App getDictionaryWithUniqueColumnValue:App.arrDataPrice indexColumn:0];
    nvc = (NavigationController3 *)self.navigationController;

    itemL = [[UIBarButtonItem alloc] initWithTitle:@"資料庫" style:UIBarButtonItemStyleDone target:self action:@selector(clickItemL:)];
    self.navigationItem.leftBarButtonItem = itemL;
    itemR = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(clickItemR:)];
    self.navigationItem.rightBarButtonItem = itemR;
    
    tableCurrent = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableCurrent.dataSource = self;
    tableCurrent.delegate = self;
    [self.view addSubview:tableCurrent];
}

- (void)viewWillAppear:(BOOL)animated{
    [tableCurrent reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickItemL:(UIBarButtonItem *)item {
}

- (void)clickItemR:(UIBarButtonItem *)item {
    ViewEditController3 *vec3 = [[ViewEditController3 alloc] init];
    vec3.title = @"新增材料";
    nvc.currentMaterial = @"";
    nvc.currentPrice = @"";
    nvc.edit = NO;
    [nvc pushViewController:vec3 animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return App.dictMaterial.count;
}
/*
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return App.arrDataCategory;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keys = [App.dictMaterial allKeys];
    arrayCategory = (NSMutableArray *)[keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];

    NSArray *arrayTemp = [App.dictMaterial objectForKey:[arrayCategory objectAtIndex:section]];
    return arrayTemp.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSArray *arrayTemp = [App.dictMaterial objectForKey:[arrayCategory objectAtIndex:indexPath.section]];
    cell.lblTitle.text = [[arrayTemp objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.lblPrice.text = [[arrayTemp objectAtIndex:indexPath.row] objectAtIndex:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViewEditController2 *vec2 = [[ViewEditController2 alloc] init];
    NSMutableArray *arrayTemp = [App.dictMaterial objectForKey:[arrayCategory objectAtIndex:indexPath.section]];
    nvc.currentCategory = [arrayCategory objectAtIndex:indexPath.section];
    nvc.currentMaterial = [[arrayTemp objectAtIndex:indexPath.row] objectAtIndex:0];
    nvc.currentPrice = [[arrayTemp objectAtIndex:indexPath.row] objectAtIndex:1];
    [nvc pushViewController:vec2 animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arrayTemp = [App.dictMaterial objectForKey:[arrayCategory objectAtIndex:indexPath.section]];
    NSString *whereString = [[arrayTemp objectAtIndex:indexPath.row] objectAtIndex:0];
    
    if (arrayTemp.count == 1) {
        [App.dictMaterial removeObjectForKey:[arrayCategory objectAtIndex:indexPath.section]];
        [arrayCategory removeObjectAtIndex:indexPath.section];
    }else{
        [arrayTemp removeObjectAtIndex:indexPath.row];
        [App.dictMaterial setObject:arrayTemp forKey:[arrayCategory objectAtIndex:indexPath.section]];
    }
    NSString *datafile = [App dataFilePath:@"material.s3db"];
    whereString = [NSString stringWithFormat:@"MaterialName = '%@'",whereString];
    [App deleteRecordFromFile:datafile tableName:@"Price" where:whereString];

    [tableView reloadData];
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
