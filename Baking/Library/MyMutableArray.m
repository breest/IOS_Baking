//
//  MyMutableArray.m
//  Baking
//
//  Created by Chang Wei on 15/2/13.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyArray.h"
#import "MyMutableArray.h"

@implementation NSMutableArray(ArrayBoost)

- (void)addObject_CC:(id)anObject {
    if ([self containsObject:anObject]) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                           message:@"對象已存在，重複添加！"
                                          delegate:nil
                                 cancelButtonTitle:@"確定"
                                 otherButtonTitles:nil];
        [alert show];
    }else{
        [self addObject:anObject];
    }
}

- (BOOL)addArray_CC:(id)newArray uniqueColumn:(NSInteger)indexColumn {
    for (int i = 0; i < self.count; i++) {
        if ([[[self objectAtIndex:i] objectAtIndex:indexColumn] isEqual:[newArray objectAtIndex:indexColumn]]) {
            return FALSE;
        }
    }
    [self addObject:newArray];
    return TRUE;
}
/*
- (BOOL)allObjectsIsArray_CC {
    id object;
    for (int i = 0; i < self.count; i++) {
        object = [self objectAtIndex:i];
        if (![object isKindOfClass:[NSArray class]]) {
            return FALSE;
        }
    }
    return TRUE;
}*/

- (void)appendArray_CC:(NSArray *)newArray {
    for (int i = 0; i < newArray.count; i++) {
        [self addObject:[newArray objectAtIndex:i]];
    }
}
- (NSArray *)arrayAddColumn_CC:(NSUInteger)indexColumn defaultValue:(id)defaultObject {
    NSMutableArray *arrayOldRow, *arrayNewRow, *returnArray;
    if (indexColumn > [self columns_CC]) {
        indexColumn = [self columns_CC];
    }
    returnArray = [NSMutableArray new];
    for (int i = 0; i < self.count; i++) {
        arrayOldRow = [self objectAtIndex:i];
        arrayNewRow = [NSMutableArray new];
        for (int j = 0; j < arrayOldRow.count; j++) {
            if (j == indexColumn) {
                [arrayNewRow addObject:defaultObject];
            }
            [arrayNewRow addObject:[arrayOldRow objectAtIndex:j]];
        }
        [returnArray addObject:arrayNewRow];
    }
    return returnArray;
}
/*
- (NSInteger)columns_CC {
    if (self.count > 0 && [self allObjectsIsArray_CC]) {
        return ((NSArray *)[self objectAtIndex:0]).count;
    }
    return -1;
}*/
/*
- (NSArray *)getSubArrayWithColumn_CC:(NSInteger)index {
    //從二維數組某列得到新數組
    NSMutableArray *returnArray;
    returnArray = [NSMutableArray new];
    for (int i = 0; i < self.count; i++) {
        [returnArray addObject:[((NSArray *)[self objectAtIndex:i]) objectAtIndex:index]];
    }
    return (NSArray *)returnArray;
}

- (NSArray *)getSubArrayWithArray_CC:(NSArray *)indexArray {
    //從二維數組若干列得到新數組，(列集合由數組indexArray給出)
    NSMutableArray *returnArray, *cellArray;
    NSInteger index;
    returnArray = [NSMutableArray new];
    for (int i = 0; i < self.count; i++) {
        cellArray = [NSMutableArray new];
        for (int j= 0; j < indexArray.count; j++) {
            index = [[indexArray objectAtIndex:j] integerValue];
            [cellArray addObject:[((NSArray *)[self objectAtIndex:i]) objectAtIndex:index]];
        }
        [returnArray addObject:cellArray];
    }
    return (NSArray *)returnArray;
}

- (NSArray *)getRowsWithKey_CC:(id)Object inColumn:(NSInteger)index {
    //通過指定列的關鍵詞獲得新數組
    NSMutableArray *returnArray, *cellArray;
    returnArray = [NSMutableArray new];
    for (int i = 0; i < self.count; i++) {
        cellArray = [self objectAtIndex:i];
        if ([Object isEqual:[cellArray objectAtIndex:index]]) {
            [returnArray addObject:cellArray];
        }
    }
    return (NSArray *)returnArray;
}*/

- (void)removeRowWithKey_CC:(id)Object inColumn:(NSInteger)index {
    //通過指定列關鍵詞刪除一行
    NSMutableArray *cellArray;
    for (int i = 0; i < self.count; i++) {
        cellArray = [self objectAtIndex:i];
        if ([Object isEqual:[cellArray objectAtIndex:index]]) {
            [self removeObjectAtIndex:i];
            return;
        }
    }
}
/*
- (NSArray *)sortWithDictionaryArray_CC:(NSArray *)dictionaryArray {
    NSArray *returnArray;
    returnArray = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result;
        NSInteger index1, index2;
        index1 = index2 = dictionaryArray.count;
        for (int i = 0; i < dictionaryArray.count; i++) {
            if ([obj1 isEqual:[dictionaryArray objectAtIndex:i]]) {
                index1 = i;
                break;
            }
        }
        for (int i = 0; i < dictionaryArray.count; i++) {
            if ([obj2 isEqual:[dictionaryArray objectAtIndex:i]]) {
                index2 = i;
                break;
            }
        }
        result = [[NSNumber numberWithInteger:index1] compare:[NSNumber numberWithInteger:index2]];//
        return result;
    }];
    return returnArray;
}*/

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

@end