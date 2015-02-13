//
//  ViewLeftRecipeController.m
//  Baking
//
//  Created by Chang Wei on 15/1/31.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyData.h"
#import "ViewLeftRecipeController.h"

@interface ViewLeftRecipeController (){
    NSMutableArray *arrayRecipe;
}

@end

@implementation ViewLeftRecipeController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayRecipe.count;
}

- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //arrayCell = [[arrayRoot objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imgTitle.image = [UIImage imageNamed:@"06"];
    cell.lblTitle.text = [arrayRecipe objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayRecipe = (NSMutableArray *)[MyData getArrayWithIndex:App.arrDataCategory2 indexObject:self.title indexColumn:0];
    arrayRecipe = (NSMutableArray *)[MyData getArrayWithIndex:arrayRecipe indexColumn:1];
    
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
