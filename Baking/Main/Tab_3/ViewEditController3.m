//
//  ViewEditController3.m
//  Baking
//
//  Created by Chang Wei on 15/1/27.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewEditController3.h"
#import "NavigationController3.h"

@interface ViewEditController3 ()

@end

@implementation ViewEditController3{
    AppDelegate *App;
    NavigationController3 *nvc;
    UIBarButtonItem *itemL, *itemR;
    UIPickerView *pickerCategory;
    UITextField *txtName, *txtPrice;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    App = [[UIApplication sharedApplication] delegate];
    nvc = (NavigationController3 *)self.navigationController;
    
    itemL = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickItemL:)];
    itemR = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickItemR:)];
    itemR.enabled = FALSE;
    self.navigationItem.leftBarButtonItem = itemL;
    self.navigationItem.rightBarButtonItem = itemR;
    
    UILabel *lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 120, 20)];
    lblCategory.text = @"材料類別";
    lblCategory.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCategory];
    
    pickerCategory = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 100, 120, 160)];
    pickerCategory.dataSource =self;
    pickerCategory.delegate=self;
    if (nvc.edit) {
        for (int i=0; i<App.arrDataCategory.count; i++) {
            if ([nvc.currentCategory isEqualToString:[App.arrDataCategory objectAtIndex:i]]) {
                [pickerCategory selectRow:(App.arrDataCategory.count * 50 + i) inComponent:0 animated:NO];
                break;
            }
        }
    }else{
        [pickerCategory selectRow:(App.arrDataCategory.count * 50) inComponent:0 animated:NO];
    }
    [self.view addSubview:pickerCategory];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(160, 80, 80, 20)];
    lblName.text = @"材料名稱";
    [self.view addSubview:lblName];
    txtName = [[UITextField alloc] initWithFrame:CGRectMake(160, 110, 140, 25)];
    txtName.borderStyle = UITextBorderStyleBezel;
    txtName.text = nvc.currentMaterial;
    txtName.keyboardType = UIKeyboardTypeDefault;
    txtName.returnKeyType = UIReturnKeyNext;
    [txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    txtName.tag = 1;
    [self.view addSubview:txtName];
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(160, 160, 140, 20)];
    lblPrice.text = @"價格(元/千克)";
    [self.view addSubview:lblPrice];
    txtPrice = [[UITextField alloc] initWithFrame:CGRectMake(160, 190, 140, 25)];
    txtPrice.borderStyle = UITextBorderStyleBezel;
    txtPrice.text = nvc.currentPrice;
    txtPrice.keyboardType = UIKeyboardTypeNumberPad;
    txtPrice.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:txtPrice];

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickItemL:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickItemR:(UIBarButtonItem *)item {
    NSString *s1, *s2, *s3;
    NSInteger row = [pickerCategory selectedRowInComponent:0];
    s1 = [App.arrDataCategory objectAtIndex:(row % App.arrDataCategory.count)];
    s2 = txtName.text;
    s3 = txtPrice.text;
    //[App.arrDataPrice addObject:@[s1, s2, s3]];
    //NSMutableArray *arraytemp = [App.dictMaterial objectForKey:s1];
    /*
    for (int i=0; i<App.arrDataPrice.count; i++) {
        if ([s2 isEqualToString:[[App.arrDataPrice objectAtIndex:i] objectAtIndex:1]]) {
            UIAlertView *existAlert = [[UIAlertView alloc] initWithTitle:@"該材料已存在"
                                                                 message:@"如需修改材料的分類或價格請回到上層選單後使用編輯功能！"
                                                                delegate:nil
                                                       cancelButtonTitle:@"確定"
                                                       otherButtonTitles:nil];
            [existAlert show];
            return;
        }
    }
    [arraytemp addObject:@[s2, s3]];
    [App.dictMaterial setObject:arraytemp forKey:s1];
    NSString *datafile = [App dataFilePath:@"material.s3db"];
    [App.arrDataPrice addObject:@[s1, s2, s3]];*/
    //[App addRecordToFile:datafile tableName:@"Price" InsertArray:@[s1, s2, s3]];
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)textFieldDidChange:(UITextField *)sender {
    NSString *s =sender.text;
    switch (sender.tag) {
        case 1:
            s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([s isEqualToString:@""]) {
                itemR.enabled = FALSE;
            }else{
                itemR.enabled = TRUE;
            }
            break;
            
        default:
            break;
    }
}

- (void)hideKeyboard {
    [txtName resignFirstResponder];
    [txtPrice resignFirstResponder];
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
