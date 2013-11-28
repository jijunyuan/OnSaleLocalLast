//
//  DataBase.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-13.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DataBase.h"

@interface DataBase()
@end

@implementation DataBase
+(FMDatabase *)ShareDataBase
{
    NSString * doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * dbPath = [doucumentPath stringByAppendingPathComponent:@"OnSaleLocal.db"];
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
//    NSString * createTB = @"create table orderMenu(proID int,Menuid int,proName nvarchar(50),price double,proImage varchar(50),number int)";
//    BOOL result = [db executeUpdate:createTB];
//    if (result)
//    {
//        NSLog(@"创建表orderMenu成功");
//    }
    [db close];
    return db;
}
#pragma mark - 清楚orderMenu
+(void)clearOrderMenu
{
//    FMDatabase * db = [DataBase ShareDataBase];
//    [db open];
//    NSString * deleteSql = @"delete from orderMenu where 1=1";
//    BOOL result = [db executeUpdate:deleteSql];
//    if (result)
//    {
//        NSLog(@"清除orderMenu成功");
//    }
//    else
//    {
//        NSLog(@"清除orderMenu失败");
//    }
//    [db close];
}
@end
