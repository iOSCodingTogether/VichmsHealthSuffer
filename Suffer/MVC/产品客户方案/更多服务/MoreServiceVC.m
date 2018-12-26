//
//  MoreServiceVC.m
//  Suffer
//
//  Created by  licc on 2018/9/1.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "MoreServiceVC.h"
#import "GoodsPageRequestModel.h"
#import "UrgencyVC.h"

@interface MoreServiceVC ()
@property (nonatomic, strong) NSArray<GoodsPageResultSubModel *> * resultModelList;     //

@end

@implementation MoreServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"更多服务";
//    self.dataSourceArray = @[@"紧急就医",@"住院服务",@"高端体检",@"功能体检",@"体检报告"];
//    self.dataSourceImageArray = @[@"icon_16",@"icon_17",@"icon_18",@"icon_19",@"icon_20"];
    [self request];
}
-(void)request{
//    GoodsPageRequestModel *model = [GoodsPageRequestModel new];
//    model.sortInfo = @"DESC_createDate";
//    [BaseRequest requestWithRequestModel:model ret:^(BOOL success,  GoodsPageResultModel *dataModel, NSString *jsonObjc) {
//        if(dataModel.success){
//            self.resultModel = [dataModel channelListModel:self.greenChanel];
//            [self reloadData];
//        }
//    }];
    [CommonManageInstance goodsPageResultModelBack:^(GoodsPageResultModel * _Nonnull goodsPageResultModel) {
        self.resultModelList = [goodsPageResultModel channelListModel:self.greenChanel];
        [self reloadData];
    }];
}
-(void)reloadData{
    if(self.greenChanel == 0){
        self.title = @"更多服务";
    }
    else{
        self.title = @"就医绿通";
    }
    self.dataSourceArray = [NSMutableArray array];
    self.dataSourceImageArray = [NSMutableArray array];

    for (NSInteger i =0; i<self.resultModelList.count; i++) {
        GoodsPageResultSubModel *subModel = self.resultModelList[i];
        [self.dataSourceImageArray addObject:[NSString stringWithFormat:@"%@", subModel.logoPicture]];
        [self.dataSourceArray addObject:[NSString stringWithFormat:@"%@", subModel.goodsTypeName]];

    }
    [self.mainTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)didSelectIndexPath:(NSIndexPath *)indexPath{
    DLog(@"");
    GoodsPageResultSubModel *subModel = self.resultModelList[indexPath.row];
    UrgencyVC *vc = [UrgencyVC new];
    vc.type = subModel.goodsTypeName;
    [self pushViewController:vc];
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
