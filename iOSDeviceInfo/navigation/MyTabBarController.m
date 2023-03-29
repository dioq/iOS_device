//
//  MyTabBarController.m
//  TabBarController
//
//  Created by William on 2018/10/19.
//  Copyright © 2018年 William. All rights reserved.
//

#import "MyTabBarController.h"
#import "SoftwareViewController.h"
#import "MyNavgationController.h"
#import "HardwareViewController.h"
#import "NetworkViewController.h"
#import "ExtensionViewController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    [self addOneViewController:[[SoftwareViewController alloc] init] image:@"tab_mine_normal" selectedImage:@"tab_mine_50" title:@"软件信息"];
    [self addOneViewController:[[HardwareViewController alloc] init] image:@"tab_home_normal" selectedImage:@"tab_home_50" title:@"硬件信息"];
    [self addOneViewController:[[NetworkViewController alloc] init] image:@"tab_c2c_normal" selectedImage:@"tab_c2c_50" title:@"网络信息"];
    [self addOneViewController:[[ExtensionViewController alloc] init] image:@"tab_team_normal" selectedImage:@"tab_team_50" title:@"私有API"];
    
    [self setBackgroudColor];
}

// 设置背景颜色
-(void)setBackgroudColor {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
    if (@available(iOS 13,*)) {
        backView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    } else {
        backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
}

//添加一个子控制器的方法
- (void)addOneViewController:(UIViewController *)childViewController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title {
    MyNavgationController *nav = [[MyNavgationController alloc] initWithRootViewController:childViewController];
    
    // 设置图片和文字之间的间距
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    
    // 1.1.1 设置tabBar文字
    nav.tabBarItem.title = title;
    // 1.1.2 设置正常状态下的图标
    if (imageName.length) { // 图片名有具体
        nav.tabBarItem.image =  [self oriRenderingImage:imageName];//[UIImage imageWithOriRenderingImage:imageName];
        // 1.1.3 设置选中状态下的图标
        nav.tabBarItem.selectedImage = [self oriRenderingImage:selectedImageName];//[UIImage imageWithOriRenderingImage:selectedImageName];
    }
    
    // 1.1.5 添加tabBar为控制器的子控制器
    [self addChildViewController:nav];
}
//获取原始图片
-(UIImage *)oriRenderingImage:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
