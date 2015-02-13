//
//  NavigationController3.h
//  Baking
//
//  Created by Chang Wei on 15/1/26.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationSlideController.h"

@interface NavigationController3 : NavigationSlideController
@property NSString *currentCategory, *currentMaterial, *currentPrice;
@property BOOL edit;
@end
