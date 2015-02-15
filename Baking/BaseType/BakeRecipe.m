//
//  BakeRecipe.m
//  Baking
//
//  Created by Chang Wei on 15/2/14.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "BakeRecipe.h"

static NSMutableArray *MaterialLib;//系統材料數據庫

@implementation BakeRecipe

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        _recipeMaterials = [NSMutableArray new];
    }
    return self;
}

+ (NSMutableArray *)getMaterialLib {
    return MaterialLib;
}

+ (void)setMaterialLib:(NSMutableArray *)materialLib {
    MaterialLib = materialLib;
}

- (NSUInteger)materialCount {
    if (_recipeMaterials == nil) {
        return 0;
    }
    return _recipeMaterials.count;
}

- (BOOL)allPriceExist {
    BakeMaterial *material;
    if (MaterialLib != nil) {
        for (int i=0; i<MaterialLib.count; i++) {
            material = [MaterialLib objectAtIndex:i];
            if (material.price < 0) {
                return FALSE;
            }
        }
    }
    return TRUE;
}

- (BOOL)allCalorieExist {
    BakeMaterial *material;
    if (MaterialLib != nil) {
        for (int i=0; i<MaterialLib.count; i++) {
            material = [MaterialLib objectAtIndex:i];
            if (material.calorie < 0) {
                return FALSE;
            }
        }
    }
    return TRUE;
}

- (void)addMaterial:(NSString *)materialName Account:(float)account {
    [self removeMaterial:materialName];
    [_recipeMaterials addObject:@[materialName, @(account)]];
}

- (void)removeMaterial:(NSString *)materialName {
    NSMutableArray *cell;
    if (_recipeMaterials != nil) {
        for (int i=0; i<_recipeMaterials.count; i++) {
            cell = [_recipeMaterials objectAtIndex:i];
            if ([materialName isEqualToString:[cell objectAtIndex:0]]) {
                [_recipeMaterials removeObjectAtIndex:i];
                return;
            }
        }
    }
}

- (float)totalMaterialAccount {
    NSMutableArray *cell;
    NSUInteger total = 0;
    if (_recipeMaterials != nil) {
        for (int i=0; i<_recipeMaterials.count; i++) {
            cell = [_recipeMaterials objectAtIndex:i];
            total += [[cell objectAtIndex:1] floatValue];
        }
    }
    return total;
}

@end
