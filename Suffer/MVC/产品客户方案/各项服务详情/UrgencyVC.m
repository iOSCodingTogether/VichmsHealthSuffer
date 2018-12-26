//
//  UrgencyVC.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/12.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "UrgencyVC.h"
#import "PageButtonView.h"
#import "AppDefine.h"
//#import "GoodsFindByGoodsTypeRequestModel.h"
#import "GoodsDetailPageRequestModel.h"


@interface UrgencyVC ()<UIScrollViewDelegate,PageButtonViewwDelegate>
@property (nonatomic, strong) UIImageView  * imageView;     //

@property (nonatomic, strong) PageButtonView * buttonsView;     //
@property (nonatomic, strong) UILabel  * label0;     //
@property (nonatomic, strong) UILabel  * label1;     //
@property (nonatomic, strong) UILabel  * label2;     //
@property (nonatomic, strong) UIScrollView  * scrollView;     //
//@property (nonatomic, strong) GoodsFindByGoodsTypeResultModel *goodsResultModel;
@property (nonatomic, strong) GoodsPageResultSubModel * goodsTypeSubModel;     //

@property (nonatomic, strong) GoodsDetailPageResultModel *goodsDetailModel;

@end

@implementation UrgencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self reloadData];
    [self request];
}

-(void)createView{
    self.title =@"住院服务";
//    UIButton *barButton =[UIButton new];
//    [barButton setTitle:@"北京市" forState:UIControlStateNormal];
//    [barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [barButton setImage:[UIImage imageNamed: @"icon_23"] forState:UIControlStateNormal];
//    [barButton sizeToFit];
//    [barButton addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:barButton];
//    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.imageView = [UIImageView new];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];
    
    self.buttonsView = [PageButtonView new];
    [self.contentView addSubview:self.buttonsView];
    self.buttonsView.delegate = self;
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
  
    UIScrollView *scrollview =[[UIScrollView alloc]initWithFrame:CGRectMake(00, 0, 100, 100)];
    self.scrollView = scrollview;
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    [self.contentView addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonsView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.label0 = [[UILabel alloc]init];
    [scrollview addSubview:self.label0];
    self.label0.numberOfLines = 0;
    self.label1 = [[UILabel alloc]init];
    [scrollview addSubview:self.label1];
    self.label1.numberOfLines = 0;

    self.label2 = [[UILabel alloc]init];
    [scrollview addSubview:self.label2];
    self.label2.numberOfLines = 0;
    
    [self.label0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView);
    }];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label0.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView);
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label1.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView);
        make.right.mas_equalTo(0);
    }];
    UIButton *nextButton = [UIButton new];
    [self.contentView addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-20);
    }];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    LR_BUTTON_STYLE(nextButton);
}
-(void)request{
    
    
    LRWeakSelf;
//        GoodsFindByGoodsTypeRequestModel *requestModel = [GoodsFindByGoodsTypeRequestModel new];
//        requestModel.type = self.type;//视频医生=1
//        [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof GoodsFindByGoodsTypeResultModel *dataModel, NSString *jsonObjc) {
//            if(dataModel.success){
//                weakSelf.goodsResultModel = dataModel;
//                [weakSelf requestPage];
//                [weakSelf reloadData];
//
//            }
//        }];
    [CommonManageInstance goodsPageResultModelBack:^(GoodsPageResultModel * _Nonnull goodsPageResultModel) {
        self.goodsTypeSubModel = [goodsPageResultModel findBygoodsTypeName:self.type];
        [self requestPage];
        [self reloadData];
    }];
    
}

-(void)requestPage{
    LRWeakSelf;
    GoodsDetailPageRequestModel *requestModel = [GoodsDetailPageRequestModel new];
    requestModel.search_EQ_goodsInfoId = self.goodsTypeSubModel.id;
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof GoodsDetailPageResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            weakSelf.goodsDetailModel = dataModel;
            [weakSelf reloadData];
            
        }
    }];
    
}
-(void)reloadData{
    

//    self.title = self.goodsTypeSubModel.goodsType;
    self.title = self.type;
//    self.imageView.image = [UIImage imageNamed:@"icon_01"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:/*[NSString stringWithFormat:@"http://www.erpside.com/%@",self.goodsTypeSubModel.picture]*/self.goodsTypeSubModel.picture] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(error ==nil){
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.height.mas_equalTo(self.imageView.mas_width).multipliedBy(image.size.height/(float)image.size.width);
            }];
        }
    }];
    [self.buttonsView setSubButtons:@[@"服务内容",@"预约须知",@"服务评价"]];
    
    for(GoodsDetailPageResultSubModel *model in self.goodsDetailModel.list){
        if(model.goodsDetailsType.integerValue ==1){
            self.label0.text = model.goodsDes;
        }
        if(model.goodsDetailsType.integerValue ==2){
            self.label1.text = model.goodsDes;
        }
        if(model.goodsDetailsType.integerValue ==3){
            self.label2.text = model.goodsDes;
        }
    }
//    self.label0.text =@"0在紧急时刻帮助客户解决健康问题，使客户及时得到有效治疗0";
//    self.label1.text = [NSString stringWithFormat:@"按次收费，每次%@元",self.goodsResultModel.fee];
////    self.label1.text =@"1在紧急时刻帮助客户解决健康问题，使客户及时得到有效治疗1";
//    self.label2.text =@"2在紧急时刻帮助客户解决健康问题，使客户及时得到有效治疗2";

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat floatPage = scrollView.contentOffset.x/(float)scrollView.frame.size.width;
    [self.buttonsView scrollToPage :floatPage];
    CGPoint offset = self.scrollView.contentOffset;
    NSLog(@"offsetx = %.2f",offset.x);

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat floatPage = scrollView.contentOffset.x/(float)scrollView.frame.size.width;
    [self.buttonsView scrollToPage :floatPage];
    CGPoint offset = self.scrollView.contentOffset;
    NSLog(@"offsetx = %.2f",offset.x);

}

- (void)pageButtonViewDidselect:(NSInteger)index{
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = index *self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
    
}


-(void)rightItemClick:(UIButton *)button{
    
    [button setTitle:@"北京市00000000" forState:UIControlStateNormal];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightitem;
    DLog(@"");
    
 
    
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
