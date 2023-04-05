//
//  DeviceInfo.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2023/4/5.
//

#import "DeviceInfo.h"
#import "MobileGestalt.h"

@implementation DeviceInfo

-(NSDictionary *)deviceInfo {
    NSArray *list = @[
        @"DiskUsage",
        @"ModelNumber",
        @"SIMTrayStatus",
        @"SerialNumber",
        @"MLBSerialNumber",
        @"UniqueDeviceID",
        @"UniqueDeviceIDData",
        @"UniqueChipID",
        @"InverseDeviceID",
        @"DiagData",
        @"DieId",
        @"CPUArchitecture",
        @"PartitionType",
        @"UserAssignedDeviceName",
        @"BluetoothAddress",
        @"RequiredBatteryLevelForSoftwareUpdate",
        @"BatteryIsFullyCharged",
        @"BatteryIsCharging",
        @"BatteryCurrentCapacity",
        @"ExternalPowerSourceConnected",
        @"BasebandSerialNumber",
        @"BasebandCertId",
        @"BasebandChipId",
        @"BasebandFirmwareManifestData",
        @"BasebandFirmwareVersion",
        @"BasebandKeyHashInformation",
        @"CarrierBundleInfoArray",
        @"CarrierInstallCapability",
        @"InternationalMobileEquipmentIdentity",
        @"MobileSubscriberCountryCode",
        @"MobileSubscriberNetworkCode",
        @"ChipID",
        @"ComputerName",
        @"DeviceVariant",
        @"HWModelStr",
        @"BoardId",
        @"HardwarePlatform",
        @"DeviceName",
        @"DeviceColor",
        @"DeviceClassNumber",
        @"DeviceClass",
        @"BuildVersion",
        @"ProductName",
        @"ProductType",
        @"ProductVersion",
        @"FirmwareNonce",
        @"FirmwareVersion",
        @"FirmwarePreflightInfo",
        @"IntegratedCircuitCardIdentifier",
        @"AirplaneMode",
        @"AllowYouTube",
        @"AllowYouTubePlugin",
        @"MinimumSupportediTunesVersion",
        @"ProximitySensorCalibration",
        @"RegionCode",
        @"RegionInfo",
        @"RegulatoryIdentifiers",
        @"SBAllowSensitiveUI",
        @"SBCanForceDebuggingInfo",
        @"SDIOManufacturerTuple",
        @"SDIOProductInfo",
        @"ShouldHactivate",
        @"SigningFuse",
        @"SoftwareBehavior",
        @"SoftwareBundleVersion",
        @"SupportedDeviceFamilies",
        @"SupportedKeyboards",
        @"TotalSystemAvailable",
        @"AllDeviceCapabilities",
        @"AppleInternalInstallCapability",
        @"ExternalChargeCapability",
        @"ForwardCameraCapability",
        @"PanoramaCameraCapability",
        @"RearCameraCapability",
        @"HasAllFeaturesCapability",
        @"HasBaseband",
        @"HasInternalSettingsBundle",
        @"HasSpringBoard",
        @"InternalBuild",
        @"IsSimulator",
        @"IsThereEnoughBatteryLevelForSoftwareUpdate",
        @"IsUIBuild",
        @"RegionalBehaviorAll",
        @"RegionalBehaviorChinaBrick",
        @"RegionalBehaviorEUVolumeLimit",
        @"RegionalBehaviorGB18030",
        @"RegionalBehaviorGoogleMail",
        @"RegionalBehaviorNTSC",
        @"RegionalBehaviorNoPasscodeLocationTiles",
        @"RegionalBehaviorNoVOIP",
        @"RegionalBehaviorNoWiFi",
        @"RegionalBehaviorShutterClick",
        @"RegionalBehaviorVolumeLimit",
        @"ActiveWirelessTechnology",
        @"WifiAddress",
        @"WifiAddressData",
        @"WifiVendor",
        @"FaceTimeBitRate2G",
        @"FaceTimeBitRate3G",
        @"FaceTimeBitRateLTE",
        @"FaceTimeBitRateWiFi",
        @"FaceTimeDecodings",
        @"FaceTimeEncodings",
        @"FaceTimePreferredDecoding",
        @"FaceTimePreferredEncoding",
        @"DeviceSupportsFaceTime",
        @"DeviceSupportsTethering",
        @"DeviceSupportsSimplisticRoadMesh",
        @"DeviceSupportsNavigation",
        @"DeviceSupportsLineIn",
        @"DeviceSupports9Pin",
        @"DeviceSupports720p",
        @"DeviceSupports4G",
        @"DeviceSupports3DMaps",
        @"DeviceSupports3DImagery",
        @"DeviceSupports1080p",
    ];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *item in list) {
        NSString *result =  [self mgCopyAnserForKey:item];
        dic[item] = result;
    }
    return [dic copy];
}

-(id)mgCopyAnserForKey:(NSString *)key {
    NSDictionary *dict = [NSDictionary dictionary];
    CFDictionaryRef options = (__bridge CFDictionaryRef)dict;
    
    setreuid(0, 0);// 获取root权限
    CFStringRef question = (__bridge CFStringRef)key;
    CFStringRef value = MGCopyAnswer(question, options);
    NSString *value_str = (__bridge_transfer NSString *)value;
    setreuid(501, 0);// 取消root权限
    NSLog(@"%@:%@",key,value);
    return value_str;
}

@end
