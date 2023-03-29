//
//  OSViewController.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2023/3/29.
//

#import "SoftwareViewController.h"
#import "DeviceUtil.h"
#import "sys/utsname.h"

@interface SoftwareViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;
@property(nonatomic,strong)NSMutableDictionary *tipDict;

@end

@implementation SoftwareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"软件信息";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.show.delegate = self;
    self.tipDict = [NSMutableDictionary dictionary];
    
    [self refresh];
}

-(void)refresh {
    [self.view endEditing:YES];
    [self.tipDict removeAllObjects];
    NSString *iPhoneName = [UIDevice currentDevice].name;
    [_tipDict setValue:iPhoneName forKey:@"设备名字"];
    
    NSString *localizedModel = [UIDevice currentDevice].localizedModel;
    [_tipDict setValue:localizedModel forKey:@"设备区域化型号"];
    
    NSString *systemName = [UIDevice currentDevice].systemName;
    [_tipDict setValue:systemName forKey:@"系统名称"];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    [_tipDict setValue:systemVersion forKey:@"系统版本号"];
    
    // 设备上次重启的时间
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    NSDate *lastRestartDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *lastRestartDateString = [dateFormatter stringFromDate:lastRestartDate];
    [_tipDict setValue:lastRestartDateString forKey:@"上次启动时间"];
    
    NSString *idfa = [DeviceUtil getIDFA];
    [_tipDict setValue:idfa forKey:@"idfa"];
    
    NSString *deviceMode = [DeviceUtil getDeviceMode];
    [_tipDict setValue:deviceMode forKey:@"发售版本"];
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"idfv:\n%@", idfv);
    [_tipDict setValue:idfv forKey:@"idfv"];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    [_tipDict setValue:sysname forKey:@"darwin_sysname"];
    NSString *nodename = [NSString stringWithCString:systemInfo. nodename encoding:NSUTF8StringEncoding];
    [_tipDict setValue:nodename forKey:@"darwin_nodename"];
    NSString *release = [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding];
    [_tipDict setValue:release forKey:@"darwin_release"];
    NSString *version = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    [_tipDict setValue:version forKey:@"darwin_version"];
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [_tipDict setValue:machine forKey:@"darwin_machine"];
    
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
