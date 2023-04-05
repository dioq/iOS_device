//
//  ExtensionViewController.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2023/3/29.
//

#import "ExtensionViewController.h"
#import "DeviceInfo.h"
#include "MobileGestalt.h"
#include "Obfuscated.h"

//OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;

@interface ExtensionViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;
@property(nonatomic,strong)NSMutableDictionary *tipDict;

@end

@implementation ExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"私有API";
    self.show.delegate = self;
    self.tipDict = [NSMutableDictionary dictionary];
}

- (IBAction)someImportInfo:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.tipDict removeAllObjects];
    
    NSDictionary *dict = [NSDictionary dictionary];
    CFDictionaryRef options = (__bridge CFDictionaryRef)dict;
    
    setreuid(0, 0);// 获取root权限
    
    // 序列号
    CFStringRef SerialNumber = MGCopyAnswer(kMGSerialNumber, options);
    if(!SerialNumber) {
        SerialNumber = MGCopyAnswer(CFSTR("VasUgeSzVyHdB27g2XpN0g"), options);
    }
    NSLog(@"SerialNumber = %@", SerialNumber);
    NSString *serialNumber = (__bridge_transfer NSString *)SerialNumber;
    [self.tipDict setValue:serialNumber forKey:@"SerialNumber"];
    
    // imei
    CFStringRef IMEI = MGCopyAnswer(kMGInternationalMobileEquipmentIdentity, options);
    if(IMEI == NULL) {
        IMEI = MGCopyAnswer(CFSTR("QZgogo2DypSAZfkRW4dP/A"), options);
    }
    NSLog(@"IMEI:%@",IMEI);
    NSString *imei = (__bridge_transfer NSString *)IMEI;
    [self.tipDict setValue:imei forKey:@"IMEI"];
    
    // udid
    CFStringRef UniqueDeviceID = MGCopyAnswer(kMGUniqueDeviceID, options);
    if(UniqueDeviceID == NULL) {
        UniqueDeviceID = MGCopyAnswer(CFSTR("nFRqKto/RuQAV1P+0/qkBA"), options);
    }
    NSLog(@"UniqueDeviceID = %@", UniqueDeviceID);
    NSString *udid = (__bridge_transfer NSString *)UniqueDeviceID;
    [self.tipDict setValue:udid forKey:@"UniqueDeviceID"];
    
    // wifi 地址
    CFTypeRef WifiAddress = MGCopyAnswer(kMGWifiAddress, options);
    NSLog(@"WifiAddress = %@", WifiAddress);
    NSString *wifiAddress = (__bridge_transfer NSString *)WifiAddress;
    [self.tipDict setValue:wifiAddress forKey:@"WifiAddress"];
    
    // 蓝牙地址
    CFTypeRef BluetoothAddress = MGCopyAnswer(kMGBluetoothAddress, options);
    NSLog(@"BluetoothAddress = %@", BluetoothAddress);
    NSString *bluetoothAddress = (__bridge_transfer NSString *)BluetoothAddress;
    [self.tipDict setValue:bluetoothAddress forKey:@"BluetoothAddress"];
    
    CFTypeRef AirplaneMode = MGCopyAnswer(kMGAirplaneMode, options);
    if (AirplaneMode == kCFBooleanTrue) {
        NSLog(@"AirplaneMode is on");
    }else{
        NSLog(@"AirplaneMode is off");
    }
    NSString *airplaneMode = (__bridge_transfer NSString *)AirplaneMode;
    [self.tipDict setValue:airplaneMode forKey:@"AirplaneMode"];
    
    setreuid(501, 0);// 取消root权限
    
    [self showInfo];
}

- (IBAction)allknow:(UIButton *)sender {
    NSDictionary *dict = [[DeviceInfo new] deviceInfo];
    //    if(dict) {
    //        NSLog(@"%@",dict);
    //    }
}

- (IBAction)obfuscated_param:(UIButton *)sender {
    unsigned long num = sizeof(keyMappingTable) / sizeof(struct tKeyMapping);
    for (int i = 0; i < num; i++) {
        struct tKeyMapping km = keyMappingTable[i];
        if(km.key && km.obfuscatedKey) {
            //            printf("%s:%s\n", km.key,km.obfuscatedKey);
            NSDictionary *dict = [NSDictionary dictionary];
            CFDictionaryRef options = (__bridge CFDictionaryRef)dict;
            CFStringRef keyCFStr = CFStringCreateWithCString(CFAllocatorGetDefault(), km.key, kCFStringEncodingUTF8);
            CFTypeRef dev_info = MGCopyAnswer(keyCFStr, options);
            NSLog(@"%@:%@",keyCFStr,dev_info);
            
            CFStringRef keyobfuscatedCFStr = CFStringCreateWithCString(CFAllocatorGetDefault(), km.obfuscatedKey, kCFStringEncodingUTF8);
            CFTypeRef dev_obfuscated_info = MGCopyAnswer(keyobfuscatedCFStr, options);
            NSLog(@"%@:%@",keyobfuscatedCFStr,dev_obfuscated_info);
            NSLog(@"--------------- one item was end ---------------");
        }
    }
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
