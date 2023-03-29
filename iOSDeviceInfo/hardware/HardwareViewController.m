//
//  HardwareViewController.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2023/3/29.
//

#import "HardwareViewController.h"
#import "DeviceUtil.h"

@interface HardwareViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;
@property(nonatomic,strong)NSMutableDictionary *tipDict;

@end

@implementation HardwareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"硬件信息";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.show.delegate = self;
    self.tipDict = [NSMutableDictionary dictionary];
    
    [self refresh];
}

-(void)refresh {
    [self.view endEditing:YES];
    [self.tipDict removeAllObjects];
    
    NSString *macAddress = [DeviceUtil getMacAddress];
    [self.tipDict setValue:macAddress forKey:@"macAddress"];
    
    //    NSString *cpuName = [DeviceUtil getCPUProcessor];
    //        [self _addInfoWithKey:@"CPU 处理器名称" infoValue:cpuName];
    //    [self.tipDict setValue:cpuName forKey:@"CPU 处理器名称"];
    
    NSUInteger cpuCount = [DeviceUtil getCPUCount];
    [self.tipDict setValue:[NSNumber numberWithInteger:cpuCount] forKey:@"CPU总数目"];
    
    CGFloat cpuUsage = [DeviceUtil getCPUUsage];
    [self.tipDict setValue:[NSNumber numberWithFloat:cpuUsage] forKey:@"CPU使用的总比例"];
    
    NSUInteger cpuFrequency = [DeviceUtil getCPUFrequency];
    [self.tipDict setValue:[NSNumber numberWithInteger:cpuFrequency] forKey:@"CPU 频率"];
    
    NSArray *perCPUArr = [DeviceUtil getPerCPUUsage];
    NSMutableString *perCPUUsage = [NSMutableString string];
    for (NSNumber *per in perCPUArr) {
        [perCPUUsage appendFormat:@"%.2f :", per.floatValue];
    }
    [perCPUUsage deleteCharactersInRange:NSMakeRange([perCPUUsage length]-1, 1)];
    [self.tipDict setValue:perCPUUsage forKey:@"单个CPU使用比例"];
    
    
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel] * 100;
    [self.tipDict setValue:[NSNumber numberWithInteger:batteryLevel] forKey:@"电池电量"];
    
    UIDeviceBatteryState batteryStatu = [UIDevice currentDevice].batteryState;
    NSString *batteryStatu_str;
    switch (batteryStatu) {
        case UIDeviceBatteryStateCharging:
            NSLog(@"电量: 正在充电");
            batteryStatu_str = @"正在充电";
            break;
        case UIDeviceBatteryStateFull:
            NSLog(@"电量: 已充满");
            batteryStatu_str = @"已充满";
            break;
        case UIDeviceBatteryStateUnplugged:
            NSLog(@"电量: 正在放电");
            batteryStatu_str = @"正在放电";
            break;
        case UIDeviceBatteryStateUnknown:
            NSLog(@"电量: 未知状态");
            batteryStatu_str = @"未知状态";
            break;
        default:
        {
            NSString *tip = [NSString stringWithFormat:@"电量: 错误 %lu", batteryStatu];
            NSLog(@"%@", tip);
            batteryStatu_str = tip;
        }
            break;
    }
    [self.tipDict setValue:batteryStatu_str forKey:@"电池状态"];
    
    
    NSString *applicationSize = [DeviceUtil getApplicationSize];
    [self.tipDict setValue:applicationSize forKey:@"当前 App 所占内存空间"];
    
    int64_t totalDisk = [DeviceUtil getTotalDiskSpace];
    NSString *totalDiskInfo = [NSString stringWithFormat:@"== %.2f MB == %.2f GB", totalDisk/1024/1024.0, totalDisk/1024/1024/1024.0];
    [self.tipDict setValue:totalDiskInfo forKey:@"磁盘总空间"];
    
    int64_t usedDisk = [DeviceUtil getUsedDiskSpace];
    NSString *usedDiskInfo = [NSString stringWithFormat:@" == %.2f MB == %.2f GB", usedDisk/1024/1024.0, usedDisk/1024/1024/1024.0];
    [self.tipDict setValue:usedDiskInfo forKey:@"磁盘已使用空间间"];
    
    int64_t freeDisk = [DeviceUtil getFreeDiskSpace];
    NSString *freeDiskInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeDisk/1024/1024.0, freeDisk/1024/1024/1024.0];
    [self.tipDict setValue:freeDiskInfo forKey:@"磁盘空闲空间"];
    
    int64_t totalMemory = [DeviceUtil getTotalMemory];
    NSString *totalMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", totalMemory/1024/1024.0, totalMemory/1024/1024/1024.0];
    [self.tipDict setValue:totalMemoryInfo forKey:@"系统总内存空间"];
    
    int64_t freeMemory = [DeviceUtil getFreeMemory];
    NSString *freeMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeMemory/1024/1024.0, freeMemory/1024/1024/1024.0];
    [self.tipDict setValue:freeMemoryInfo forKey:@"空闲的内存空间"];
    
    int64_t usedMemory = [DeviceUtil getFreeDiskSpace];
    NSString *usedMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", usedMemory/1024/1024.0, usedMemory/1024/1024/1024.0];
    [self.tipDict setValue:usedMemoryInfo forKey:@"已使用的内存空间"];
    
    int64_t activeMemory = [DeviceUtil getActiveMemory];
    NSString *activeMemoryInfo = [NSString stringWithFormat:@"正在使用或者很短时间内被使用过 %.2f MB == %.2f GB", activeMemory/1024/1024.0, activeMemory/1024/1024/1024.0];
    [self.tipDict setValue:activeMemoryInfo forKey:@"活跃的内存"];
    
    int64_t inActiveMemory = [DeviceUtil getInActiveMemory];
    NSString *inActiveMemoryInfo = [NSString stringWithFormat:@"但是目前处于不活跃状态的内存 %.2f MB == %.2f GB", inActiveMemory/1024/1024.0, inActiveMemory/1024/1024/1024.0];
    [self.tipDict setValue:inActiveMemoryInfo forKey:@"最近使用过"];
    
    int64_t wiredMemory = [DeviceUtil getWiredMemory];
    NSString *wiredMemoryInfo = [NSString stringWithFormat:@"framework、用户级别的应用无法分配 %.2f MB == %.2f GB", wiredMemory/1024/1024.0, wiredMemory/1024/1024/1024.0];
    [self.tipDict setValue:wiredMemoryInfo forKey:@"用来存放内核和数据结构的内存"];
    
    int64_t purgableMemory = [DeviceUtil getPurgableMemory];
    NSString *purgableMemoryInfo = [NSString stringWithFormat:@"大对象存放所需的大块内存空间 %.2f MB == %.2f GB", purgableMemory/1024/1024.0, purgableMemory/1024/1024/1024.0];
    [self.tipDict setValue:purgableMemoryInfo forKey:@"可释放的内存空间(内存吃紧自动释放)"];
    
    [self showInfo];
}

-(void)showInfo {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.tipDict options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        [self showTip:[error localizedFailureReason]];
    }else{
        NSString *logStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self showTip:logStr];
    }
}

-(void)showTip:(NSString * _Nonnull)tip {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.show setText:tip];
        NSLog(@"%@",tip);
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
