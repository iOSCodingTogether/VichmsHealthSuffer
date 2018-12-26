//
//  EmergencymapVC.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/8.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "EmergencymapVC.h"
#import <MapKit/MapKit.h>
#import "MapCollectionView.h"

@interface EmergencymapVC ()
@property(strong, nonatomic) MKMapView *mapview;
@end

@implementation EmergencymapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    
}

-(void)createViews{
    self.mapview = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.mapview];
    MapCollectionView *v= [[MapCollectionView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-30, 200)];
    [self.view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(100);
    }];
    [v createViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
