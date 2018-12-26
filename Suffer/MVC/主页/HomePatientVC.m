//
//  HomePatientVC.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/5.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "HomePatientVC.h"
#import "HomeButtonMenuView.h"

#import <SDCycleScrollView/SDCycleScrollView.h>
#import "HomePatientCell.h"
#import "EmergencymapVC.h"
#import "AppAlertController.h"
#import "HomeTableHeaderFooterView.h"

#import "HomeBannerRequstModel.h"
#import "HomeNewsColumnRequestModel.h"
#import "HomeNewsPageRequestModel.h"
#import "SufferLoginManage.h"
#import "AppAlertView.h"
#import "BaseWebVC.h"
#import "UrgencyVC.h"
#import "MoreServiceVC.h"



@interface HomePatientVC ()
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
//@property (nonatomic, strong) UIView *bottomTitleView;
//@property (nonatomic, strong) NSMutableArray *bottomButtons;
//@property (nonatomic, strong) UIView *bottomTitleLine;
//@property (nonatomic, assign) NSInteger bottomSelectIndex;
//@property (nonatomic, assign) NSString * newsSelectedID;

@property (nonatomic, assign) NSInteger newsSelectIndex;

@property (nonatomic, strong) HomeBannerResultModel * bannerModel;     //
@property (nonatomic, strong) HomeNewsColumnResultModel * newsModel;     //
@property (nonatomic, strong) NSMutableDictionary <NSString *,HomeNewsPageResultModel *>*newsListModelDic;
//@property (nonatomic, strong) HomeNewsPageResultModel * newsListModel;     //
@property (nonatomic,strong) HomeTableHeaderFooterView *sectionHeaderView;
@end

@implementation HomePatientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createViews];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self allRequest];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = (id<UINavigationControllerDelegate>)self;
}
-(void)reloadData{
    NSMutableArray *bannerImages = [NSMutableArray array];
    for (HomeBannerResultSubModel *subModel in self.bannerModel.list){
        [bannerImages addObject:[NSString stringWithFormat:@"%@",subModel.picture]];
    }
    self.cycleScrollView.imageURLStringsGroup = bannerImages;
    [self.mainTableView reloadData];
}
-(NSMutableDictionary *)newsListModelDic{
    if(!_newsListModelDic){
        _newsListModelDic = [NSMutableDictionary dictionary];
    }
    return _newsListModelDic;
}
-(void)createViews{
    LRWeakSelf;
    registerNibWithCellName(self.mainTableView, @"HomePatientCell");
    [self.mainTableView registerClass:[HomeTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HomeTableHeaderFooterView"];
   
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mainTableView.mj_header endRefreshing];
        [weakSelf.mainTableView.mj_footer endRefreshing];
        [self allRequest];
    }];

    

    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
//    _cycleScrollView = [UIView new];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*SCREEN_WIDTH/375.0) imageURLStringsGroup:nil];
//    _cycleScrollView.imageURLStringsGroup = @[@"https://media1.rrl360.com/product/0001/31/thumb_30592_default.jpg@!p_m_h_300.jpg",@"https://media1.rrl360.com/product/0001/69/thumb_68825_default.jpg@!p_m_h_300.jpg",@"https://media1.rrl360.com/product/0001/69/thumb_68625_default.jpg",@"https://media1.rrl360.com/product/0001/62/thumb_61494_default.jpg"];
    _cycleScrollView.placeholderImage =  [UIImage imageNamed: @"icon_01"];
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;

    _cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
//    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:_cycleScrollView];
//    LRWeakSelf;
//    _cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(clickImageWithData:)]) {
//            [weakSelf.delegate clickImageWithData:weakSelf.model.data[currentIndex]];
//        }
//    };
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(160*SCREEN_WIDTH/375.0);
    }];

    
    HomeButtonMenuView *buttonsView= [HomeButtonMenuView new];
    [self.headView addSubview:buttonsView];
    buttonsView.backgroundColor = [UIColor whiteColor];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        
        make.height.mas_equalTo(200);
        make.top.mas_equalTo(self.cycleScrollView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
        [buttonsView createSubviewsWithImageNames:@[@"icon_02",@"icon_03",@"icon_04",@"icon_05",@"icon_06",@"icon_07"] titles:@[@"视频医生",@"紧急就医",@"就医绿通",@"专家视频",@"线下就诊",@"更多"]ret:^(NSInteger selectIndex) {
            if(selectIndex == 0){
                [weakSelf verifyIsVipShowAlert:^{
                    [weakSelf pushViewController:[EmergencymapVC new]];
                }];
            }
            else if(selectIndex ==1){
                UrgencyVC *vc = [UrgencyVC new];
                vc.type = @"紧急就医";
                [weakSelf pushViewController:vc];
//                [weakSelf pushViewController:@"UrgencyVC"];

//                [weakSelf pushViewController:@"VideoEvaluationVC"];
            }
            else if(selectIndex == 2){
                MoreServiceVC *vc = [MoreServiceVC new];
                vc.greenChanel = 1;
                [weakSelf pushViewController:vc];
//                [weakSelf pushViewController:@"MoreServiceVC"];
            }
            else if(selectIndex == 3){
                [weakSelf pushViewController:[ ExpertSearchVC new]];
            }
            else if (selectIndex == 4){
                [weakSelf pushViewController:[ExpertDetailVC new]];
            }
            else if (selectIndex == 5){
                MoreServiceVC *vc = [MoreServiceVC new];
                vc.greenChanel = 0;
                [weakSelf pushViewController:vc];
//                [weakSelf pushViewController:@"ExpertListVC"];
//                [weakSelf pushViewController:@"MessageListVC"];
//                [weakSelf pushViewController:@"MyApplyListVC"];

            }
            
        
    }];
    CGFloat height = [self.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.headView.bounds;
    frame.size.height = height;
    self.headView.frame = frame;
    self.mainTableView.tableHeaderView = self.headView;

}

-(HomeTableHeaderFooterView *)sectionHeaderView{
    if(!_sectionHeaderView){
        HomeTableHeaderFooterView *view = [self.mainTableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeTableHeaderFooterView"];
        NSMutableArray *newsTitles = [NSMutableArray array];
        for (HomeNewsColumResultSubModel *subModel in self.newsModel.data){
            [newsTitles addObject:subModel.typeName];
        }
        view.titles = newsTitles;
        view.headerDelegate = (id<HomeTableFooterViewDelegate>)self;
        _sectionHeaderView = view;
    }
    return _sectionHeaderView;
}
-(void)verifyIsVipShowAlert:(void (^)(void))vipDo{

    
    [SufferLoginManage verifyIsVipBack:^(BOOL isVip) {
        if(!isVip){
            [AppAlertView createAppAlertViewWithTitle:@"您还不是VIP会员，是否开通授权" leftButtonTitle:@"暂不开通" rightButtonTitle:@"开通" clickBack:^(NSInteger index) {
                NSLog(@"you click %ld",(long)index);
                if(index == 1){
                    [self pushViewController:[ MemberBuyVC new]];
                }
            }];
        }
        else{
            if(vipDo){
                vipDo();
            }
        }

    }];

    //    BOOL isVip = [SufferLoginManage verifyIsVip];
    
}
//-(void)showAlert{
//    AppAlertController *alertController = [AppAlertController alertControllerWithTitle:@"您还不是VIP会员，是否开通授权" message:nil buttonTitles:@[@"暂不开通"] handler:^(NSInteger index) {
//        NSLog(@"you click %ld",(long)index);
//    }];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}

//-(void)bottomButtonClick:(UIButton *)button{
//    self.bottomSelectIndex = button.tag;
//    LRWeakSelf;
////    [self.view setNeedsUpdateConstraints];
//    [_bottomTitleLine mas_remakeConstraints:^(MASConstraintMaker *make) {
//        UIButton *button =weakSelf.bottomButtons[weakSelf.bottomSelectIndex];
//        make.centerX.mas_equalTo(button);
//        make.height.mas_equalTo(4);
//        make.width.mas_equalTo(button.titleLabel.mas_width);
//        make.top.mas_equalTo(button.mas_bottom);
//    }];
//    for (UIButton *but in self.bottomButtons){
//        but.selected = (but==button);;
//    }
//    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:0 animations:^{
//        [weakSelf.bottomTitleLine.superview layoutIfNeeded];
//    }completion:nil];
//
//
//}
#pragma mark -  request
//数据请求
-(void)allRequest{
    [self requestBanner];
    [self requestNews];
    [[CommonManage shareInstance] goodsPageResultModel];

}

-(void)requestBanner{
    LRWeakSelf;
    HomeBannerRequstModel *requestModel = [HomeBannerRequstModel new];
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof BaseResultModel *dataModel, NSString *jsonObjc) {
        weakSelf.bannerModel = dataModel;
        [weakSelf reloadData];
        [weakSelf.mainTableView.mj_header endRefreshing];

    }];
}

-(void)requestNews{
    LRWeakSelf;
    HomeNewsColumnRequestModel *requestModel = [HomeNewsColumnRequestModel new];
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success,  HomeNewsColumnResultModel *dataModel, NSString *jsonObjc) {
        weakSelf.newsModel = dataModel;
        if(self.newsModel.data.count > self.newsSelectIndex){
            NSString *type = [self.newsModel.data[self.newsSelectIndex] typeCode];
            [weakSelf requestNewsListWithType:type  isRefresh:YES];

        }
        weakSelf.sectionHeaderView = nil;
        [weakSelf reloadData];
        [weakSelf.mainTableView.mj_header endRefreshing];
        [weakSelf.mainTableView.mj_footer endRefreshing];


    }];
}

-(void)requestNewsListWithType:(NSString *)type isRefresh:(BOOL)isRefresh{
    LRWeakSelf;
    HomeNewsPageRequestModel *requestModel = [HomeNewsPageRequestModel new];
    requestModel.pageNo = 0;
    requestModel.pageSize = 10;
//    if(self.newsModel.data.count > self.newsSelectIndex){
//        requestModel.search_EQ_column = [self.newsModel.data[self.newsSelectIndex] typeCode];
//    }
    requestModel.search_EQ_column = type;
    requestModel.sortInfo = @"DESC_createDate";
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof HomeNewsPageResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            NSMutableArray *list = weakSelf.newsListModelDic[type].list;
            NSMutableArray *newList = [NSMutableArray array];
            if(!isRefresh){
                [newList addObjectsFromArray:list];
            }
            [newList addObjectsFromArray:dataModel.list];
            dataModel.list = newList;
            [weakSelf.newsListModelDic setObject:dataModel forKey:type];
            
    //        weakSelf.newsListModel = dataModel;
            [weakSelf reloadData];
            [weakSelf.mainTableView.mj_header endRefreshing];
        }
    }];
}

-(NSString *)curNewsTypeCode{
    NSString *type;
    NSArray <HomeNewsColumResultSubModel *>*types = self.newsModel.data;
    if(types.count > self.self.newsSelectIndex){
        HomeNewsColumResultSubModel *typeModel  = types[self.newsSelectIndex];
        type = typeModel.typeCode;
        return type;
    }
    return nil;
}
//取出请求到的新闻列表
-(NSArray *)curNewsList{
    NSString *type;
    NSArray <HomeNewsColumResultSubModel *>*types = self.newsModel.data;
    if(types.count > self.self.newsSelectIndex){
        HomeNewsColumResultSubModel *typeModel  = types[self.newsSelectIndex];
        type = typeModel.typeCode;
        return self.newsListModelDic[type].list;
    }
    return nil;
}
#pragma mark - HomeTableHeaderFooterDelegate
-(void)headerClickIndex:(NSInteger)index{
    NSInteger lastIndex = self.newsSelectIndex;
    self.newsSelectIndex = index;
    if([self curNewsList].count == 0){
        [self requestNewsListWithType:[self curNewsTypeCode] isRefresh:YES];
    }

    [self.mainTableView reloadData];

    NSArray *cells = self.mainTableView.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        CGFloat ff = 0;
        if(lastIndex < index){
            ff = SCREEN_WIDTH;
        }
        else if(lastIndex >index){
            ff = -SCREEN_WIDTH;
        }
        else{
            ff = 0;
        }
//        if (i%2 == 0) {
//            cell.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH,0);
//        }else {
//            cell.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH,0);
//        }
        cell.transform = CGAffineTransformMakeTranslation(ff,0);

        [UIView animateWithDuration:0.3 delay:i*0.03*0 usingSpringWithDamping:0.7 initialSpringVelocity:1/0.75 options:0 animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
}

#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self curNewsList].count-arc4random()%2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomePatientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePatientCell"];
    HomeNewsPageResultSubModel *model = [self curNewsList][indexPath.row];
    cell.topLabel.text = model.title;
    cell.bottonLabel.text = model.endTimeTranslate;
    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] ];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView  viewForHeaderInSection:(NSInteger)section{
    self.sectionHeaderView.selectIndex = self.newsSelectIndex;
    return self.sectionHeaderView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNewsPageResultSubModel *model = [self curNewsList][indexPath.row];
    BaseWebVC *vc = [BaseWebVC new];
//    [vc.webview loadHTMLString:model.content baseURL:nil];
    vc.content = model.content;
    [self pushViewController:vc];
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

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
    
    if(viewController == self){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        
        //系统相册继承自 UINavigationController 这个不能隐藏 所有就直接return
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            return;
        }
        
        //不在本页时，显示真正的navbar
        [navigationController setNavigationBarHidden:NO animated:YES];
        //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
        //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
        if(navigationController.delegate == (id<UINavigationControllerDelegate>)self){
            //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
            navigationController.delegate = nil;
        }
    }
}
@end
