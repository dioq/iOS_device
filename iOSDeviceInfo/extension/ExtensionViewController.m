//
//  ExtensionViewController.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2023/3/29.
//

#import "ExtensionViewController.h"

OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;

@interface ExtensionViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;
@property(nonatomic,strong)NSMutableDictionary *tipDict;

@end

@implementation ExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"私有API";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.show.delegate = self;
    self.tipDict = [NSMutableDictionary dictionary];
    
    [self refresh];
}

-(void)refresh {
    [self.view endEditing:YES];
    [self.tipDict removeAllObjects];
    
    CFStringRef DeviceName = MGCopyAnswer(CFSTR("DeviceName"));
    NSLog(@"DeviceName = %@", DeviceName);
    NSString *deviceName = (__bridge_transfer NSString *)DeviceName;
    [self.tipDict setValue:deviceName forKey:@"DeviceName"];
    
    CFStringRef ProductType = MGCopyAnswer(CFSTR("ProductType"));
    NSLog(@"ProductType = %@", ProductType);
    NSString *productType = (__bridge_transfer NSString *)ProductType;
    [self.tipDict setValue:productType forKey:@"ProductType"];
    
    CFStringRef ProductName = MGCopyAnswer(CFSTR("ProductName"));
    NSLog(@"ProductName = %@", ProductName);
    NSString *productName = (__bridge_transfer NSString *)ProductName;
    [self.tipDict setValue:productName forKey:@"ProductName"];
    
    CFStringRef ChipID = MGCopyAnswer(CFSTR("ChipID"));
    NSLog(@"ChipID = %@", ChipID);
    NSString *chipID = (__bridge_transfer NSString *)ChipID;
    [self.tipDict setValue:chipID forKey:@"ChipID"];
    
    CFStringRef ProductVersion = MGCopyAnswer(CFSTR("ProductVersion"));
    NSLog(@"ProductVersion = %@", ProductVersion);
    NSString *productVersion = (__bridge_transfer NSString *)ProductVersion;
    [self.tipDict setValue:productVersion forKey:@"ProductVersion"];
    
    CFStringRef BuildVersion = MGCopyAnswer(CFSTR("BuildVersion"));
    NSLog(@"BuildVersion = %@", BuildVersion);
    NSString *buildVersion = (__bridge_transfer NSString *)BuildVersion;
    [self.tipDict setValue:buildVersion forKey:@"BuildVersion"];
    
    CFStringRef SerialNumber = MGCopyAnswer(CFSTR("SerialNumber"));
    NSLog(@"SerialNumber = %@", SerialNumber);
    NSString *serialNumber = (__bridge_transfer NSString *)SerialNumber;
    [self.tipDict setValue:serialNumber forKey:@"SerialNumber"];
    
    CFStringRef IMEI = MGCopyAnswer(CFSTR("QZgogo2DypSAZfkRW4dP/A"));
    NSLog(@"IMEI:%@",IMEI);
    NSString *imei = (__bridge_transfer NSString *)IMEI;
    [self.tipDict setValue:imei forKey:@"IMEI"];
    
    CFStringRef UniqueDeviceID = MGCopyAnswer(CFSTR("nFRqKto/RuQAV1P+0/qkBA"));//MGCopyAnswer(CFSTR("UniqueDeviceID"));
    if(UniqueDeviceID == NULL) {
        UniqueDeviceID = MGCopyAnswer(CFSTR("UniqueDeviceID"));
    }
    NSLog(@"UniqueDeviceID = %@", UniqueDeviceID);
    NSString *udid = (__bridge_transfer NSString *)UniqueDeviceID;
    [self.tipDict setValue:udid forKey:@"UniqueDeviceID"];
    
    CFTypeRef WifiAddress = MGCopyAnswer(CFSTR("WifiAddress"));
    NSLog(@"WifiAddress = %@", WifiAddress);
    NSString *wifiAddress = (__bridge_transfer NSString *)WifiAddress;
    [self.tipDict setValue:wifiAddress forKey:@"WifiAddress"];
    
    CFTypeRef BluetoothAddress = MGCopyAnswer(CFSTR("BluetoothAddress"));
    NSLog(@"BluetoothAddress = %@", BluetoothAddress);
    NSString *bluetoothAddress = (__bridge_transfer NSString *)BluetoothAddress;
    [self.tipDict setValue:bluetoothAddress forKey:@"BluetoothAddress"];
    
    CFTypeRef CPUArchitecture = MGCopyAnswer(CFSTR("CPUArchitecture"));
    NSLog(@"CPUArchitecture = %@", CPUArchitecture);
    NSString *CPUArchitecture_NSStr = (__bridge_transfer NSString *)CPUArchitecture;
    [self.tipDict setValue:CPUArchitecture_NSStr forKey:@"CPUArchitecture"];
    
    CFTypeRef AirplaneMode = MGCopyAnswer(CFSTR("AirplaneMode"));
    if (AirplaneMode == kCFBooleanTrue) {
        NSLog(@"AirplaneMode is on");
    }else{
        NSLog(@"AirplaneMode is off");
    }
    NSString *airplaneMode = (__bridge_transfer NSString *)AirplaneMode;
    [self.tipDict setValue:airplaneMode forKey:@"ProductVersion"];
    //    setreuid(501, 0);// 获取root权限
    
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
