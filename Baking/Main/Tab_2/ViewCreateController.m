//
//  ViewCreateController.m
//  Baking
//
//  Created by Chang Wei on 15/1/29.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewCreateController.h"

@interface ViewCreateController ()

@end

@implementation ViewCreateController{
    AppDelegate *App;
    UIView *viewTitle, *viewFooter;
    UILabel *lblCategory;
    UITextField *txtRecipe;
    UIButton *btnEdit, *btnMove, *btnDelete;
    NSMutableArray *arrayGoods, *arrayRecipe;
    UITableView *tableCategory, *tableGoods, *tableRecipe;
    NSInteger sectionCategory, rowCategory, sectionGoods, rowGoods, sectionRecipe, rowRecipe;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    App = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    App.dictL_02 = (NSMutableDictionary *)[App getDictionaryWithUniqueColumnValue:App.arrDataLevel_2 indexColumn:0];
    
    viewTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 64, App.screen.width, 66)];
    viewTitle.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewTitle];
    
    lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 145, 21)];
    lblCategory.text = @"";
    lblCategory.textColor = [UIColor whiteColor];
    [viewTitle addSubview:lblCategory];
    
    txtRecipe = [[UITextField alloc] initWithFrame:CGRectMake(15, 30, 145, 30)];
    txtRecipe.textColor = [UIColor whiteColor];
    txtRecipe.enabled = FALSE;
    [viewTitle addSubview:txtRecipe];
    
    btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(App.screen.width -155, 18, 45, 30)];
    btnEdit.backgroundColor = [UIColor colorWithRed:0 green:0.75 blue:0 alpha:1];
    [btnEdit setTitle:@"編輯" forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btnEdit.enabled = FALSE;
    btnEdit.tag = 1;
    [viewTitle addSubview:btnEdit];
    
    btnMove = [[UIButton alloc] initWithFrame:CGRectMake(App.screen.width -105, 18, 45, 30)];
    btnMove.backgroundColor = [UIColor colorWithRed:1 green:0.5 blue:0 alpha:1];
    [btnMove setTitle:@"新增" forState:UIControlStateNormal];
    [btnMove addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btnMove.enabled = FALSE;
    btnMove.tag = 2;
    [viewTitle addSubview:btnMove];
    
    btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(App.screen.width -55, 18, 45, 30)];
    btnDelete.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [btnDelete setTitle:@"刪除" forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btnDelete.enabled = FALSE;
    btnDelete.tag=3;
    [viewTitle addSubview:btnDelete];
    
    tableCategory = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, App.screen.width/3, App.screen.height - 179) style:UITableViewStylePlain];
    tableCategory.dataSource = self;
    tableCategory.delegate = self;
    tableCategory.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
    tableCategory.tag = 1;
    [self.view addSubview:tableCategory];
    
    tableGoods = [[UITableView alloc] initWithFrame:CGRectMake(App.screen.width/3, 130, App.screen.width/3, App.screen.height - 179) style:UITableViewStylePlain];
    tableGoods.dataSource = self;
    tableGoods.delegate =self;
    tableGoods.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
    tableGoods.tag = 2;
    [self.view addSubview:tableGoods];

    tableRecipe = [[UITableView alloc] initWithFrame:CGRectMake(2*App.screen.width/3, 130, App.screen.width/3, App.screen.height - 179) style:UITableViewStylePlain];
    tableRecipe.dataSource = self;
    tableRecipe.delegate =self;
    tableRecipe.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1];
    tableRecipe.tag = 3;
    [self.view addSubview:tableRecipe];
    /*
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];*/
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            if (txtRecipe.enabled) {
                //NSArray *arrayTemp = [App.dictL_02 objectForKey:[App.arrDataLevel_1 objectAtIndex:section]];
                NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:nil];
                for (int i=0; i<App.arrDataLevel_1.count; i++) {
                    if (i == rowCategory) {
                        [arrayTemp addObject:txtRecipe.text];
                    }else{
                        [arrayTemp addObject:[arrayTemp objectAtIndex:i]];
                    }
                }
                //[App.dictL_02 setObject:arrayTemp2 forKey:[App.arrDataLevel_1 objectAtIndex:section]];
                App.arrDataLevel_1 = arrayTemp;
                [tableCategory reloadData];
                //[arrayTemp objectAtIndex:indexPath.row];
                [btnEdit setTitle:@"編輯" forState:UIControlStateNormal];
                txtRecipe.backgroundColor = [UIColor clearColor];
                txtRecipe.enabled = FALSE;
            }else{
                [btnEdit setTitle:@"完成" forState:UIControlStateNormal];
                txtRecipe.backgroundColor = [UIColor darkGrayColor];
                txtRecipe.enabled = TRUE;
            }
            break;
            
        default:
            break;
    }
}
/*
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App.screen.width, h)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, h-30, App.screen.width, 30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont boldSystemFontOfSize:18.0];
    headerLabel.textColor = [UIColor blueColor];
    headerLabel.text = [App.arrDataLevel_1 objectAtIndex:section];
    [headerView addSubview:headerLabel];
    return headerView;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSArray *arrayTemp = [App.dictL_02 objectForKey:[App.arrDataLevel_1 objectAtIndex:section]];
    NSInteger rows = 0;
    switch (tableView.tag) {
        case 1:
            rows = App.arrDataLevel_1.count;
            break;
        case 2:
            rows = arrayGoods.count;
            break;
        case 3:
            rows = arrayRecipe.count;
            break;
            
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    switch (tableView.tag) {
        case 1:
            cell.textLabel.text = [App.arrDataLevel_1 objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.textLabel.text = [arrayGoods objectAtIndex:indexPath.row];
            break;
        case 3:
            cell.textLabel.text = [arrayRecipe objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrayTemp;
    switch (tableView.tag) {
        case 1:
            sectionCategory = indexPath.section;
            rowCategory = indexPath.row;
            txtRecipe.text = [App.arrDataLevel_1 objectAtIndex:indexPath.row];
            arrayTemp = [App getArrayWithIndex:App.arrDataLevel_2 indexObject:txtRecipe.text indexColumn:0];
            arrayGoods = (NSMutableArray *)[App getArrayWithIndex:arrayTemp indexColumn:1];
            [tableGoods reloadData];
            break;
        case 2:
            sectionGoods = indexPath.section;
            rowGoods = indexPath.row;
            txtRecipe.text = [arrayGoods objectAtIndex:indexPath.row];
            arrayTemp = [App getArrayWithIndex:App.arrDataLevel_3 indexObject:txtRecipe.text indexColumn:0];
            arrayRecipe = (NSMutableArray *)[App getArrayWithIndex:arrayTemp indexColumn:1];
            [tableRecipe reloadData];
            break;
        case 3:
            sectionRecipe = indexPath.section;
            rowRecipe = indexPath.row;
            txtRecipe.text = [arrayRecipe objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }

    //lblCategory.text = [App.arrDataLevel_1 objectAtIndex:section];
    //txtRecipe.text = [[App.dictL_02 objectForKey:lblCategory.text] objectAtIndex:row];
    btnEdit.enabled = btnMove.enabled = btnDelete.enabled = TRUE;
}

- (void)hideKeyboard {
    [txtRecipe resignFirstResponder];
    self.tabBarController.tabBar.hidden = !self.tabBarController.tabBar.hidden;
    if (self.tabBarController.tabBar.hidden) {
        tableRecipe.frame = CGRectMake(0, 130, App.screen.width, App.screen.height - 130);
    }else{
        tableRecipe.frame = CGRectMake(0, 130, App.screen.width, App.screen.height - 179);
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
