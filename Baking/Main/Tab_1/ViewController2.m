//
//  ViewController2.m
//  Baking
//
//  Created by Chang Wei on 15/1/24.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewCell.h"
#import "ViewController2.h"
#import "ViewController3.h"

@interface ViewController2 ()

@end

@implementation ViewController2{
    AppDelegate *App;
    //NSMutableArray *arrayCurrent, *arrTemp;
    UITableView *tableCurrent;
    NSString *strRecipeName, *strProvider, *strDescribe;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 12;
    // Do any additional setup after loading the view.
    App = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    App.arrayRecipeCatalog = [NSMutableArray arrayWithObjects: nil];
    
    
    for (int i=0; i < App.arrayL_03.count; i++) {
        strRecipeName = [[App.arrayL_03 objectAtIndex:i] objectAtIndex:1];
        for (int j=0; j<App.arrDataRecipe.count; j++) {
            if ([[[App.arrDataRecipe objectAtIndex:j] objectAtIndex:0] isEqualToString:strRecipeName]) {
                strProvider = [[App.arrDataRecipe objectAtIndex:j] objectAtIndex:1];
                strDescribe = [[App.arrDataRecipe objectAtIndex:j] objectAtIndex:2];
                [App.arrayRecipeCatalog addObject:@[strRecipeName, strProvider, strDescribe]];
            }
        }
        
    }
    
    tableCurrent = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableCurrent.dataSource = self;
    tableCurrent.delegate = self;
    [self.view addSubview:tableCurrent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return App.arrayRecipeCatalog.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:2];
    }

    cell.lblRecipeName.text = [[App.arrayRecipeCatalog objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.lblProvider.text = [[App.arrayRecipeCatalog objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.lblDescribe.text = [[App.arrayRecipeCatalog objectAtIndex:indexPath.row] objectAtIndex:2];
    cell.imgRecipe.image = [UIImage imageNamed:@"250.png"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViewController3 *vc3 = [[ViewController3 alloc] init];
    strRecipeName = [[App.arrayRecipeCatalog objectAtIndex:indexPath.row] objectAtIndex:0];
    vc3.title = strRecipeName;
    App.arrayRecipe = [NSMutableArray arrayWithObjects: nil];
    NSString *strMaterial, *strQuantity;
    for (int i=0; i < App.arrDataRecipeDetail.count; i++) {
        if ([[[App.arrDataRecipeDetail objectAtIndex:i] objectAtIndex:0] isEqualToString:strRecipeName]) {
            strMaterial = [[App.arrDataRecipeDetail objectAtIndex:i] objectAtIndex:1];
            strQuantity = [[App.arrDataRecipeDetail objectAtIndex:i] objectAtIndex:2];
            [App.arrayRecipe addObject:@[strMaterial, strQuantity]];
        }
    }
    [self.navigationController pushViewController:vc3 animated:YES];
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
