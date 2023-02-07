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

@property(nonatomic,strong)NSMutableDictionary *deviceInfo;
@property (weak, nonatomic) IBOutlet UITextView *show;

@end

static NSString *saveDeviceInfoUrl = @"http://hk.hanlee.top:58003/api/ios/savecoldevinfo";

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"App能获取的设备信息";
    self.deviceInfo = [NSMutableDictionary dictionary];
}

- (IBAction)hardware:(UIButton *)sender {
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    
    NSString *deviceName = [DeviceUtil getDeviceName];
    [dataArray addObject:[NSString stringWithFormat:@"设备型号:%@", deviceName]];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    [dataArray addObject:[NSString stringWithFormat:@"sysname:%@", sysname]];
    NSString *nodename = [NSString stringWithCString:systemInfo. nodename encoding:NSUTF8StringEncoding];
    [dataArray addObject:[NSString stringWithFormat:@"nodename:%@", nodename]];
    NSString *release = [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding];
    [dataArray addObject:[NSString stringWithFormat:@"release:%@", release]];
    NSString *version = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    [dataArray addObject:[NSString stringWithFormat:@"version:%@", version]];
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [dataArray addObject:[NSString stringWithFormat:@"machine:%@", machine]];
    
    
    NSString *macAddress = [DeviceUtil getMacAddress];
    [dataArray addObject:[NSString stringWithFormat:@"macAddress:%@", macAddress]];
    
    //        NSString *cpuName = [DeviceUtil getCPUProcessor];
    //    [self _addInfoWithKey:@"CPU 处理器名称" infoValue:cpuName];
    
    NSUInteger cpuCount = [DeviceUtil getCPUCount];
    [dataArray addObject:[NSString stringWithFormat:@"CPU总数目: %lu", cpuCount]];
    
    CGFloat cpuUsage = [DeviceUtil getCPUUsage];
    [dataArray addObject:[NSString stringWithFormat:@"CPU使用的总比例: %f", cpuUsage]];
    
    NSUInteger cpuFrequency = [DeviceUtil getCPUFrequency];
    [dataArray addObject:[NSString stringWithFormat:@"CPU 频率: %lu", cpuFrequency]];
    
    NSArray *perCPUArr = [DeviceUtil getPerCPUUsage];
    NSMutableString *perCPUUsage = [NSMutableString string];
    for (NSNumber *per in perCPUArr) {
        [perCPUUsage appendFormat:@"%.2f :", per.floatValue];
    }
    [perCPUUsage deleteCharactersInRange:NSMakeRange([perCPUUsage length]-1, 1)];
    [dataArray addObject:[NSString stringWithFormat:@"CPU 单个CPU使用比例: %@", perCPUUsage]];
    
    //    [self submitInfo:@"hardware"];
    // 汇总并上传
    [self.deviceInfo setObject:dataArray forKey:@"hardware"];
    
    if (sender != nil) {
        ShowViewController *showVC = [[ShowViewController alloc]init];
        showVC.title = @"硬件信息";
        showVC.dataArray = dataArray;
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

- (IBAction)osinfo:(UIButton *)sender {
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    //    dataArray = [[NSMutableArray alloc] init];
    
    NSString *iPhoneName = [UIDevice currentDevice].name;
    [dataArray addObject:[NSString stringWithFormat:@"iPhone名称:%@", iPhoneName]];
    
    NSString *localizedModel = [UIDevice currentDevice].localizedModel;
    [dataArray addObject:[NSString stringWithFormat:@"设备区域化型号:%@", localizedModel]];
    
    NSString *systemName = [UIDevice currentDevice].systemName;
    [dataArray addObject:[NSString stringWithFormat:@"当前系统名称:%@", systemName]];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    [dataArray addObject:[NSString stringWithFormat:@"当前系统版本号:%@", systemVersion]];
    
    // 设备上次重启的时间
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    NSDate *lastRestartDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *lastRestartDateString = [dateFormatter stringFromDate:lastRestartDate];
    [dataArray addObject:[NSString stringWithFormat:@"上次重启时间:%@", lastRestartDateString]];
    
    NSString *idfa = [DeviceUtil getIDFA];
    [dataArray addObject:[NSString stringWithFormat:@"广告位标识符idfa:%@", idfa]];
    
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"唯一识别码(idfv)uuid:\n%@", uuid);
    [dataArray addObject:[NSString stringWithFormat:@"唯一识别码(idfv)uuid:%@", uuid]];
    
    // 汇总并上传
    [self.deviceInfo setObject:dataArray forKey:@"osinfo"];
    
    if (sender != nil) {
        ShowViewController *showVC = [[ShowViewController alloc]init];
        showVC.title = @"系统信息";
        showVC.dataArray = dataArray;
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

- (IBAction)BatteryInfo:(UIButton *)sender {
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel] * 100;
    [dataArray addObject:[NSString stringWithFormat:@"电池电量:%f", batteryLevel]];
    
    UIDeviceBatteryState batteryStatu = [UIDevice currentDevice].batteryState;
    [dataArray addObject:[NSString stringWithFormat:@"电池状态:%ld", batteryStatu]];
    switch (batteryStatu) {
        case UIDeviceBatteryStateCharging:
            NSLog(@"电量: 正在充电");
            break;
        case UIDeviceBatteryStateFull:
            NSLog(@"电量: 已充满");
            break;
        case UIDeviceBatteryStateUnplugged:
            NSLog(@"电量: 正在放电");
            break;
        default:
            NSLog(@"电量: 未知状态");
            break;
    }
    
    // 汇总并上传
    [self.deviceInfo setObject:dataArray forKey:@"batteryinfo"];
    
    if (sender != nil) {
        ShowViewController *showVC = [[ShowViewController alloc]init];
        showVC.title = @"电池信息";
        showVC.dataArray = dataArray;
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

- (IBAction)network:(UIButton *)sender {
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    //    dataArray = [[NSMutableArray alloc] init];
    
    NSString *deviceIP = [DeviceUtil getDeviceIPAddresses];
    [dataArray addObject:[NSString stringWithFormat:@"deviceIP:%@", deviceIP]];
    
    NSString *cellIP = [DeviceUtil getIpAddressCell];
    [dataArray addObject:[NSString stringWithFormat:@"蜂窝地址IP:%@", cellIP]];
    
    NSString *wifiIP = [DeviceUtil getIpAddressWIFI];
    [dataArray addObject:[NSString stringWithFormat:@"WIFI IP地址:%@", wifiIP]];
    
    //获取本机运营商名称
    [dataArray addObject:[NSString stringWithFormat:@"运营商:%@", [DeviceUtil obtainOperator]]];
    
    //    [self submitInfo:@"network"];
    // 汇总并上传
    [self.deviceInfo setObject:dataArray forKey:@"network"];
    
    if (sender != nil) {
        ShowViewController *showVC = [[ShowViewController alloc]init];
        showVC.title = @"IP信息";
        showVC.dataArray = dataArray;
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

- (IBAction)diskmemory:(UIButton *)sender {
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    //    dataArray = [[NSMutableArray alloc] init];
    
    NSString *applicationSize = [DeviceUtil getApplicationSize];
    //    [self _addInfoWithKey:@"当前 App 所占内存空间" infoValue:applicationSize];
    [dataArray addObject:[NSString stringWithFormat:@"当前 App 所占内存空间:%@", applicationSize]];
    
    int64_t totalDisk = [DeviceUtil getTotalDiskSpace];
    NSString *totalDiskInfo = [NSString stringWithFormat:@"== %.2f MB == %.2f GB", totalDisk/1024/1024.0, totalDisk/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"磁盘总空间" infoValue:totalDiskInfo];
    [dataArray addObject:[NSString stringWithFormat:@"磁盘总空间:%@", totalDiskInfo]];
    
    int64_t usedDisk = [DeviceUtil getUsedDiskSpace];
    NSString *usedDiskInfo = [NSString stringWithFormat:@" == %.2f MB == %.2f GB", usedDisk/1024/1024.0, usedDisk/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"磁盘 已使用空间" infoValue:usedDiskInfo];
    [dataArray addObject:[NSString stringWithFormat:@"磁盘 已使用空间:%@", usedDiskInfo]];
    
    int64_t freeDisk = [DeviceUtil getFreeDiskSpace];
    NSString *freeDiskInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeDisk/1024/1024.0, freeDisk/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"磁盘空闲空间" infoValue:freeDiskInfo];
    [dataArray addObject:[NSString stringWithFormat:@"磁盘空闲空间:%@", freeDiskInfo]];
    
    int64_t totalMemory = [DeviceUtil getTotalMemory];
    NSString *totalMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", totalMemory/1024/1024.0, totalMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"系统总内存空间" infoValue:totalMemoryInfo];
    [dataArray addObject:[NSString stringWithFormat:@"系统总内存空间:%@", totalMemoryInfo]];
    
    int64_t freeMemory = [DeviceUtil getFreeMemory];
    NSString *freeMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeMemory/1024/1024.0, freeMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"空闲的内存空间" infoValue:freeMemoryInfo];
    [dataArray addObject:[NSString stringWithFormat:@"空闲的内存空间:%@", freeMemoryInfo]];
    
    int64_t usedMemory = [DeviceUtil getFreeDiskSpace];
    NSString *usedMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", usedMemory/1024/1024.0, usedMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"已使用的内存空间" infoValue:usedMemoryInfo];
    [dataArray addObject:[NSString stringWithFormat:@"已使用的内存空间:%@", usedMemoryInfo]];
    
    int64_t activeMemory = [DeviceUtil getActiveMemory];
    NSString *activeMemoryInfo = [NSString stringWithFormat:@"正在使用或者很短时间内被使用过 %.2f MB == %.2f GB", activeMemory/1024/1024.0, activeMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"活跃的内存" infoValue:activeMemoryInfo];
    [dataArray addObject:[NSString stringWithFormat:@"活跃的内存:%@", activeMemoryInfo]];
    
    int64_t inActiveMemory = [DeviceUtil getInActiveMemory];
    NSString *inActiveMemoryInfo = [NSString stringWithFormat:@"但是目前处于不活跃状态的内存 %.2f MB == %.2f GB", inActiveMemory/1024/1024.0, inActiveMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"最近使用过" infoValue:inActiveMemoryInfo];
    [dataArray addObject:[NSString stringWithFormat:@"最近使用过:%@", inActiveMemoryInfo]];
    
    int64_t wiredMemory = [DeviceUtil getWiredMemory];
    NSString *wiredMemoryInfo = [NSString stringWithFormat:@"framework、用户级别的应用无法分配 %.2f MB == %.2f GB", wiredMemory/1024/1024.0, wiredMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"用来存放内核和数据结构的内存" infoValue:wiredMemoryInfo];
    [dataArray addObject:[NSString stringWithFormat:@"用来存放内核和数据结构的内存:%@", wiredMemoryInfo]];
    
    int64_t purgableMemory = [DeviceUtil getPurgableMemory];
    NSString *purgableMemoryInfo = [NSString stringWithFormat:@"大对象存放所需的大块内存空间 %.2f MB == %.2f GB", purgableMemory/1024/1024.0, purgableMemory/1024/1024/1024.0];
    //    [self _addInfoWithKey:@"可释放的内存空间：内存吃紧自动释放" infoValue:purgableMemoryInfo];
    [dataArray addObject:[NSString stringWithFormat:@"可释放的内存空间(内存吃紧自动释放):%@", purgableMemoryInfo]];
    
    //    [self submitInfo:@"diskmemory"];
    // 汇总并上传
    [self.deviceInfo setObject:dataArray forKey:@"diskmemory"];
    
    if (sender != nil) {
        ShowViewController *showVC = [[ShowViewController alloc]init];
        showVC.title = @"内存和硬盘信息";
        showVC.dataArray = dataArray;
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

- (IBAction)appinfo:(UIButton *)sender {
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    //    dataArray = [[NSMutableArray alloc] init];
    
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    
    //获取当前App的版本号信息
    [dataArray addObject:[NSString stringWithFormat:@"App的版本号信息:%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]]];
    
    //获取当前App的build版本号信息
    [dataArray addObject:[NSString stringWithFormat:@"App的build版本号信息:%@", [infoDictionary objectForKey:@"CFBundleVersion"]]];
    
    //获取当前App的包名信息
    [dataArray addObject:[NSString stringWithFormat:@"App的包名信息:%@", [infoDictionary objectForKey:@"CFBundleIdentifier"]]];
    //    [dataArray addObject:[NSString stringWithFormat:@"App的包名信息:%@", [currentBundle bundleIdentifier]]];
    //    NSLog(@"bundleIdentifier:%@",[currentBundle bundleIdentifier]);
    
    //获取当前App的名称信息
    [dataArray addObject:[NSString stringWithFormat:@"App的名称信息:%@", [infoDictionary objectForKey:@"CFBundleDisplayName"]]];
    
    if (sender != nil) {
        ShowViewController *showVC = [[ShowViewController alloc]init];
        showVC.title = @"App 信息";
        showVC.dataArray = dataArray;
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

- (IBAction)extractAndSubmit:(UIButton *)sender {
    [self hardware:nil];
    [self osinfo:nil];
    [self BatteryInfo:nil];
    [self network:nil];
    [self diskmemory:nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *deviceName = [DeviceUtil getDeviceName];
    [param setObject:deviceName forKey:@"model"];
    [param setObject:self.deviceInfo forKey:@"devinfo"];
    
    NSString *urlStr = saveDeviceInfoUrl;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    NSError *error;
    NSData *param_data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *json_str = [[NSString alloc] initWithData:param_data encoding:NSUTF8StringEncoding];
//    NSLog(@"json_str:\n%@",json_str);
    request.HTTPBody = param_data;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30;
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"网络问题!");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.show setText:[NSString stringWithFormat:@"%@",response]];
            });
            return;
        }
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response:\n%@",result);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:result];
        });
    }];
    
    // 执行
    [task resume];
}

@end
