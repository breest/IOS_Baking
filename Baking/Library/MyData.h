//
//  MyData.h
//  Baking
//
//  Created by Chang Wei on 15/2/8.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MyData : NSObject

+ (void)addRecordToFile:(NSString *)filename tableName:(NSString *)table InsertArray:(NSArray *)valueArray;
+ (void)addRecordToFile:(NSString *)filename tableName:(NSString *)table InsertString:(NSString *)valueString;
+ (void)replaceRecordToFile:(NSString *)filename tableName:(NSString *)table InsertArray:(NSArray *)valueArray;
+ (void)replaceRecordToFile:(NSString *)filename tableName:(NSString *)table InsertString:(NSString *)valueString;
+ (NSString *)dataFilePath:(NSString *)fileName;
+ (void)deleteRecordFromFile:(NSString *)filename tableName:(NSString *)table where:(NSString *)whereString;
+ (NSArray *)getArrayFormTableD:(sqlite3 *)database tableName:(NSString *)tableName;
+ (NSArray *)getArrayFormTableF:(NSString *)dataFile tableName:(NSString *)tableName;
+ (NSArray *)getArrayWithIndex:(NSArray *)array indexColumn:(int)col;
+ (NSArray *)getArrayWithIndex:(NSArray *)array indexObject:(id)index indexColumn:(int)col;
+ (NSString *)getDataPath;
+ (NSDictionary *)getDictionaryIncludeArray:(NSArray *)array includeArray:(NSArray *)includeArray indexColumn:(int)col;
+ (NSDictionary *)getDictionaryWithUniqueColumnValue:(NSArray *)array indexColumn:(int)col;
+ (BOOL) objectInArray:(NSArray *)array object:(id)object;+ (void)updateRecordToFile:(NSString *)filename tableName:(NSString *)table InsertString:(NSString *)valueString where:(NSString *)whereString;

@end
