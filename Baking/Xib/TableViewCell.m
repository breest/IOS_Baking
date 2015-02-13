//
//  TableViewCell.m
//  Baking
//
//  Created by Chang Wei on 15/1/26.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.backgroundColor = [UIColor redColor];
    _lblMemo.text = @"使用者備註，使用者備註，使用者備註，使用者備註，使用者備註，使用者備註";
    //_imgTitle.contentMode = UIViewContentModeScaleToFill;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
