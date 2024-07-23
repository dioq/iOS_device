#import "FileUtil.h"

@implementation FileUtil

+(instancetype)sharedManager {
    static FileUtil *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
    });
    return staticInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}


-(void)copyAllItemSourcePath:(NSString *)sourcePath TargetPath:(NSString *)targetPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:sourcePath]) {
        NSLog(@"%d:%@ not exist!",__LINE__,sourcePath);
        return;
    }
    
    if (![fileManager fileExistsAtPath:targetPath]) {
        NSLog(@"%d:%@ not exist!",__LINE__,targetPath);
        return;
    }
    
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:sourcePath error:&error];
    if(error) {
        NSLog(@"%@:%@",sourcePath,[error localizedFailureReason]);
        return;
    }
    for (int i = 0; i < contents.count; i++) {
        NSString *filename = [contents objectAtIndex:i];
        NSString *current_source_path = [sourcePath stringByAppendingPathComponent:filename];
        NSString *current_target_path = [targetPath stringByAppendingPathComponent:filename];
        [self copySourcePath:current_source_path TargetPath:current_target_path];
    }
}

-(void)copyAllItemSourcePath:(NSString *)sourcePath TargetPath:(NSString *)targetPath Whitelist:(NSArray<NSString *> *)whiteArr {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:sourcePath]) {
        NSLog(@"%d:%@ not exist!",__LINE__,sourcePath);
        return;
    }
    
    if (![fileManager fileExistsAtPath:targetPath]) {
        NSLog(@"%d:%@ not exist!",__LINE__,targetPath);
        return;
    }
    
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:sourcePath error:&error];
    if(error) {
        NSLog(@"%@:%@",sourcePath,[error localizedFailureReason]);
        return;
    }
    for (int i = 0; i < contents.count; i++) {
        NSString *filename = [contents objectAtIndex:i];
        
        if ([filename isEqual:@"."] || [filename isEqual:@".."]) {
            continue;
        }
        
        if ([whiteArr containsObject:filename]) {
            continue;
        }
        
        NSString *current_source_path = [sourcePath stringByAppendingPathComponent:filename];
        NSString *current_target_path = [targetPath stringByAppendingPathComponent:filename];
        [self copySourcePath:current_source_path TargetPath:current_target_path];
    }
}

-(void)copyContentPath:(NSString *)sourcePath Path:(NSString *)targetPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:sourcePath]) {
        NSLog(@"%d:%@ not exist!",__LINE__,sourcePath);
        return;
    }
    
    if (![fileManager fileExistsAtPath:targetPath]) {
        NSLog(@"%d:%@ not exist!",__LINE__,targetPath);
        return;
    }
    
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:sourcePath error:&error];
    if(error) {
        NSLog(@"%@:%@",sourcePath,[error localizedFailureReason]);
        return;
    }
    
    BOOL isDirectory;
    for (int i = 0; i < contents.count; i++) {
        NSString *filename = [contents objectAtIndex:i];
        if ([filename isEqual:@"."] || [filename isEqual:@".."]) {
            continue;
        }
        
        if ([filename isEqualToString:@".com.apple.mobile_container_manager.metadata.plist"]) {
            continue;
        }
        
        NSString *current_source_path = [sourcePath stringByAppendingPathComponent:filename];
        NSString *current_target_path = [targetPath stringByAppendingPathComponent:filename];
        
        if ([fileManager fileExistsAtPath:current_target_path isDirectory:&isDirectory]) {
            if(isDirectory) { // 如果是目录 递归遍历所有子目录
                [self copyContentPath:current_source_path Path:current_target_path];
            }else {
                [self deleteFile:current_target_path];
                [self copySourcePath:current_source_path TargetPath:current_target_path];
            }
        }else {
            [self copySourcePath:current_source_path TargetPath:current_target_path];
        }
    }
}

-(BOOL)copySourcePath:(NSString *)sourcePath TargetPath:(NSString *)targetPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL suc = [fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error];
    if(error) {
        NSLog(@"%@ -> %@ : %@",sourcePath,targetPath,[error localizedFailureReason]);
    }
    return suc;
}

-(void)emptyDir:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSLog(@"%d:%@ not exist!",__LINE__,path);
        return;
    }
    
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if(error) {
        NSLog(@"%@:%@",path,[error localizedFailureReason]);
        return;
    }
    for (int i = 0; i < contents.count; i++) {
        NSString *filename = [contents objectAtIndex:i];
        
        if ([filename isEqual:@"."] || [filename isEqual:@".."]) {
            continue;
        }
        
        NSString *current_path = [path stringByAppendingPathComponent:filename];
        [self deleteFile:current_path];
    }
}

-(void)emptyDir:(NSString *)path Whitelist:(NSArray<NSString *> *)whiteArr {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSLog(@"%d:%@ not exist!",__LINE__,path);
        return;
    }
    
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if(error) {
        NSLog(@"%@:%@",path,[error localizedFailureReason]);
        return;
    }
    for (int i = 0; i < contents.count; i++) {
        NSString *filename = [contents objectAtIndex:i];
        
        if ([filename isEqual:@"."] || [filename isEqual:@".."]) {
            continue;
        }
        
        if ([whiteArr containsObject:filename]) {
            continue;
        }
        
        NSString *current_path = [path stringByAppendingPathComponent:filename];
        [self deleteFile:current_path];
    }
}

-(BOOL)deleteFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        return YES;
    }
    
    NSError *error;
    BOOL suc = [fileManager removeItemAtPath:path error:&error];
    if(error) {
        NSLog(@"%@:%@",path,[error localizedFailureReason]);
    }
    //    else {
    //        NSLog(@"%@ was deleted!", path);
    //    }
    return suc;
}

-(void)deleteRecursePath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if(error) {
        NSLog(@"%@:%@",path,[error localizedFailureReason]);
        return;
    }
    
    BOOL isDirectory;
    for (int i = 0; i < contents.count; i++) {
        NSString *filename = [contents objectAtIndex:i];
        
        if ([filename isEqual:@"."] || [filename isEqual:@".."]) {
            continue;
        }
        
        NSString *current_path = [path stringByAppendingPathComponent:filename];
        
        if ([fileManager fileExistsAtPath:current_path isDirectory:&isDirectory]) {
            if(isDirectory) { // 如果是目录 递归遍历所有子目录
                [self deleteRecursePath:current_path];
            }else {
                [self deleteFile:current_path];
            }
        }
    }
}

-(BOOL)createDir:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![fileManager fileExistsAtPath:path]) {
        NSDictionary *strAttrib = [NSDictionary dictionaryWithObjectsAndKeys:@"mobile",NSFileGroupOwnerAccountName,
                                   @"mobile",NSFileOwnerAccountName,nil];
        
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:strAttrib error:&error];
        
        if (error) {
            NSLog(@"%@:%@",path,[error localizedFailureReason]);
            return NO;
        }
    }
    return YES;
}

-(BOOL)moveSourcePath:(NSString *)sourcePath TargetPath:(NSString *)targetPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL suc = [fileManager moveItemAtPath:sourcePath toPath:targetPath error:&error];
    if(error) {
        NSLog(@"%@",[error localizedFailureReason]);
    }
    return suc;
}

-(unsigned long long)fileSizeAtPath:(NSString *)path {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
}

-(unsigned long long)folderSizeAtPath:(NSString*) folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    unsigned long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

-(NSString *)convertSzie:(unsigned long long)size {
    NSString *fileSize = @"";
    if (size < 1024.0) {
        fileSize =  [NSString stringWithFormat:@"%.2fB",size * 1.0];
    }else if (size >= 1024.0 && size < (1024.0*1024.0)){
        fileSize =   [NSString stringWithFormat:@"%.2fKB",size/1024.0];
    }if (size >= (1024.0*1024.0) && size < (1024.0*1024.0*1024.0)) {
        fileSize =   [NSString stringWithFormat:@"%.2fMB", size/(1024.0*1024.0)];
    }else if(size >= (1024.0*1024.0*1024.0)) {
        fileSize =   [NSString stringWithFormat:@"%.2fGB", size/(1024.0*1024.0*1024.0)];
    }
    return fileSize;
}

@end
