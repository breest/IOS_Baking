//
//  VC_Left_Super.h
//  Baking
//
//  Created by Chang Wei on 15/1/31.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImage+ImageEffects.h"
#import "TableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface VC_Left_Super : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    AppDelegate *App;
    UITableView *tableCurrent;
}

@end
