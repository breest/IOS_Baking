//
//  VC_Left_Super.m
//  Baking
//
//  Created by Chang Wei on 15/1/31.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "VC_Left_Super.h"

@interface VC_Left_Super ()

@end

@implementation VC_Left_Super

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.tag = 77;
    
    App = [[UIApplication sharedApplication] delegate];
    
    UIImage *img1;
    img1 = [UIImage imageNamed:@"bk.jpg"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.image = [img1 applyBlurWithRadius:8 tintColor:[UIColor colorWithWhite:1 alpha:0.4] saturationDeltaFactor:1.8 maskImage:nil];
    [self.view addSubview:imgView];    
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
