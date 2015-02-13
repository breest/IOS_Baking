//
//  MyArray.m
//  Baking
//
//  Created by Chang Wei on 15/2/7.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyArray.h"

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

- (void)appendArray_CC:(NSArray *)newArray {
    for (int i = 0; i < newArray.count; i++) {
        [self addObject:[newArray objectAtIndex:i]];
    }
}

- (BOOL)allObjectsIsArray_CC {
    id object;
    for (int i = 0; i < self.count; i++) {
        object = [self objectAtIndex:i];
        if (![object isKindOfClass:[NSArray class]]) {
            return FALSE;
        }
    }
    return TRUE;
}

- (NSInteger)columns_CC {
    if (self.count > 0 && [self allObjectsIsArray_CC]) {
        return ((NSArray *)[self objectAtIndex:0]).count;
    }
    return -1;
}
/*
- (NSArray *)getArrayWithIndex:(NSArray *)array indexObject:(id)index indexColumn:(int)col {
    NSMutableArray *arrayRow, *arrayCell, *arrayTable = [NSMutableArray new];
    for (int i=0; i<array.count; i++) {
        arrayRow = [array objectAtIndex:i];
        if (col >= arrayRow.count) {
            col = 0;
        }
        if ([[arrayRow objectAtIndex:col] isEqual:index]) {
            NSMutableArray *arrayTemp = [NSMutableArray new];
            for (int j=0; j<arrayRow.count; j++) {
                if (j==col) {
                    continue;
                }
                if (arrayRow.count == 2) {
                    arrayCell = [NSMutableArray arrayWithObjects:index, [arrayRow objectAtIndex:j], nil];
                }else{
                    [arrayTemp addObject:[arrayRow objectAtIndex:j]];
                }
            }
            if (arrayRow.count > 2) {
                arrayCell = [NSMutableArray arrayWithObjects:index, arrayTemp, nil];
            }
            [arrayTable addObject:arrayCell];
        }
    }
    return arrayTable;
}

- (NSDictionary *)getDictionaryIncludeArray:(NSArray *)array includeArray:(NSArray *)includeArray indexColumn:(int)col {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //= [NSMutableArray arrayWithObjects:nil];
    NSArray *arrayTemp;
    NSMutableArray *arrayTemp2;
    for (int i = 0; i < includeArray.count; i++) {
        arrayTemp = [self getArrayWithIndex:array indexObject:[includeArray objectAtIndex:i] indexColumn:col];
        arrayTemp2 = [NSMutableArray arrayWithObjects:nil];
        for (int j=0; j<arrayTemp.count; j++) {
            [arrayTemp2 addObject:[[arrayTemp objectAtIndex:j] objectAtIndex:1]];
        }
        [dict setObject:arrayTemp2 forKey:[includeArray objectAtIndex:i]];
    }
    return dict;
}

- (NSDictionary *)getDictionaryWithUniqueColumnValue:(NSArray *)array indexColumn:(int)col {
    NSDictionary *dict;
    NSMutableArray *arrayKey = [NSMutableArray arrayWithObjects:nil];
    id currentIndex;
    
    for (int i=0; i<array.count; i++) {
        currentIndex = [[array objectAtIndex:i] objectAtIndex:col];
        if (![self objectInArray:arrayKey object:currentIndex]) {
            [arrayKey addObject:currentIndex];
        }
    }
    dict = [self getDictionaryIncludeArray:array includeArray:arrayKey indexColumn:col];
    return dict;
}
*/
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
}

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
}
/*
//自定义排序方法
-(NSComparisonResult)compareArray:(id)object dictionaryArray:(NSArray *)dictionaryArray{
    //默认按年龄排序
    NSComparisonResult result = [[NSNumber numberWithInt:person.age] compare:[NSNumber numberWithInt:self.age]];//注意:基本数据类型要进行数据转换
    //如果年龄一样，就按照名字排序
    if (result == NSOrderedSame) {
        result = [self.name compare:person.name];
    }
    return result;
}
*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

@end
