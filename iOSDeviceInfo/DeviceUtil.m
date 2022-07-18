//
//  DeviceUtil.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2022/7/15.
//

#import "DeviceUtil.h"
#import "sys/utsname.h"
#import <UIKit/UIKit.h>

// 下面是获取mac地址需要导入的头文件
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

// 下面是获取ip需要的头文件
#include <ifaddrs.h>
#include <sys/socket.h> // Per msqr
#import <sys/ioctl.h>
#include <net/if.h>
#import <arpa/inet.h>

// 获取CPU信息所需要引入的头文件
#include <mach/mach.h>

// 网络运营商
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

// 获取 IDFA
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/ATTrackingManager.h>

@implementation DeviceUtil

// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    NSLog(@"sysname:%@",sysname);
    NSString *nodename = [NSString stringWithCString:systemInfo. nodename encoding:NSUTF8StringEncoding];
    NSLog(@"nodename:%@",nodename);
    NSString *release = [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding];
    NSLog(@"release:%@",release);
    NSString *version = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    NSLog(@"version:%@",version);
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"machine:%@",machine);

    if ([machine isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([machine isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([machine isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([machine isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([machine isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([machine isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([machine isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([machine isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([machine isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([machine isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([machine isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([machine isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([machine isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([machine isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([machine isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([machine isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([machine isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([machine isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([machine isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([machine isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([machine isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([machine isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([machine isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([machine isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([machine isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    if ([machine isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([machine isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([machine isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([machine isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([machine isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([machine isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([machine isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([machine isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
    if ([machine isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([machine isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([machine isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([machine isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";

    if ([machine isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([machine isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([machine isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([machine isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([machine isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";

    if ([machine isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([machine isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([machine isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([machine isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([machine isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([machine isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([machine isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([machine isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([machine isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([machine isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([machine isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([machine isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([machine isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([machine isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([machine isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([machine isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([machine isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([machine isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([machine isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([machine isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([machine isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([machine isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([machine isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([machine isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([machine isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([machine isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([machine isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([machine isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([machine isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([machine isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([machine isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([machine isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([machine isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([machine isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([machine isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([machine isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([machine isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    if ([machine isEqualToString:@"iPad7,5"])     return @"iPad 6th generation";
    if ([machine isEqualToString:@"iPad7,6"])     return @"iPad 6th generation";
    if ([machine isEqualToString:@"iPad8,1"])     return @"iPad Pro (11-inch)";
    if ([machine isEqualToString:@"iPad8,2"])     return @"iPad Pro (11-inch)";
    if ([machine isEqualToString:@"iPad8,3"])     return @"iPad Pro (11-inch)";
    if ([machine isEqualToString:@"iPad8,4"])     return @"iPad Pro (11-inch)";
    if ([machine isEqualToString:@"iPad8,5"])     return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([machine isEqualToString:@"iPad8,6"])     return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([machine isEqualToString:@"iPad8,7"])     return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([machine isEqualToString:@"iPad8,8"])     return @"iPad Pro (12.9-inch) (3rd generation)";

   if ([machine isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
   if ([machine isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
   if ([machine isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
   if ([machine isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";

    if ([machine isEqualToString:@"i386"])         return @"Simulator";
    if ([machine isEqualToString:@"x86_64"])       return @"Simulator";

    return machine;
}

+ (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);

    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return [outstring uppercaseString];
}

+ (NSString *)getDeviceIPAddresses {

    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    NSMutableArray *ips = [NSMutableArray array];

    int BUFFERSIZE = 4096;

    struct ifconf ifc;

    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;

    struct ifreq *ifr, ifrcopy;

    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;

    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){

        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){

            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);

            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }

            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;

            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);

            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;

            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }

    close(sockfd);
    NSString *deviceIP = @"";

    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}


// CPU总数目
+ (NSUInteger)getCPUCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}
// 已使用的CPU比例
+ (float)getCPUUsage {
    float cpu = 0;
    NSArray *cpus = [self getPerCPUUsage];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}
// 获取每个cpu的使用比例
+ (NSArray *)getPerCPUUsage {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;

    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;

    _cpuUsageLock = [[NSLock alloc] init];

    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];

        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }

        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}

// CPU 频率
+ (NSUInteger)getCPUFrequency {
    return [self _getSystemInfo:HW_CPU_FREQ];
}

+ (NSUInteger)_getSystemInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}


// IP
+ (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address ? address : @"该设备不存在该ip地址";
}

+ (NSString *)getIpAddressWIFI {
    return [self ipAddressWithIfaName:@"en0"];
}

+ (NSString *)getIpAddressCell {
    return [self ipAddressWithIfaName:@"pdp_ip0"];
}



#pragma mark - Disk
+ (NSString *)getApplicationSize {
    unsigned long long documentSize   =  [self _getSizeOfFolder:[self _getDocumentPath]];
    unsigned long long librarySize   =  [self _getSizeOfFolder:[self _getLibraryPath]];
    unsigned long long cacheSize =  [self _getSizeOfFolder:[self _getCachePath]];
    
    unsigned long long total = documentSize + librarySize + cacheSize;
    
    NSString *applicationSize = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    return applicationSize;
}

+ (int64_t)getTotalDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

+ (int64_t)getFreeDiskSpace {
    
//    if (@available(iOS 11.0, *)) {
//        NSError *error = nil;
//        NSURL *testURL = [NSURL URLWithString:NSHomeDirectory()];
//
//        NSDictionary *dict = [testURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:&error];
//
//        return (int64_t)dict[NSURLVolumeAvailableCapacityForImportantUsageKey];
//
//
//    } else {
        NSError *error = nil;
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
        if (error) return -1;
        int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
        if (space < 0) space = -1;
        return space;
//    }
    
}

+ (int64_t)getUsedDiskSpace {
    int64_t totalDisk = [self getTotalDiskSpace];
    int64_t freeDisk = [self getFreeDiskSpace];
    if (totalDisk < 0 || freeDisk < 0) return -1;
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = -1;
    return usedDisk;
}

#pragma mark - Memory
+ (int64_t)getTotalMemory {
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return totalMemory;
}

+ (int64_t)getActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

+ (int64_t)getInActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

+ (int64_t)getFreeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

+ (int64_t)getUsedMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

+ (int64_t)getWiredMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

+ (int64_t)getPurgableMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}

#pragma mark - Private Method
+ (NSString *)_getDeviceColorWithKey:(NSString *)key {
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if ([device respondsToSelector:selector]) {
        // 消除警告“performSelector may cause a leak because its selector is unknown”
        IMP imp = [device methodForSelector:selector];
        NSString * (*func)(id, SEL, NSString *) = (void *)imp;
        
        return func(device, selector, key);
    }
    return @"unKnown";
}

+ (NSString *)_getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

+ (NSString *)_getLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

+ (NSString *)_getCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

+(unsigned long long)_getSizeOfFolder:(NSString *)folderPath {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    return folderSize;
}


+(NSString *)obtainOperator {
    //获取本机运营商名称
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        mobile = @"没装SIM卡,无运营商";
    }else{
        mobile = [carrier carrierName];
    }
//    mobile = [carrier carrierName];
    return mobile;
}

// 获取idfa
+(NSString *)getIDFA {
    __block NSString *idfa;
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"IDFA:\n%@",idfa);
            } else {
                NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
            }
        }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"IDFA:\n%@",idfa);
        } else {
            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
    return idfa;
}

@end
