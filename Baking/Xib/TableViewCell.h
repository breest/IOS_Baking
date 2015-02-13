//
//  TableViewCell.h
//  Baking
//
//  Created by Chang Wei on 15/1/26.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblMaterial;
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeName;
@property (weak, nonatomic) IBOutlet UILabel *lblProvider;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;
@property (weak, nonatomic) IBOutlet UILabel *lblMemo;
@property (weak, nonatomic) IBOutlet UIImageView *imgRecipe;
@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCarolie;

@end
