//
//  MyData.m
//  Baking
//
//  Created by Chang Wei on 15/2/8.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyData.h"

@implementation MyData

+ (void)addRecord:(sqlite3 *)database tableName:(NSString *)table InsertArray:(NSArray *)valueArray{
    NSString *valueString;
    
    valueString = [NSString stringWithFormat:@"VALUES ('%@'", [valueArray objectAtIndex:0]];
    for (int i=1; i<valueArray.count; i++) {
        valueString = [NSString stringWithFormat:@"%@ , '%@'", valueString, [valueArray objectAtIndex:i]];
    }
    valueString = [NSString stringWithFormat:@"%@)", valueString];
    [self addRecord:database tableName:table InsertString:valueString];
}

+ (void)addRecord:(sqlite3 *)database tableName:(NSString *)table InsertString:(NSString *)valueString{
    NSString *sqlString;
    
    //sqlString = [[NSString alloc] initWithFormat:@"INSERT INTO %@ VALUES(%@) WHERE %@", table, valueString, condition];
    sqlString = [[NSString alloc] initWithFormat:@"INSERT INTO %@ %@", table, valueString];
    [self sqlexec:database sqlString:sqlString];
}

+ (void)addRecordToFile:(NSString *)filename tableName:(NSString *)table InsertArray:(NSArray *)valueArray{
    sqlite3 *database;
    
    if (sqlite3_open([filename UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    [self addRecord:database tableName:table InsertArray:valueArray];
    sqlite3_close(database);
}

+ (void)addRecordToFile:(NSString *)filename tableName:(NSString *)table InsertString:(NSString *)valueString{
    sqlite3 *database;
    
    if (sqlite3_open([filename UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    [self addRecord:database tableName:table InsertString:valueString];
    sqlite3_close(database);
}

+ (NSString *)dataFilePath:(NSString *)fileName {
    NSString *dataFile = [[self getDataPath] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFile]) {
        NSLog(@"%@文件已经存在了", fileName);
    }else {
        NSString *dataFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        NSLog(@"dataFolderPath=%@",dataFolderPath);
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:dataFolderPath];
        NSLog(@"mainBundleFile==%@",mainBundleFile);
        [[NSFileManager defaultManager] createFileAtPath:dataFile contents:mainBundleFile attributes:nil];
    }
    return dataFile;
}

+ (void)deleteRecord:(sqlite3 *)database tableName:(NSString *)table where:(NSString *)whereString{
    NSString *sqlString;
    
    //sqlString = [[NSString alloc] initWithFormat:@"INSERT INTO %@ VALUES(%@) WHERE %@", table, valueString, condition];
    sqlString = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE %@", table, whereString];
    [self sqlexec:database sqlString:sqlString];
}

+ (void)deleteRecordFromFile:(NSString *)filename tableName:(NSString *)table where:(NSString *)whereString{
    sqlite3 *database;
    
    if (sqlite3_open([filename UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    [self deleteRecord:database tableName:table where:whereString];
    sqlite3_close(database);
}

+ (NSArray *)getArrayFormStmt:(sqlite3_stmt *)stmt columnCount:(int)cols {
    NSMutableArray *arrayTable = [NSMutableArray arrayWithObjects:nil];
    char *value;
    NSString *val;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:nil];
        for (int i=0; i<cols; i++) {
            value = (char *)sqlite3_column_text(stmt, i);
            if (value != nil) {
                val = [[NSString alloc] initWithUTF8String:value];
            }else{
                val = @"";
            }
            
            if (cols == 1) {
                [arrayTable addObject:val];
            }else{
                [arrayTemp addObject:val];
            }
        }
        if (cols > 1) {
            [arrayTable addObject:arrayTemp];
        }
    }
    return (NSArray *)arrayTable;
}

+ (NSArray *)getArrayFormTableD:(sqlite3 *)database tableName:(NSString *)tableName {
    NSArray *arrayTable;
    
    if (![self isExistTable:database tableName:tableName]) {
        return arrayTable;
    }
    int cols = 0;
    NSString *sqlQuery;
    sqlite3_stmt *statement;
    sqlQuery = [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            cols++;
        }
    }
    sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM %@",tableName];
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        arrayTable = [self getArrayFormStmt:statement columnCount:cols];
        sqlite3_finalize(statement);
    }
    
    return arrayTable;
}

+ (NSArray *)getArrayFormTableF:(NSString *)dataFile tableName:(NSString *)tableName {
    NSArray *arrayTable;
    sqlite3 *database;
    
    if (sqlite3_open([dataFile UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    arrayTable = [self getArrayFormTableD:database tableName:tableName];
    sqlite3_close(database);
    return arrayTable;
}

+ (NSArray *)getArrayWithIndex:(NSArray *)array indexColumn:(int)col {
    NSMutableArray *arrayTable = [NSMutableArray arrayWithObjects:nil];
    for (int i=0; i<array.count; i++) {
        [arrayTable addObject:[[array objectAtIndex:i] objectAtIndex:col]];
    }
    return arrayTable;
}

+ (NSArray *)getArrayWithIndex:(NSArray *)array indexObject:(id)index indexColumn:(int)col {
    NSMutableArray *arrayRow, *arrayCell, *arrayTable = [NSMutableArray arrayWithObjects:nil];
    for (int i=0; i<array.count; i++) {
        arrayRow = [array objectAtIndex:i];
        if (col >= arrayRow.count) {
            col = 0;
        }
        if ([[arrayRow objectAtIndex:col] isEqual:index]) {
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:nil];
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

+ (NSString *)getDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Data"];
    NSFileManager* fm=[NSFileManager defaultManager];// 文件管理器
    // 创建目录
    if (![fm fileExistsAtPath:dataPath]) {
        NSLog(@"there is no Directory: %@",dataPath);
        [fm createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dataPath;
}

+ (NSDictionary *)getDictionaryIncludeArray:(NSArray *)array includeArray:(NSArray *)includeArray indexColumn:(int)col {
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
        //[arrayTable addObject:@[[includeArray objectAtIndex:i],arrayTemp2]];
        [dict setObject:arrayTemp2 forKey:[includeArray objectAtIndex:i]];
    }
    return dict;
}

+ (NSDictionary *)getDictionaryWithUniqueColumnValue:(NSArray *)array indexColumn:(int)col {
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

+ (BOOL)isExistTable:(sqlite3 *)database tableName:(NSString *)table {
    NSString *sqlQuery;
    sqlite3_stmt *statement;
    sqlQuery = [[NSString alloc] initWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type=\"table\" AND name=\"%@\"",table];
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            if (sqlite3_column_int(statement, 0) > 0) {
                sqlite3_finalize(statement);
                return YES;
            }
        }
        sqlite3_finalize(statement);
        return NO;
    }
    return NO;
}

+ (BOOL) objectInArray:(NSArray *)array object:(id)object {
    BOOL bInArray = FALSE;
    for (int i=0; i<array.count; i++) {
        if ([[array objectAtIndex:i] isEqual:object]) {
            bInArray = TRUE;
            break;
        }
    }
    return bInArray;
}

+ (void)sqlexec:(sqlite3 *)database sqlString:(NSString *)sqlString{
    char *errorMsg;
    
    if (sqlite3_exec(database, [sqlString UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
    }
}

+ (void)updateRecord:(sqlite3 *)database tableName:(NSString *)table InsertString:(NSString *)valueString where:(NSString *)whereString{
    NSString *sqlString;

    sqlString = [[NSString alloc] initWithFormat:@"UPDATE %@ SET %@ WHERE %@", table, valueString, whereString];
    [self sqlexec:database sqlString:sqlString];
}

+ (void)updateRecordToFile:(NSString *)filename tableName:(NSString *)table InsertString:(NSString *)valueString where:(NSString *)whereString {
    sqlite3 *database;
    
    if (sqlite3_open([filename UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    [self updateRecord:database tableName:table InsertString:valueString where:whereString];
    sqlite3_close(database);
}

@end
