#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileUtil : NSObject

+(instancetype)sharedManager;

-(void)copyAllItemSourcePath:(NSString * _Nonnull)sourcePath TargetPath:(NSString * _Nonnull)targetPath;
-(void)copyAllItemSourcePath:(NSString * _Nonnull)sourcePath TargetPath:(NSString * _Nonnull)targetPath Whitelist:(NSArray<NSString *> * _Nonnull)whiteArr;
// 将 A目录 里的所有内容 复制 到 B目录里,如果 B 里有同名目录 只复制内容
-(void)copyContentPath:(NSString * _Nonnull)sourcePath Path:(NSString * _Nonnull)targetPath;
-(BOOL)copySourcePath:(NSString * _Nonnull)sourcePath TargetPath:(NSString * _Nonnull)targetPath;

// 清空目录
-(void)emptyDir:(NSString * _Nonnull)path;
-(void)emptyDir:(NSString * _Nonnull)path Whitelist:(NSArray<NSString *> *)whiteArr;

-(BOOL)deleteFile:(NSString * _Nonnull)path;

-(void)deleteRecursePath:(NSString * _Nonnull)path;

-(BOOL)createDir:(NSString * _Nonnull)path;

-(BOOL)moveSourcePath:(NSString * _Nonnull)sourcePath TargetPath:(NSString * _Nonnull)targetPath;

// 单个文件的大小
-(unsigned long long)fileSizeAtPath:(NSString *)path;
// 遍历文件夹获得文件夹大小
-(unsigned long long)folderSizeAtPath:(NSString *)folderPath;
// 文件大小 转成可读形式
-(NSString *)convertSzie:(unsigned long long)size;

@end

NS_ASSUME_NONNULL_END
