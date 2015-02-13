//
//  ViewRecipeController.h
//  Baking
//
//  Created by Chang Wei on 15/2/3.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewMainController.h"

typedef NS_ENUM(NSInteger, EditType) {
    EditTypeNone,
    EditTypeAddNew,
    EditTypeModify
};

@interface ViewSettingRecipeController : ViewMainController<UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end
