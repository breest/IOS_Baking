//
//  ViewTest.m
//  Baking
//
//  Created by Chang Wei on 15/1/26.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "ViewTest.h"

@interface ViewTest ()

@end

@implementation ViewTest{
    NSArray *dataPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    dataPicker = [NSArray arrayWithObjects:@"粉類", @"液體材料類", @"酵母", @"糖、鹽", @"蛋", @"油", @"其它", nil];
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return dataPicker.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"[dataPicker objectAtIndex:row]";
}
@end
