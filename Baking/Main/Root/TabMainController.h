//
//  TabMainController.h
//  Baking
//
//  Created by Chang Wei on 15/2/3.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabMainController : UITabBarController

@property (strong, nonatomic) NSArray *tabBarImages;

- (id)initWithChildViewControllers:(NSArray *)controllers tabTitles:(NSArray *)titles tabImages:(NSArray *)images selectedImages:(NSArray *)selectedImages backgroundImage:(NSString *)backgroundImage selectionIndicatorImage:(NSString *)selectionIndicatorImage;

@end
