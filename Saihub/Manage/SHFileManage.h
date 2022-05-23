//
//  SHFileManage.h
//  NewExchange
//
//  Created by 周松 on 2021/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHFileManage : NSObject

/**
 数据归档 数据模型需实现NSCopying协议,直接存储对象
 @param object 要存储的对象
 @param fileName 路径
 */
+ (void)saveArchiveObject:(id)object byFileName:(NSString *)fileName;

/**
 数据解档
 
 @param fileName 路径
 @return 返回对象
 */
+ (id)getArchiveObjectByFileName:(NSString*)fileName;

/**
 删除归档数据
 
 @param fileName 路径
 */
+ (void)removeArchiveObjectByFileName:(NSString *)fileName;

/**
 *  存储用户偏好设置 到 Preferences
 */
+ (void)savePreferencesData:(id)data forKey:(NSString*)key;

/**
 *  读取用户偏好设置
 */
+(id)readPreferencesDataForKey:(NSString*)key;

/**
 *  删除用户偏好设置
 */
+(void)removePreferencesDataForkey:(NSString*)key;


/**
 删除文件

 @param filePath 路径
 */
+ (void)removeFileWithFilePath:(NSString *)filePath;


/**
 根据传入的文件名和NSSearchPathDirectory获取文件路径

 @param directory NSSearchPathDirectory
 @param fileName 文件名(如果文件是放在directory子文件中,还要将子文件夹路径带上)
 @return 文件路径
 */
+ (NSString *)getFilePathForDirectory:(NSSearchPathDirectory)directory fileName:(NSString *)fileName;

/**
 获取url的文件名

 @param filePath 路径
 */
+ (NSString *)displayNameAtPath:(NSString *)filePath;

// 创建文件夹
+ (void)creatFloerWithPath:(NSString *)path;

/// 加载本地文件内容
+ (NSString *)loadLocalResourceName:(NSString *)resourceName;

/// 拼接文件路径 NSDocumentDirectory
+ (NSString *)appendFilePath:(NSString *)fileName;


@end

NS_ASSUME_NONNULL_END
