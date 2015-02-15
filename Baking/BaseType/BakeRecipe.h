//
//  BakeRecipe.h
//  Baking
//
//  Created by Chang Wei on 15/2/14.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BakeMaterial.h"

@interface BakeRecipe : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *provider;
@property (copy, nonatomic) NSString *describe;
@property (copy, nonatomic) NSString *memo;
@property (copy, nonatomic) NSString *imageFile;
@property (retain, nonatomic) NSMutableArray *recipeMaterials;//[材料名稱,材料數量]數組
@property (copy, readonly, nonatomic) NSString *unit;//recipeMaterials中材料數量單位
@property (copy, nonatomic) NSString *unitCurrent;//當下輸入和顯示時使用的材料數量單位

- (NSUInteger)materialCount;
- (BOOL)allPriceExist;
- (BOOL)allCalorieExist;
- (void)addMaterial:(NSString *)materialName Account:(float)account;
- (void)removeMaterial:(NSString *)materialName;
- (float)totalMaterialAccount;

+ (NSMutableArray *)getMaterialLib;//系統材料數據庫
+ (void)setMaterialLib:(NSMutableArray *)materialLib;
@end
