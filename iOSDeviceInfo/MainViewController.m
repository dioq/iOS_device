//
//  MainViewController.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2022/7/15.
//

#import "MainViewController.h"
#import "ShowViewController.h"
#import "DeviceUtil.h"
#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>

@interface MainViewController ()

@property(nonatomic,copy)NSMutableArray *dataArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"App能获取的设备信息";
}

- (IBAction)hardware:(UIButton *)sender {
    _dataArray = [[NSMutableArray alloc] init];
    
    NSString *deviceName = [DeviceUtil getDeviceName];
    [_dataArray addObject:[NSString stringWithFormat:@"设备型号-->%@", deviceName]];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    [_dataArray addObject:[NSString stringWithFormat:@"sysname-->%@", sysname]];
    NSString *nodename = [NSString stringWithCString:systemInfo. nodename encoding:NSUTF8StringEncoding];
    [_dataArray addObject:[NSString stringWithFormat:@"nodename-->%@", nodename]];
    NSString *release = [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding];
    [_dataArray addObject:[NSString stringWithFormat:@"release-->%@", release]];
    NSString *version = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    [_dataArray addObject:[NSString stringWithFormat:@"version-->%@", version]];
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [_dataArray addObject:[NSString stringWithFormat:@"machine-->%@", machine]];
    
    
    NSString *macAddress = [DeviceUtil getMacAddress];
    [_dataArray addObject:[NSString stringWithFormat:@"macAddress-->%@", macAddress]];
    
//        NSString *cpuName = [DeviceUtil getCPUProcessor];
    //    [self _addInfoWithKey:@"CPU 处理器名称" infoValue:cpuName];
    
    NSUInteger cpuCount = [DeviceUtil getCPUCount];
    [_dataArray addObject:[NSString stringWithFormat:@"CPU总数目---> %lu", cpuCount]];
    
    CGFloat cpuUsage = [DeviceUtil getCPUUsage];
    [_dataArray addObject:[NSString stringWithFormat:@"CPU使用的总比例---> %f", cpuUsage]];
    
    NSUInteger cpuFrequency = [DeviceUtil getCPUFrequency];
    [_dataArray addObject:[NSString stringWithFormat:@"CPU 频率---> %lu", cpuFrequency]];
    
    NSArray *perCPUArr = [DeviceUtil getPerCPUUsage];
    NSMutableString *perCPUUsage = [NSMutableString string];
    for (NSNumber *per in perCPUArr) {
        
        [perCPUUsage appendFormat:@"%.2f<-->", per.floatValue];
    }
    [_dataArray addObject:[NSString stringWithFormat:@"CPU 单个CPU使用比例---> %@", perCPUUsage]];
    
    ShowViewController *showVC = [[ShowViewController alloc]init];
    showVC.title = @"硬件信息";
    showVC.dataArray = self.dataArray;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)osinfo:(UIButton *)sender {
    _dataArray = [[NSMutableArray alloc] init];
    
    NSString *iPhoneName = [UIDevice currentDevice].name;
    [_dataArray addObject:[NSString stringWithFormat:@"iPhone名称-->%@", iPhoneName]];
    
    NSString *localizedModel = [UIDevice currentDevice].localizedModel;
    [_dataArray addObject:[NSString stringWithFormat:@"设备区域化型号-->%@", localizedModel]];
    
    NSString *systemName = [UIDevice currentDevice].systemName;
    [_dataArray addObject:[NSString stringWithFormat:@"当前系统名称-->%@", systemName]];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    [_dataArray addObject:[NSString stringWithFormat:@"当前系统版本号-->%@", systemVersion]];
    
    // 设备上次重启的时间
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    NSDate *lastRestartDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *lastRestartDateString = [dateFormatter stringFromDate:lastRestartDate];
    [_dataArray addObject:[NSString stringWithFormat:@"上次重启时间-->%@", lastRestartDateString]];
    
    NSString *idfa = [DeviceUtil getIDFA];
    [_dataArray addObject:[NSString stringWithFormat:@"广告位标识符idfa-->%@", idfa]];
    
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [_dataArray addObject:[NSString stringWithFormat:@"唯一识别码(idfv)uuid-->%@", uuid]];
    
    
    ShowViewController *showVC = [[ShowViewController alloc]init];
    showVC.title = @"系统信息";
    showVC.dataArray = self.dataArray;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)BatteryInfo:(UIButton *)sender {
    _dataArray = [[NSMutableArray alloc] init];
    
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    [_dataArray addObject:[NSString stringWithFormat:@"电池电量-->%f", batteryLevel]];
    
    ShowViewController *showVC = [[ShowViewController alloc]init];
    showVC.title = @"电池信息";
    showVC.dataArray = self.dataArray;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)network:(UIButton *)sender {
    _dataArray = [[NSMutableArray alloc] init];
    
    NSString *deviceIP = [DeviceUtil getDeviceIPAddresses];
    [_dataArray addObject:[NSString stringWithFormat:@"deviceIP-->%@", deviceIP]];
    
    NSString *cellIP = [DeviceUtil getIpAddressCell];
    [_dataArray addObject:[NSString stringWithFormat:@"蜂窝地址IP-->%@", cellIP]];
    
    NSString *wifiIP = [DeviceUtil getIpAddressWIFI];
    [_dataArray addObject:[NSString stringWithFormat:@"WIFI IP地址-->%@", wifiIP]];
    
    //获取本机运营商名称
    [_dataArray addObject:[NSString stringWithFormat:@"运营商-->%@", [DeviceUtil obtainOperator]]];
    
    ShowViewController *showVC = [[ShowViewController alloc]init];
    showVC.title = @"IP信息";
    showVC.dataArray = self.dataArray;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)diskmemory:(UIButton *)sender {
    _dataArray = [[NSMutableArray alloc] init];
    
    NSString *applicationSize = [DeviceUtil getApplicationSize];
    //    [self _addInfoWithKey:@"当前 App 所占内存空间" infoValue:applicationSize];
    [_dataArray addObject:[NSString stringWithFormat:@"当前 App 所占内存空间-->%@", applicationSize]];
    
    int64_t totalDisk = [DeviceUtil getTotalDiskSpace];
    NSString *totalDiskInfo = [NSString stringWithFormat:@"== %.2f MB == %.2f GB", totalDisk/1024/1024.0, totalDisk/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"磁盘总空间" infoValue:totalDiskInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"磁盘总空间-->%@", totalDiskInfo]];
    
    int64_t usedDisk = [DeviceUtil getUsedDiskSpace];
    NSString *usedDiskInfo = [NSString stringWithFormat:@" == %.2f MB == %.2f GB", usedDisk/1024/1024.0, usedDisk/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"磁盘 已使用空间" infoValue:usedDiskInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"磁盘 已使用空间-->%@", usedDiskInfo]];
    
    int64_t freeDisk = [DeviceUtil getFreeDiskSpace];
    NSString *freeDiskInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeDisk/1024/1024.0, freeDisk/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"磁盘空闲空间" infoValue:freeDiskInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"磁盘空闲空间-->%@", freeDiskInfo]];
    
    int64_t totalMemory = [DeviceUtil getTotalMemory];
    NSString *totalMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", totalMemory/1024/1024.0, totalMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"系统总内存空间" infoValue:totalMemoryInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"系统总内存空间-->%@", totalMemoryInfo]];
    
    int64_t freeMemory = [DeviceUtil getFreeMemory];
    NSString *freeMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeMemory/1024/1024.0, freeMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"空闲的内存空间" infoValue:freeMemoryInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"空闲的内存空间-->%@", freeMemoryInfo]];
    
    int64_t usedMemory = [DeviceUtil getFreeDiskSpace];
    NSString *usedMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", usedMemory/1024/1024.0, usedMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"已使用的内存空间" infoValue:usedMemoryInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"已使用的内存空间-->%@", usedMemoryInfo]];
    
    int64_t activeMemory = [DeviceUtil getActiveMemory];
    NSString *activeMemoryInfo = [NSString stringWithFormat:@"正在使用或者很短时间内被使用过 %.2f MB == %.2f GB", activeMemory/1024/1024.0, activeMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"活跃的内存" infoValue:activeMemoryInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"活跃的内存-->%@", activeMemoryInfo]];
    
    int64_t inActiveMemory = [DeviceUtil getInActiveMemory];
    NSString *inActiveMemoryInfo = [NSString stringWithFormat:@"但是目前处于不活跃状态的内存 %.2f MB == %.2f GB", inActiveMemory/1024/1024.0, inActiveMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"最近使用过" infoValue:inActiveMemoryInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"最近使用过-->%@", inActiveMemoryInfo]];
    
    int64_t wiredMemory = [DeviceUtil getWiredMemory];
    NSString *wiredMemoryInfo = [NSString stringWithFormat:@"framework、用户级别的应用无法分配 %.2f MB == %.2f GB", wiredMemory/1024/1024.0, wiredMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"用来存放内核和数据结构的内存" infoValue:wiredMemoryInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"用来存放内核和数据结构的内存-->%@", wiredMemoryInfo]];
    
    int64_t purgableMemory = [DeviceUtil getPurgableMemory];
    NSString *purgableMemoryInfo = [NSString stringWithFormat:@"大对象存放所需的大块内存空间 %.2f MB == %.2f GB", purgableMemory/1024/1024.0, purgableMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"可释放的内存空间：内存吃紧自动释放" infoValue:purgableMemoryInfo];
    [_dataArray addObject:[NSString stringWithFormat:@"可释放的内存空间(内存吃紧自动释放)-->%@", purgableMemoryInfo]];
    
    ShowViewController *showVC = [[ShowViewController alloc]init];
    showVC.title = @"内存和硬盘信息";
    showVC.dataArray = self.dataArray;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)appinfo:(UIButton *)sender {
    _dataArray = [[NSMutableArray alloc] init];

    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    
    //获取当前App的版本号信息
    [_dataArray addObject:[NSString stringWithFormat:@"App的版本号信息-->%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]]];
    
    //获取当前App的build版本号信息
    [_dataArray addObject:[NSString stringWithFormat:@"App的build版本号信息-->%@", [infoDictionary objectForKey:@"CFBundleVersion"]]];
    
    //获取当前App的包名信息
    [_dataArray addObject:[NSString stringWithFormat:@"App的包名信息-->%@", [infoDictionary objectForKey:@"CFBundleIdentifier"]]];
//    [_dataArray addObject:[NSString stringWithFormat:@"App的包名信息-->%@", [currentBundle bundleIdentifier]]];
//    NSLog(@"bundleIdentifier:%@",[currentBundle bundleIdentifier]);
    
    //获取当前App的名称信息
    [_dataArray addObject:[NSString stringWithFormat:@"App的名称信息-->%@", [infoDictionary objectForKey:@"CFBundleDisplayName"]]];
    
    ShowViewController *showVC = [[ShowViewController alloc]init];
    showVC.title = @"App 信息";
    showVC.dataArray = self.dataArray;
    [self.navigationController pushViewController:showVC animated:YES];
}

@end
