//
//  ExpertsReservationVC.m
//  Suffer
//
//  Created by  licc on 2018/8/28.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "OrderCreateVC.h"
#import "CommonCell0.h"
#import "CollectionTableViewCell.h"
#import "CommonTextViewTableViewCell.h"
#import "OrderCreateRequestModel.h"
#import "BRPickerView.h"
#import "NSDate+CCategory.h"
#import "TZImagePickerController.h"
#import "IMageOrVideoModel.h"
#import <VideoToolbox/VideoToolbox.h>

@interface OrderCreateVC ()
@property (nonatomic, strong) UIView * genderView;     //
@property (nonatomic, strong) UIButton * maleButton;     //
@property (nonatomic, strong) UIButton * femaleButton;     //
@property (nonatomic, strong) NSMutableArray<IMageOrVideoModel *> * imagesModelArr;     //
@property (nonatomic, strong) NSMutableArray<IMageOrVideoModel *> * videosModelArr;     //

@end

@implementation OrderCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    [self reloadData];


}

-(void)reloadData{
    [self.mainTableView reloadData];
    self.femaleButton.selected = NO;
    self.maleButton.selected = YES;
}

-(NSMutableArray <IMageOrVideoModel *>*)imagesModelArr{
    if(!_imagesModelArr){
        _imagesModelArr = [NSMutableArray array];
    }
    return _imagesModelArr;
}
-(NSMutableArray <IMageOrVideoModel *>*)videosModelArr{
    if(!_videosModelArr){
        _videosModelArr = [NSMutableArray array];
    }
    return _videosModelArr;
}
-(void)createViews{
    self.title = @"预约专家";
    registerNibWithCellName(self.mainTableView, @"CommonCell0");
    registerNibWithCellName(self.mainTableView, @"CollectionTableViewCell");
    registerNibWithCellName(self.mainTableView, @"CommonTextViewTableViewCell");
    self.mainTableView.estimatedRowHeight = 80;

    
    self.mainTableView.backgroundColor = LR_TABLE_BACKGROUNDCOLOR;
    self.genderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    UILabel *maleLabel = [UILabel new];
    [self.genderView addSubview:maleLabel];
    maleLabel.text = @"男";
    
    self.maleButton = [UIButton new];
    [self.genderView addSubview:self.maleButton];
    [self.maleButton setImage:LRSTRING2IMAGE(@"icon_31") forState:UIControlStateNormal];
    [self.maleButton setImage:LRSTRING2IMAGE(@"icon_32") forState:UIControlStateSelected];
    
    
    
    UILabel *femaleLabel = [UILabel new];
    [self.genderView addSubview:femaleLabel];
    femaleLabel.text = @"女";
    
    self.femaleButton = [UIButton new];
    [self.genderView addSubview:self.femaleButton];
    [self.femaleButton setImage:LRSTRING2IMAGE(@"icon_31") forState:UIControlStateNormal];
    [self.femaleButton setImage:LRSTRING2IMAGE(@"icon_32") forState:UIControlStateSelected];
    
    [maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(maleLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(62/3.0);
    }];
    [femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.maleButton.mas_right).offset(12);
        make.centerY.mas_equalTo(0);
    }];
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(femaleLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(62/3.0);
    }];
    UIView *bottomView = [self crecteBottomViewContainButtonWithTitle:@"预约专家" action:@selector(bottomButtonAction:)];
    self.mainTableView.tableFooterView = bottomView;
    self.maleButton.tag =1;
    self.femaleButton.tag = 0;
    [self.maleButton addTarget:self action:@selector(userSexSet:) forControlEvents:UIControlEventTouchUpInside];
    [self.femaleButton addTarget:self action:@selector(userSexSet:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)userSexSet:(UIButton *)btn{
    if(btn.tag == 0){
        self.orderCreateModel.personSex = @"0";
    }
    else{
        self.orderCreateModel.personSex = @"1";
    }
    [self reloadData];
    
}
-(void)bottomButtonAction:(UIButton *)action{
    DLog(@"");
    [self requestPost];
    
}


#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 7;
    }
    else if(section == 1){
        return 1;
    }
    else if(section == 2){
        return 4;
    }
    else if(section == 3){
        return 1;
    }
    else if(section == 4){
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 44;
    }
    else if(indexPath.section == 1){
        return 80;
    }
    else if(indexPath.section == 2){
        return 44;
    }
    else if(indexPath.section == 3){
//        return 80;
        return UITableViewAutomaticDimension;

    }
    else if(indexPath.section == 4){
//        return 80;
        return UITableViewAutomaticDimension;

    }
    return 44;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 200)];
    UILabel *label = [UILabel new];
    [view addSubview:label];
    label.text = @[@"患者信息",@"并请介绍",@"就诊信息",@"病例图片",@"病理视频"][section];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
    }];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LRWeakSelf
    if(indexPath.section == 0||indexPath.section == 2){
        CommonCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell0"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightButton.hidden = YES;
        if(self.genderView.superview == cell){
            [self.genderView removeFromSuperview];
        }
        if(indexPath.section == 0){
            if(indexPath.row ==0){
                cell.label0.text = @"与患者关系：";
//                cell.textField.text = @"本人";
                NSArray *selectArr =@[@"本人",@"家属",@"朋友",@"同事"];
                cell.textField.text = selectArr[self.orderCreateModel.relative.integerValue-1];
                cell.textField.placeholder = @"";
                cell.textField.userInteractionEnabled = NO;
                [cell.rightButton setImage:[UIImage imageNamed:@"icon_24"] forState:UIControlStateNormal];
                cell.rightButton.hidden = NO;
               

            }
            else if(indexPath.row == 1){
                cell.label0.text = @"类型：";
//                cell.textField.text = @"第一次就诊";
                NSArray *selectArr =@[@"第一次就诊",@"复诊"];
                cell.textField.text = selectArr[self.orderCreateModel.orderType.integerValue-1];
                
                cell.textField.placeholder = @"";
                cell.textField.userInteractionEnabled = NO;
                [cell.rightButton setImage:[UIImage imageNamed:@"icon_24"] forState:UIControlStateNormal];
                cell.rightButton.hidden = NO;
                
               

            }
            else if(indexPath.row == 2){
                cell.label0.text = @"姓名：";
//                cell.textField.text = @"";
                cell.textField.text = weakSelf.orderCreateModel.personName;
                [cell.textField addActiontextFieldChanged:^(UITextField *textField) {
                    weakSelf.orderCreateModel.personName = textField.text;
                }];
                cell.textField.placeholder = @"请输入姓名";
                cell.textField.userInteractionEnabled = YES;

            }
            else if(indexPath.row == 3){
                cell = (CommonCell0 *)[[[NSBundle mainBundle] loadNibNamed:@"CommonCell0" owner:nil options:nil] lastObject];

                cell.label0.text = @"性别";
//                cell.textField.text = @"";
//                cell.textField.text = @[@"女",@"男",@"",@""][self.orderCreateModel.personSex.integerValue];
                cell.textField.text = @"";
                cell.textField.placeholder = @"";
                cell.textField.userInteractionEnabled = NO;
                [cell addSubview:self.genderView];
                [self.genderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(0);
                    make.left.mas_equalTo(cell.label0.mas_right);
                    make.width.mas_equalTo(200);
                }];
                if(self.orderCreateModel.personSex.integerValue == 0){
                    self.maleButton.selected = NO;
                    self.femaleButton.selected =YES;
                }
                else{
                    self.maleButton.selected = YES;
                    self.femaleButton.selected =NO;
                }

            }
            else if(indexPath.row == 4){
                cell.label0.text = @"年龄：";
//                cell.textField.text = @"";
                cell.textField.text = self.orderCreateModel.personAge;
                [cell.textField addActiontextFieldChanged:^(UITextField *textField) {
                    weakSelf.orderCreateModel.personAge = textField.text;
                }];
                cell.textField.placeholder = @"请输入年龄";
                cell.textField.userInteractionEnabled = YES;

            }
            else if(indexPath.row == 5){
                cell.label0.text = @"手机号：";
//                cell.textField.text = @"";
                cell.textField.text = self.orderCreateModel.personPhone;
                [cell.textField addActiontextFieldChanged:^(UITextField *textField) {
                    weakSelf.orderCreateModel.personPhone = textField.text;
                }];
                cell.textField.placeholder = @"请输入手机号";
                cell.textField.userInteractionEnabled = YES;
            }
            else if(indexPath.row == 6){
                cell.label0.text = @"身份证号：";
//                cell.textField.text = @"";
                cell.textField.text = self.orderCreateModel.personIdCard;
                [cell.textField addActiontextFieldChanged:^(UITextField *textField) {
                    weakSelf.orderCreateModel.personIdCard = textField.text;
                }];
                cell.textField.placeholder = @"请输入身份证号";
                cell.textField.userInteractionEnabled = YES;
            }
        }
        else if(indexPath.section == 2){
            if(indexPath.row ==0){
                cell.label0.text = @"就诊时间：";
                cell.textField.text = @"";
                if(self.orderCreateModel.visitTime.length >0)
                {
                    cell.textField.text = LRTimeIntervalFromToFormatter(self.orderCreateModel.visitTime, @"yyyy-MM-dd'T'HH:mm:ss.SSSZ", @"yyyy-MM-dd HH:mm");
                }
//                cell.textField.text = self.orderCreateModel.visitTime;
                cell.textField.placeholder = @"请选择就诊时间";
                cell.textField.userInteractionEnabled = NO;
                [cell.rightButton setImage:[UIImage imageNamed:@"icon_33"] forState:UIControlStateNormal];
                cell.rightButton.hidden = NO;
               
                
            }
            else if(indexPath.row == 1){
                cell.label0.text = @"预约专家：";
//                cell.textField.text = @"陈欣";
                cell.textField.text = self.orderCreateModel.Doctor;
                cell.textField.placeholder = @"";
                cell.textField.userInteractionEnabled = NO;
            }
            else if(indexPath.row == 2){
                cell.label0.text = @"医院：";
//                cell.textField.text = @"";
                cell.textField.text = self.orderCreateModel.hospital;
                cell.textField.placeholder = @"请输入医院";
                cell.textField.userInteractionEnabled = YES;
            }
            else if(indexPath.row == 3){
                cell.label0.text = @"科室：";
//                cell.textField.text = @"";
                cell.textField.text = self.orderCreateModel.department;
                cell.textField.placeholder = @"请输入科室";
                cell.textField.userInteractionEnabled = YES;
            }
        }
        return cell;
        
        
    }
    else if(indexPath.section == 1){
        CommonTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTextViewTableViewCell"];
        cell.TextView.placeholder = @"请输入病情介绍";
        return cell;
    }
    else if(indexPath.section == 3){
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imagesArr = [self.imagesModelArr valueForKeyPath:@"image"];
        
        [cell setDidSelect:^(NSInteger selectIndex) {
            if(selectIndex == self.imagesModelArr.count){//addImage
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] init];
                imagePickerVc.maxImagesCount = 1;
                    imagePickerVc.allowPickingOriginalPhoto = YES;
                    imagePickerVc.allowPickingVideo = NO;
                    imagePickerVc.allowPickingImage = YES;
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    [self upLoadImageWithPhotos:photos assets:assets isSelectOriginalPhoto:YES];
                }];
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }
            else{
                //
            }
        }];
        [cell setDidDelect:^(NSInteger deleteIndex) {
            if(self.imagesModelArr.count > deleteIndex){
                [self.imagesModelArr removeObjectAtIndex:deleteIndex];
                [self reloadData];
            }
        }];
        return cell;
    }
    else if(indexPath.section == 4){
        CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imagesArr = [self.videosModelArr valueForKeyPath:@"image"];


        [cell setDidSelect:^(NSInteger selectIndex) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] init];
            imagePickerVc.maxImagesCount = 1;
            imagePickerVc.allowPickingVideo = YES;
            imagePickerVc.allowPickingImage = NO;
            [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
                if(selectIndex == self.videosModelArr.count){//addVideo
                    [self upLoadVideoWithCoverImage:coverImage asset:asset];
                }
                else{
                    //
                }
                
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }];
        [cell setDidDelect:^(NSInteger deleteIndex) {
            if(self.videosModelArr.count > deleteIndex){
                [self.videosModelArr removeObjectAtIndex:deleteIndex];
                [self reloadData];
            }
        }];
        return cell;
    }

    
    return nil;

}

-(void)upLoadImageWithPhotos:(NSArray<UIImage *> *)photos assets:(NSArray *)assets isSelectOriginalPhoto:(BOOL )isSelectOriginalPhoto{
    if(photos.count == 0){
        NSLog(@"select 0 image");
        return ;
    }
    [CommonManage QNPutimage:photos[0] forView:LR_KEY_WINDOW key:nil res:^(BOOL success, NSString * _Nonnull key, NSString * _Nonnull imageURL) {
        if(success){
            IMageOrVideoModel *imgModel = [[IMageOrVideoModel alloc]init];
            imgModel.image = photos[0];
            imgModel.imageOther = assets[0];
            imgModel.imageURLKey = key;
            [self.imagesModelArr addObject:imgModel];
            [self reloadData];
        }
        else{
            LR_TOAST(@"上传失败");
        }
    } progressHandler:^(NSString *key, float percent) {
        
    }];
}

-(void)upLoadVideoWithCoverImage:(UIImage *)coverImage asset:(PHAsset *)asset{
    [[TZImageManager manager] getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
        
        NSURL *url = urlAsset.URL;
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        NSLog(@"视频大小 %lu",(unsigned long)data.length);
        AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:AVAssetExportPreset640x480];
        exportSession.shouldOptimizeForNetworkUse = YES;
        NSString*  _outPath = [NSString stringWithFormat:@"%@/bb", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]];
        BOOL isSuccess = [ [NSFileManager defaultManager] removeItemAtPath:_outPath error:nil];
        

        exportSession.outputURL = [NSURL fileURLWithPath:_outPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
       __block MBProgressHUD *waithud;
            waithud = [MBProgressHUD showHUDAddedTo:LR_KEY_WINDOW animated:YES];
            waithud.label.text = @"视频处理中";
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{

            [waithud hideAnimated:YES];
                int exportStatus = exportSession.status;
                NSLog(@"%d",exportStatus);
                switch (exportStatus)
                {
                    case AVAssetExportSessionStatusFailed:
                    {
                        // log error to text view
                        NSError *exportError = exportSession.error;
                        NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                        break;
                    }
                    case AVAssetExportSessionStatusCompleted:
                    {
                        NSLog(@"视频转码成功");
                        NSData *data2 = [NSData dataWithContentsOfFile:_outPath];
                        NSLog(@"视频大小2 %lu",(unsigned long)data2.length);
                        [CommonManage QNPutimage:data2 forView:LR_KEY_WINDOW key:nil res:^(BOOL success, NSString * _Nonnull key, NSString * _Nonnull imageURL) {
                            if(success){
                                NSLog(@"video key is %@",key);
                                IMageOrVideoModel *imgModel = [[IMageOrVideoModel alloc]init];
                                imgModel.image = coverImage;
                                imgModel.imageOther = data2;
                                imgModel.imageURLKey = key;
                                [self.videosModelArr addObject:imgModel];
                                [self reloadData];
                            }
                            else{
                                    LR_TOAST(@"上传失败");
                            }
                            
                        } progressHandler:nil];
                        //                    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[data2]applicationActivities:nil];
                        //                    [self presentViewController:activityVC animated:YES completion:nil];
                        
                        
                    }
                }
          
            
         }];
    }];
    
    //            if (asset.mediaType == PHAssetMediaTypeVideo) {
    //                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    //                options.version = PHImageRequestOptionsVersionCurrent;
    //                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    //
    //                PHImageManager *manager = [PHImageManager defaultManager];
    //                [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable avasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
    //                    AVURLAsset *urlAsset = (AVURLAsset *)avasset;
    //
    //                    NSURL *url = urlAsset.URL;
    //                    NSData *data = [NSData dataWithContentsOfURL:url];
    //
    //                    NSLog(@"%@",data);
    //                }];
    //            }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    LRWeakSelf
    if(indexPath.section == 0||indexPath.section == 2){
        
        if(indexPath.section == 0){
            if(indexPath.row ==0){
//                cell.label0.text = @"与患者关系：";
                NSArray *selectArr =@[@"本人",@"家属",@"朋友",@"同事"];
               
                
                [BRStringPickerView showStringPickerWithTitle:@"与患者关系：" dataSource:selectArr defaultSelValue:selectArr[self.orderCreateModel.relative.intValue -1] isAutoSelect:NO resultBlock:^(id selectValue) {
                    NSInteger selectIndex = [selectArr indexOfObject:selectValue];
                    weakSelf.orderCreateModel.relative = [NSString stringWithFormat:@"%ld",selectIndex+1];
                    [weakSelf reloadData];
                }];
                
            }
            else if(indexPath.row == 1){
//                cell.label0.text = @"类型：";
                //                cell.textField.text = @"第一次就诊";
                NSArray *selectArr =@[@"第一次就诊",@"复诊"];
                
                [BRStringPickerView showStringPickerWithTitle:@"类型：" dataSource:selectArr defaultSelValue:selectArr[self.orderCreateModel.orderType.intValue -1] isAutoSelect:NO resultBlock:^(id selectValue) {
                    NSInteger selectIndex = [selectArr indexOfObject:selectValue];
                    weakSelf.orderCreateModel.orderType = [NSString stringWithFormat:@"%ld",selectIndex+1];
                    [weakSelf reloadData];
                }];
                
            }
            else if(indexPath.row == 2){
                
            }
            else if(indexPath.row == 3){
                
                
                
            }
            else if(indexPath.row == 4){
               
            }
            else if(indexPath.row == 5){

                
            }
            else if(indexPath.row == 6){
              
            }
        }
        else if(indexPath.section == 2){
            if(indexPath.row ==0){
               
                [BRDatePickerView showDatePickerWithTitle:@"就诊时间：" dateType:UIDatePickerModeDateAndTime defaultSelValue:self.orderCreateModel.visitTime minDateStr:@"" maxDateStr:@"" isAutoSelect:NO resultBlock:^(NSString *selectValue,NSDate *date) {
                    if(date){
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                    NSString *destDateString = [dateFormatter stringFromDate:date];
                    
                    weakSelf.orderCreateModel.visitTime = destDateString;
                    [weakSelf reloadData];
                    }

                }];
            }
            else if(indexPath.row == 1){
               
                
            }
            else if(indexPath.row == 2){
              
            }
            else if(indexPath.row == 3){
               
            }
        }
        
    }
    
    
    
}
-(void)requestPost{
    if(!self.orderCreateModel){
        return;
    }
    if(self.imagesModelArr.count >0){
        NSArray *keys = [self.imagesModelArr valueForKeyPath:@"imageURLKey"];
        NSString *str = [keys componentsJoinedByString:@","];
        self.orderCreateModel.sickPic =str;
    }
    if(self.videosModelArr.count >0){
        NSArray *keys = [self.videosModelArr valueForKeyPath:@"imageURLKey"];
        NSString *str = [keys componentsJoinedByString:@","];
        self.orderCreateModel.sickVedio =str;
    }
    [BaseRequest requestWithRequestModel:self.orderCreateModel ret:^(BOOL success, __kindof BaseResultModel *dataModel, NSString *jsonObjc) {
        NSLog(@"jsonObjc");
    }];
    
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
-(UIView *)crecteBottomViewContainButtonWithTitle:(NSString *)title action:(SEL)action{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIButton *button = [[UIButton alloc]init];
    [bottomView addSubview:button];
    LR_BUTTON_STYLE(button);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
    return bottomView;
}
@end
