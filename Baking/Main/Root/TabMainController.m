//
//  TabMainController.m
//  Baking
//
//  Created by Chang Wei on 15/2/3.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "ViewUserFavoriteController.h"
#import "ViewUserRecentController.h"
#import "ViewUserLocalController.h"
#import "ViewUserUnitController.h"
#import "ViewRecipeController.h"
#import "ViewShareFBController.h"
#import "ViewShareLineController.h"
#import "ViewSettingRecipeController.h"
#import "ViewSettingMatController.h"
#import "ViewSettingDBController.h"
#import "ViewSettingUIController.h"
#import "ViewSettingCustomController.h"
#import "ViewSettingUserController.h"
#import "NaviMainStartController.h"
#import "NaviSuperMainController.h"
#import "TabMainController.h"

@interface TabMainController () {
    NSArray *_titles;
    NSArray *_images;
    NSArray *_selectedImages;
    UIImage *_backgroundImage;
    UIImage *_selectionIndicatorImage;
}

@end

@implementation TabMainController

- (instancetype)init{
    if (self = [super init]) {
        ViewUserFavoriteController *vc00 = [[ViewUserFavoriteController alloc] init];
        NaviSuperMainController *nvc00 = [[NaviSuperMainController alloc] initWithRootViewController:vc00];
        ViewUserRecentController *vc01 = [[ViewUserRecentController alloc] init];
        NaviSuperMainController *nvc01 = [[NaviSuperMainController alloc] initWithRootViewController:vc01];
        ViewUserLocalController *vc02 = [[ViewUserLocalController alloc] init];
        NaviSuperMainController *nvc02 = [[NaviSuperMainController alloc] initWithRootViewController:vc02];
        ViewUserUnitController *vc03 = [[ViewUserUnitController alloc] init];
        NaviSuperMainController *nvc03 = [[NaviSuperMainController alloc] initWithRootViewController:vc03];
        ViewRecipeController *vc1 = [[ViewRecipeController alloc] init];
        NaviSuperMainController *nvc1 = [[NaviSuperMainController alloc] initWithRootViewController:vc1];
        ViewShareFBController *vc20 = [[ViewShareFBController alloc] init];
        NaviSuperMainController *nvc20 = [[NaviSuperMainController alloc] initWithRootViewController:vc20];
        ViewShareLineController *vc21 = [[ViewShareLineController alloc] init];
        NaviSuperMainController *nvc21 = [[NaviSuperMainController alloc] initWithRootViewController:vc21];
        ViewSettingRecipeController *vc30= [[ViewSettingRecipeController alloc] init];
        NaviSuperMainController *nvc30 = [[NaviSuperMainController alloc] initWithRootViewController:vc30];
        ViewSettingMatController *vc31 = [[ViewSettingMatController alloc] init];
        NaviSuperMainController *nvc31 = [[NaviSuperMainController alloc] initWithRootViewController:vc31];
        ViewSettingDBController *vc320 = [[ViewSettingDBController alloc] init];
        NaviSuperMainController *nvc320 = [[NaviSuperMainController alloc] initWithRootViewController:vc320];
        ViewSettingUIController *vc321 = [[ViewSettingUIController alloc] init];
        NaviSuperMainController *nvc321 = [[NaviSuperMainController alloc] initWithRootViewController:vc321];
        ViewSettingCustomController *vc322 = [[ViewSettingCustomController alloc] init];
        NaviSuperMainController *nvc322 = [[NaviSuperMainController alloc] initWithRootViewController:vc322];
        ViewSettingUserController *vc323 = [[ViewSettingUserController alloc] init];
        NaviSuperMainController *nvc323 = [[NaviSuperMainController alloc] initWithRootViewController:vc323];
        NSArray *controllers = @[nvc00,nvc01,nvc02,nvc03,nvc1,nvc20,nvc21,nvc30,nvc31,nvc320,nvc321,nvc322,nvc323];
        NSArray *titles = @[@"vc1",@"vc2",@"vc3",@"nvc1",@"nvc1",@"24",@"24",@"24",@"vc3",@"nvc1",@"24",@"24",@"24"];
        NSArray *images = @[@"21",@"22",@"23",@"24",@"nvc1",@"24",@"24",@"24",@"vc3",@"nvc1",@"24",@"24",@"24"];
        NSArray *selectedImages = @[@"11",@"12",@"13",@"14",@"nvc1",@"24",@"vc3",@"nvc1",@"24",@"24",@"24"];
        return [self initWithChildViewControllers:controllers tabTitles:titles tabImages:images selectedImages:selectedImages backgroundImage:@"bk" selectionIndicatorImage:@"tab_bg_pressed"];
    }
    return self;
}

- (id)initWithChildViewControllers:(NSArray *)controllers tabTitles:(NSArray *)titles tabImages:(NSArray *)images selectedImages:(NSArray *)selectedImages backgroundImage:(NSString *)backgroundImage selectionIndicatorImage:(NSString *)selectionIndicatorImage {
    if (self = [super init]) {
        for (int i = 0; i < controllers.count; ++i) {
            [self addChildViewController:controllers[i]];
            _titles = titles;
            _images = images;
            _selectedImages = selectedImages;
            _backgroundImage = [self imageNamedWithDefaultRenderingMode:backgroundImage];
            _selectionIndicatorImage = [self imageNamedWithDefaultRenderingMode:selectionIndicatorImage];
        }
        self.title = titles[0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.tabBar.hidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBar.hidden = true;
    self.tabBar.backgroundImage = _backgroundImage;
    self.tabBar.selectionIndicatorImage = _selectionIndicatorImage;
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        item.titlePositionAdjustment = UIOffsetMake(0, -3);
        item.title = _titles[i];
        item.image = [self imageNamedWithDefaultRenderingMode:_images[i]];
        item.selectedImage = [self imageNamedWithDefaultRenderingMode:_selectedImages[i]];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0x3c / 255.0 green:0x80 / 255.0 blue:0x1a / 255.0 alpha:1.0], NSBackgroundColorAttributeName, nil] forState:UIControlStateNormal];
    }
}

- (UIImage *)imageNamedWithDefaultRenderingMode:(NSString *)imageName {
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
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
