//
//  ViewController3.m
//  Baking
//
//  Created by Chang Wei on 15/1/25.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//
#import "AppDelegate.h"
#import "TableViewCell.h"
#import "ViewController3.h"
#import "NavigationController.h"

@interface ViewController3 ()

@end

@implementation ViewController3{
    AppDelegate *App;
    NavigationController *nvc;
    UIBarButtonItem *itemR;
    UIView *viewTitle, *viewFooter;
    UITextField *txtWeight, *txtQuantity;
    UILabel *lblTotalAmount;
    UITableView *tableCurrent;
    NSMutableArray *arrayRecipe;
    int totalPercent, j;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 13;
    // Do any additional setup after loading the view.
    App = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    itemR = [[UIBarButtonItem alloc] initWithTitle:@"計算" style:UIBarButtonItemStylePlain target:self action:@selector(clickItemR:)];
    itemR.enabled = FALSE;
    self.navigationItem.RightBarButtonItem = itemR;
    
    viewTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 64, App.screen.width, 60)];
    viewTitle.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewTitle];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 80, 21)];
    lblTemp.text = @"麵團重量";
    lblTemp.textColor = [UIColor whiteColor];
    [viewTitle addSubview:lblTemp];
    
    txtWeight = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 60, 30)];
    txtWeight.placeholder = @"重量";
    txtWeight.backgroundColor = [UIColor whiteColor];
    txtWeight.textAlignment = NSTextAlignmentCenter;
    txtWeight.keyboardType = UIKeyboardTypeNumberPad;
    txtWeight.returnKeyType = UIReturnKeyNext;
    [txtWeight addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    txtWeight.tag = 1;
    [viewTitle addSubview:txtWeight];
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(155, 11, 30, 21)];
    lblTemp.text = @"克×";
    lblTemp.textColor = [UIColor whiteColor];
    [viewTitle addSubview:lblTemp];
    
    txtQuantity = [[UITextField alloc] initWithFrame:CGRectMake(190, 7, 45, 30)];
    txtQuantity.placeholder = @"數量";
    txtQuantity.backgroundColor = [UIColor whiteColor];
    txtQuantity.textAlignment = NSTextAlignmentCenter;
    txtQuantity.keyboardType = UIKeyboardTypeNumberPad;
    txtQuantity.returnKeyType = UIReturnKeyDone;
    [txtQuantity addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    txtWeight.tag = 2;
    [viewTitle addSubview:txtQuantity];
    
    lblTotalAmount = [[UILabel alloc] initWithFrame:CGRectMake(App.screen.width - 75, 11, 60, 21)];
    //lblTotalAmount.text = @"12345";
    lblTotalAmount.textAlignment = NSTextAlignmentRight;
    lblTotalAmount.textColor = [UIColor redColor];
    [viewTitle addSubview:lblTotalAmount];
    
    arrayRecipe = [NSMutableArray arrayWithObjects:nil];
    NSArray *arrayTemp;
    for (int i = 0; i < App.arrayRecipe.count; i++) {
        arrayTemp = [App.arrayRecipe objectAtIndex:i];
        totalPercent += [[arrayTemp objectAtIndex:1] intValue];
        [arrayRecipe addObject:@[[arrayTemp objectAtIndex:0], [arrayTemp objectAtIndex:1], [arrayTemp objectAtIndex:1]] ];
    }
    //[NSString stringWithFormat:@"%i",totalPercent];
    [arrayRecipe addObject:@[@"烘焙百分比", [NSString stringWithFormat:@"%i",totalPercent], [NSString stringWithFormat:@"%i",totalPercent]]];
    
    tableCurrent = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, App.screen.width, App.screen.height - 203) style:UITableViewStylePlain];
    tableCurrent.dataSource = self;
    tableCurrent.delegate = self;
    [self.view addSubview:tableCurrent];
    
    viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, App.screen.height - 137, App.screen.width, 88)];
    viewFooter.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    [self.view addSubview:viewFooter];
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 21)];
    lblTemp.text = @"盛皿：";
    lblTemp.textColor = [UIColor blackColor];
    [viewFooter addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(15, 54, 60, 21)];
    lblTemp.text = @"爐溫：";
    lblTemp.textColor = [UIColor blackColor];
    [viewFooter addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(170, 54, 60, 21)];
    lblTemp.text = @"時間：";
    lblTemp.textColor = [UIColor blackColor];
    [viewFooter addSubview:lblTemp];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickItemR:(UIBarButtonItem *)item {
    [self hideKeyboard];
    double ratio;
    ratio = (double)[lblTotalAmount.text intValue]/[[[arrayRecipe objectAtIndex:(arrayRecipe.count-1)] objectAtIndex:1] intValue];
    NSMutableArray *arrayTemp, *arrayTemp2 = [NSMutableArray arrayWithObjects:nil];
    int amount;
    for (int i=0; i<arrayRecipe.count; i++) {
        arrayTemp = [arrayRecipe objectAtIndex:i];
        amount = [[arrayTemp objectAtIndex:1]intValue]*ratio;
        [arrayTemp2 addObject:@[[arrayTemp objectAtIndex:0],[arrayTemp objectAtIndex:1],[NSString stringWithFormat:@"%i",amount]]];
    }
    arrayRecipe = arrayTemp2;
    [tableCurrent reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayRecipe.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
    }

    NSString *s1, *s2;
    NSArray *arrayTemp = [arrayRecipe objectAtIndex:indexPath.row];
    s1 = [arrayTemp objectAtIndex:0];
    s2 = [arrayTemp objectAtIndex:1];
    cell.lblMaterial.text = [[arrayRecipe objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.lblPercent.text = [[arrayRecipe objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.lblAmount.text = [[arrayRecipe objectAtIndex:indexPath.row] objectAtIndex:2];
    
    return cell;
}

- (void)textFieldDidChange:(UITextField *)sender {
    if ([txtWeight.text isEqualToString:@""]||[txtQuantity.text isEqualToString:@""]) {
        lblTotalAmount.text = @"";
        itemR.enabled = FALSE;
    }else{
        lblTotalAmount.text = [NSString stringWithFormat:@"%i", [txtWeight.text intValue] * [txtQuantity.text intValue]];
        itemR.enabled = TRUE;
    }
}

- (void)hideKeyboard {
    [txtWeight resignFirstResponder];
    [txtQuantity resignFirstResponder];
    self.tabBarController.tabBar.hidden = !self.tabBarController.tabBar.hidden;
    if (self.tabBarController.tabBar.hidden) {
        tableCurrent.frame = CGRectMake(0, 110, App.screen.width, App.screen.height - 198);
        viewFooter.frame = CGRectMake(0, App.screen.height - 88, App.screen.width, 88);
    }else{
        tableCurrent.frame = CGRectMake(0, 110, App.screen.width, App.screen.height - 247);
        viewFooter.frame = CGRectMake(0, App.screen.height - 137, App.screen.width, 88);
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
