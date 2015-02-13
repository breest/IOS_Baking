//
//  MyArray.h
//  Baking
//
//  Created by Chang Wei on 15/2/7.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableArray(ArrayBoost)<UIAlertViewDelegate>

- (void)addObject_CC:(id)anObject;
- (BOOL)addArray_CC:(id)newArray uniqueColumn:(NSInteger)indexColumn;
- (BOOL)allObjectsIsArray_CC;
- (void)appendArray_CC:(NSArray *)newArray;
- (NSInteger)columns_CC;
- (NSArray *)getSubArrayWithColumn_CC:(NSInteger)index;
- (NSArray *)getSubArrayWithArray_CC:(NSArray *)indexArray;
- (NSArray *)getRowsWithKey_CC:(id)Object inColumn:(NSInteger)index;
- (void)removeRowWithKey_CC:(id)Object inColumn:(NSInteger)index;
- (NSArray *)sortWithDictionaryArray_CC:(NSArray *)dictionaryArray;

@end
