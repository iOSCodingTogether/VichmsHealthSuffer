//
//  GreenChannelVC.m
//  Suffer
//
//  Created by  licc on 2018/8/31.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "GreenChannelVC.h"

@interface GreenChannelVC ()

@end

@implementation GreenChannelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"就医绿通";
    self.dataSourceArray = @[@"预约专家",@"住院服务",@"大影像"];
    self.dataSourceImageArray = @[@"icon_22",@"icon_17",@"icon_21"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)didSelectIndexPath:(NSIndexPath *)indexPath{
    DLog(@"");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
