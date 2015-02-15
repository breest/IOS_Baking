//
//  MyMutableArray.h
//  Baking
//
//  Created by Chang Wei on 15/2/13.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableArray(ArrayBoost)<UIAlertViewDelegate>

- (void)addObject_CC:(id)anObject;
- (BOOL)addArray_CC:(id)newArray uniqueColumn:(NSInteger)indexColumn;
- (void)appendArray_CC:(NSArray *)newArray;
- (NSArray *)arrayAddColumn_CC:(NSUInteger)indexColumn defaultValue:(id)defaultObject;
- (void)removeRowWithKey_CC:(id)Object inColumn:(NSInteger)index;

@end
