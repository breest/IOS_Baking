//
//  AppDelegate.h
//  Baking
//
//  Created by Chang Wei on 15/1/22.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <sqlite3.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property CGSize screen;

@property NSMutableArray *arrDataCategory, *arrDataCategory2, *arrDataRecipe, *arrDataRecipeDetail;
@property NSMutableArray *arrDataMaterial, *arrDataMaterialCategory;
@property NSMutableDictionary *dictL_02;
@property NSMutableDictionary *dictMaterial;
@property NSMutableArray *arrayRecipe, *arrayRecipeCatalog;
@property NSString *recipeCategory;

@end

