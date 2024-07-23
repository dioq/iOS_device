//
//  HardwareViewController.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2023/3/29.
//

#import "HardwareViewController.h"
#import "DeviceUtil.h"
#import "FileUtil.h"

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
    
    NSString *readable;
    
    NSString *macAddress = [DeviceUtil getMacAddress];
    [self.tipDict setValue:macAddress forKey:@"macAddress"];
    
    //    NSString *cpuName = [DeviceUtil getCPUProcessor];
    //    [self _addInfoWithKey:@"CPU 处理器名称" infoValue:cpuName];
    //    [self.tipDict setValue:cpuName forKey:@"CPU 处理器名称"];
    
    NSMutableDictionary *cpuMutDict = [NSMutableDictionary dictionary];
    
    NSUInteger cpuCount = [DeviceUtil getCPUCount];
    [cpuMutDict setValue:[NSNumber numberWithInteger:cpuCount] forKey:@"CPU总数目"];
    
    CGFloat cpuUsage = [DeviceUtil getCPUUsage];
    [cpuMutDict setValue:[NSNumber numberWithFloat:cpuUsage] forKey:@"CPU使用的总比例"];
    
    NSUInteger cpuFrequency = [DeviceUtil getCPUFrequency];
    [cpuMutDict setValue:[NSNumber numberWithInteger:cpuFrequency] forKey:@"CPU 频率"];
    
    NSArray *perCPUArr = [DeviceUtil getPerCPUUsage];
    NSMutableString *perCPUUsage = [NSMutableString string];
    for (NSNumber *per in perCPUArr) {
        [perCPUUsage appendFormat:@"%.2f :", per.floatValue];
    }
    [perCPUUsage deleteCharactersInRange:NSMakeRange([perCPUUsage length]-1, 1)];
    [cpuMutDict setValue:perCPUUsage forKey:@"单个CPU使用比例"];
    
    [self.tipDict setObject:cpuMutDict forKey:@"CPU"];
    
    NSMutableDictionary *batteryMutDict = [NSMutableDictionary dictionary];
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel] * 100;
    readable = [NSString stringWithFormat:@"%f",batteryLevel];
    [batteryMutDict setValue:readable forKey:@"电池电量"];
    
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
    [batteryMutDict setValue:batteryStatu_str forKey:@"电池状态"];
    [self.tipDict setObject:batteryMutDict forKey:@"电池"];
    
    NSMutableDictionary *diskMutDict = [NSMutableDictionary dictionary];
    int64_t totalDisk = [DeviceUtil getTotalDiskSpace];
    readable = [[FileUtil sharedManager] convertSzie:totalDisk];
    [diskMutDict setValue:readable forKey:@"磁盘总空间"];
    int64_t usedDisk = [DeviceUtil getUsedDiskSpace];
    readable = [[FileUtil sharedManager] convertSzie:usedDisk];
    [diskMutDict setValue:readable forKey:@"磁盘已使用空间"];
    int64_t freeDisk = [DeviceUtil getFreeDiskSpace];
    readable = [[FileUtil sharedManager] convertSzie:freeDisk];
    [diskMutDict setValue:readable forKey:@"磁盘空闲空间"];
    unsigned long long applicationSize = [DeviceUtil getApplicationSize];
    readable = [[FileUtil sharedManager] convertSzie:applicationSize];
    [diskMutDict setValue:readable forKey:@"本 App 所占磁盘空间"];
    [self.tipDict setObject:diskMutDict forKey:@"磁盘"];
    
    NSMutableDictionary *memoryMutDict = [NSMutableDictionary dictionary];
    
    int64_t totalMemory = [DeviceUtil getTotalMemory];
    readable = [[FileUtil sharedManager] convertSzie:totalMemory];
    [memoryMutDict setValue:readable forKey:@"系统总内存空间"];
    
    int64_t activeMemory = [DeviceUtil getActiveMemory];
    readable = [[FileUtil sharedManager] convertSzie:activeMemory];
    [memoryMutDict setValue:readable forKey:@"活跃的内存"];
    
    int64_t InActiveMemory = [DeviceUtil getInActiveMemory];
    readable = [[FileUtil sharedManager] convertSzie:InActiveMemory];
    [memoryMutDict setValue:readable forKey:@"不活跃的内存空间"];
    
    int64_t freeMemory = [DeviceUtil getFreeMemory];
    readable = [[FileUtil sharedManager] convertSzie:freeMemory];
    [memoryMutDict setValue:readable forKey:@"空闲的内存空间"];
    
    int64_t usedMemory = [DeviceUtil getUsedMemory];
    readable = [[FileUtil sharedManager] convertSzie:usedMemory];
    [memoryMutDict setValue:readable forKey:@"已使用的内存空间"];
    
    int64_t wiredMemory = [DeviceUtil getWiredMemory];
    readable = [[FileUtil sharedManager] convertSzie:wiredMemory];
    [memoryMutDict setValue:readable forKey:@"用来存放内核和数据结构的内存"];//用户级别的应用无法分配
    
    int64_t purgableMemory = [DeviceUtil getPurgableMemory];
    readable = [[FileUtil sharedManager] convertSzie:purgableMemory];
    [memoryMutDict setValue:readable forKey:@"可释放的内存空间(内存吃紧自动释放)"];
    
    [self.tipDict setObject:memoryMutDict forKey:@"内存"];
    
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
