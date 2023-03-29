//
//  DeviceUtil.h
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2022/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceUtil : NSObject

// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName;
// 获取 mac 地址
+ (NSString *)getMacAddress;

// 获取 ip 地址
+ (NSString *)getDeviceIPAddresses;
+ (NSString *)getIpAddressWIFI;
+ (NSString *)getIpAddressCell;

// CPU总数目
+ (NSUInteger)getCPUCount;
// 已使用的CPU比例
+ (float)getCPUUsage;
// 获取每个cpu的使用比例
+ (NSArray *)getPerCPUUsage;
// CPU 频率
+ (NSUInteger)getCPUFrequency;


/** 获取本 App 所占磁盘空间 */
+ (NSString *)getApplicationSize;
/** 获取磁盘总空间 */
+ (int64_t)getTotalDiskSpace;
/** 获取未使用的磁盘空间 */
+ (int64_t)getFreeDiskSpace;
/** 获取已使用的磁盘空间 */
+ (int64_t)getUsedDiskSpace;

/** 获取总内存空间 */
+ (int64_t)getTotalMemory;
/** 获取活跃的内存空间 */
+ (int64_t)getActiveMemory;
/** 获取不活跃的内存空间 */
+ (int64_t)getInActiveMemory;
/** 获取空闲的内存空间 */
+ (int64_t)getFreeMemory;
/** 获取正在使用的内存空间 */
+ (int64_t)getUsedMemory;
/** 获取存放内核的内存空间 */
+ (int64_t)getWiredMemory;
/** 获取可释放的内存空间 */
+ (int64_t)getPurgableMemory;

// 获取网络运营商
+(NSString *)obtainOperator;

// 获取idfa
+(NSString *)getIDFA;

@end

NS_ASSUME_NONNULL_END
