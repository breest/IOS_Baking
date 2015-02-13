//
//  ViewEditController2.m
//  Baking
//
//  Created by Chang Wei on 15/1/26.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewEditController2.h"
#import "ViewEditController3.h"
#import "NavigationController3.h"

@interface ViewEditController2 ()

@end

@implementation ViewEditController2{
    AppDelegate *App;
    NavigationController3 *nvc;
    //UIBarButtonItem *itemR;
    UIPickerView *pickerCategory;
    UITextField *txtCategory, *txtName, *txtPrice;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    App = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    nvc = (NavigationController3 *)self.navigationController;
    
    UIBarButtonItem *itemR = [[UIBarButtonItem alloc] initWithTitle:@"編輯" style:UIBarButtonItemStylePlain target:self action:@selector(clickItem:)];
    self.navigationItem.rightBarButtonItem = itemR;
    
    UILabel *lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 120, 20)];
    lblCategory.text = @"材料類別";
    lblCategory.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCategory];
    
    pickerCategory = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 100, 120, 160)];
    pickerCategory.dataSource =self;
    pickerCategory.delegate=self;
    for (int i=0; i<App.arrDataCategory.count; i++) {
        if ([nvc.currentCategory isEqualToString:[App.arrDataCategory objectAtIndex:i]]) {
            [pickerCategory selectRow:(App.arrDataCategory.count * 50 + i) inComponent:0 animated:NO];
            break;
        }
    }
    pickerCategory.userInteractionEnabled = NO;
    [self.view addSubview:pickerCategory];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(160, 80, 80, 20)];
    lblName.text = @"材料名稱";
    [self.view addSubview:lblName];
    txtName = [[UITextField alloc] initWithFrame:CGRectMake(160, 110, 140, 25)];
    txtName.borderStyle = UITextBorderStyleRoundedRect;
    txtName.text = nvc.currentMaterial;
    txtName.enabled = FALSE;
    [self.view addSubview:txtName];
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(160, 160, 140, 20)];
    lblPrice.text = @"價格(元/千克)";
    [self.view addSubview:lblPrice];
    txtPrice = [[UITextField alloc] initWithFrame:CGRectMake(160, 190, 140, 25)];
    txtPrice.borderStyle = UITextBorderStyleRoundedRect;
    txtPrice.text = nvc.currentPrice;
    txtPrice.enabled = FALSE;
    [self.view addSubview:txtPrice];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickItem:(UIBarButtonItem *)item {
    ViewEditController3 *vec3 = [[ViewEditController3 alloc] init];
    vec3.title = @"編輯材料";
    nvc.edit = YES;
    [nvc pushViewController:vec3 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return App.arrDataCategory.count * 100;
}
/*
 -(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
 return [dataPicker objectAtIndex:(row % dataPicker.count)];
 }
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.text = [App.arrDataCategory objectAtIndex:(row % App.arrDataCategory.count)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row < (50 * App.arrDataCategory.count)||row >= (51 * App.arrDataCategory.count)) {
        unsigned long i = (App.arrDataCategory.count * 50) + (row % App.arrDataCategory.count);
        [pickerCategory selectRow:i inComponent:0 animated:NO];
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
