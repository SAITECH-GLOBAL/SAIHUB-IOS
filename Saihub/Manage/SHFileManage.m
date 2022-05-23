//
//  SHFileManage.m
//  NewExchange
//
//  Created by 周松 on 2021/11/22.
//  

#import "SHFileManage.h"

@implementation SHFileManage

// 把对象归档存到沙盒里
+ (void)saveArchiveObject:(id)object byFileName:(NSString *)fileName {
    NSString *path  = [self appendFilePath:fileName];
    path = [path stringByAppendingString:@".archive"];
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:YES error:&error];
    [data writeToFile:path atomically:YES];
}

// 通过文件名从沙盒中找到归档的对象
+ (id)getArchiveObjectByFileName:(NSString*)fileName {
    NSString *path  = [self appendFilePath:fileName];
    path = [path stringByAppendingString:@".archive"];
    NSData * unData = [NSData dataWithContentsOfFile:path];
    NSError * error;
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[SHBaseModel class] fromData:unData error:&error];
}

// 根据文件名删除沙盒中的文件
+ (void)removeArchiveObjectByFileName:(NSString *)fileName {
    NSString *path  = [self appendFilePath:fileName];
    path = [path stringByAppendingString:@".archive"];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark - Preferences
// 存储用户偏好设置
+ (void)savePreferencesData:(id)data forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 读取用户偏好设置
+ (id)readPreferencesDataForKey:(NSString *)key {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    return obj;
}

// 删除用户偏好设置
+ (void)removePreferencesDataForkey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

// 拼接文件路径
+ (NSString *)appendFilePath:(NSString *)fileName {
    
    // 1. 沙盒缓存路径
    NSString *cachesPath = [self documentsPath];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",cachesPath,fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return filePath;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory {
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSString *)documentsPath {
    return [self pathForDirectory:NSDocumentDirectory];
}

+ (NSString *)getFilePathForDirectory:(NSSearchPathDirectory)directory fileName:(NSString *)fileName {
    NSString *directoryPath = [self pathForDirectory:directory];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (void)removeFileWithFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
       BOOL isSu = [fileManager removeItemAtPath:filePath error:nil];
        if (!isSu) {
            NSLog(@"删除文件失败%@",filePath);
        } else {
            NSLog(@"删除成功");
        }
    } else {
        NSLog(@"删除失败,无法找到文件%@",filePath);
    }
}

///根据url获取文件名
+ (NSString *)displayNameAtPath:(NSString *)filePath {
   return [[NSFileManager defaultManager]displayNameAtPath:filePath];
}

+ (void)creatFloerWithPath:(NSString *)path {
    NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), path];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    NSLog(@"创建文件夹 = %d -- %d",isDir,existed);
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

+ (NSString *)loadLocalResourceName:(NSString *)resourceName {
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:@""];
    return [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}


@end
