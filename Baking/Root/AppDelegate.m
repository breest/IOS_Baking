//
//  AppDelegate.m
//  Baking
//
//  Created by Chang Wei on 15/1/22.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyData.h"
#import "TabMainController.h"
#import "NaviLeftController.h"
#import "NaviRightController.h"
#import "ViewRootController.h"
#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self initArray];
    
    TabMainController *mainVC = [[TabMainController alloc] init];
    NaviLeftController *leftVC =[[NaviLeftController alloc]init];
    NaviRightController *rightVC=[[NaviRightController alloc]init];
    leftVC.view.backgroundColor=[UIColor purpleColor];
    rightVC.view.backgroundColor=[UIColor cyanColor];
    
    ViewRootController *rootVC = [ViewRootController sharedInstance];
    rootVC.mainViewController = mainVC;
    rootVC.leftViewController = leftVC;
    rootVC.rightViewController = rightVC;
    
    //viewRoot.animationType = SlideAnimationTypeMove;
    //viewRoot.needPanFromViewBounds = YES;
    
    self.window.rootViewController = rootVC;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initArray {
    sqlite3 *database;
    
    NSString *dataFile = [MyData dataFilePath:@"recipe.s3db"];
    if (sqlite3_open([dataFile UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }

    _arrDataCategory = (NSMutableArray *)[MyData getArrayFormTableD:database tableName:@"Category"];
    _arrDataCategory2 = (NSMutableArray *)[MyData getArrayFormTableD:database tableName:@"Category_level2"];
    _arrDataRecipe = (NSMutableArray *)[MyData getArrayFormTableD:database tableName:@"Recipe"];
    _arrDataRecipeDetail = (NSMutableArray *)[MyData getArrayFormTableD:database tableName:@"RecipeContent"];
    
    sqlite3_close(database);
    
    dataFile = [MyData dataFilePath:@"material.s3db"];
    if (sqlite3_open([dataFile UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    _arrDataMaterialCategory = (NSMutableArray *)[MyData getArrayFormTableD:database tableName:@"Category"];
    _arrDataMaterial = (NSMutableArray *)[MyData getArrayFormTableD:database tableName:@"Material"];
    
    sqlite3_close(database);
}

@end
