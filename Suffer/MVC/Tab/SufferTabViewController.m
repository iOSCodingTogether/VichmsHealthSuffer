//
//  SufferTabViewController.m
//  Suffer
//
//  Created by  licc on 2018/9/9.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "SufferTabViewController.h"
#import "SufferLoginManage.h"
#import "AppUserDefaults.h"
#import "ScrollTabBarAnimator.h"
#import "BaseNavViewController.h"
#if defined(DEBUG)||defined(_DEBUG)

#import <JPFPSStatus/JPFPSStatus.h>
#import "HomePatientVC.h"
#import "MomentViewController.h"
#import "MyApplyListVC.h"
#import "PatientCenterVC.h"

#endif


@interface SufferTabViewController ()<UITabBarControllerDelegate>



@end

@implementation SufferTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
#if defined(DEBUG)||defined(_DEBUG)
    [[JPFPSStatus sharedInstance] open];
    [self.view addSubview:[JPFPSStatus sharedInstance].fpsLabel];
#endif

}
-(void)initVCs{
    NSArray *viewConntrollers= @[[HomePatientVC new],[MomentViewController new],[MyApplyListVC new],[PatientCenterVC new]];
    
    NSMutableArray *childViewControllers = [NSMutableArray array];
    for (int i = 0; i < viewConntrollers.count; i++) {
        id vcobj = viewConntrollers[i];
        UIViewController* vc = vcobj;
       
        
        BaseNavViewController * navViewController = [[BaseNavViewController alloc] initWithRootViewController:vc];
        UITabBarItem *item =
        [[UITabBarItem alloc]initWithTitle:@[@"首页",@"论坛",@"我的预约",@"个人信息"][i]
                                     image:
         [[UIImage imageNamed:@[@"icon_09",@"icon_11",@"icon_13",@"icon_15",@""][i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                             selectedImage:
         [[UIImage imageNamed:@[@"icon_08",@"icon_10",@"icon_12",@"icon_14",@"icon_08"][i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        navViewController.tabBarItem = item;
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:LR_NORMALCOLOR} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:LR_MAINCOLOR} forState:UIControlStateSelected];
        [childViewControllers addObject:navViewController];
    }
    self.viewControllers = childViewControllers;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
    NSLog(@"shouldSelectViewController");
//    LR_USER_DEFAULTS.loginTest = @"";
    
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
//    for (NSInteger i =0; i<tabBarController.viewControllers.count; i++) {
//        UIViewController *vc = tabBarController.viewControllers[i];
//        if(viewController == vc){
//            index = i;
//            break;
//        }
//    }
 
    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.75;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.type = kCATransitionPush;
//    if (tabBarController.selectedIndex > index) {
//        animation.subtype = kCATransitionFromLeft;
//    } else {
//        animation.subtype = kCATransitionFromRight;
//    }
//    // 与百度上一般文章不一样
////    [[[tabBarController valueForKey:@"_viewControllerTransitionView"] layer] addAnimation:animation forKey:@"animation"];
////    [tabBarController.view.layer addAnimation:animation forKey:@"reveal"];

    
   
    
    
    if(index == 0){
        return YES;
    }
    else{
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 动画 实现协议方法
- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    ScrollTabBarAnimator *tabBarAnimator = [[ScrollTabBarAnimator alloc] init];

//    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
//    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
//    tabBarAnimator.tabScrollDirection = (toIndex < fromIndex) ? TabLeftDirection: TabRightDirection;
    return tabBarAnimator;

    
}


@end
