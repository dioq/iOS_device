//
//  NetworkViewController.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2023/3/29.
//

#import "NetworkViewController.h"
#import "DeviceUtil.h"

@interface NetworkViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;
@property(nonatomic,strong)NSMutableDictionary *tipDict;

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网络信息";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.show.delegate = self;
    self.tipDict = [NSMutableDictionary dictionary];
    
    [self refresh];
}

-(void)refresh {
    [self.view endEditing:YES];
    [self.tipDict removeAllObjects];
    
    NSString *deviceIP = [DeviceUtil getDeviceIPAddresses];
    [self.tipDict setValue:deviceIP forKey:@"device ip"];
    
    NSString *cellIP = [DeviceUtil getIpAddressCell];
    [self.tipDict setValue:cellIP forKey:@"蜂窝地址IP"];
    
    NSString *wifiIP = [DeviceUtil getIpAddressWIFI];
    [self.tipDict setValue:wifiIP forKey:@"wifi ip"];
    
    //获取本机运营商名称
    [self.tipDict setValue:[DeviceUtil obtainOperator] forKey:@"运营商"];
    
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
