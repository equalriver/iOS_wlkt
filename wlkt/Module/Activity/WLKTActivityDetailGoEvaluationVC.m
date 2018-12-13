//
//  WLKTActivityDetailGoEvaluationVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/13.
//  Copyright © 2017年 neimbo. All rights reserved.南
//

#import "WLKTActivityDetailGoEvaluationVC.h"
#import "TZImagePickerController.h"
#import "WLKTActivityDetailGoEvaluationView.h"
#import "WLKTCourseDetailUploadcollectionCell.h"
#import "WLKTLogin.h"
#import <AFNetworking.h>
#import "WLKTLoginCoordinator.h"

@interface WLKTActivityDetailGoEvaluationVC ()<TZImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ActivityDetailGoEvaluationDelegate, WLKTLoginCoordinatorDelegate>
@property (strong, nonatomic) WLKTActivityDetailGoEvaluationView *evaluationView;
@property (strong, nonatomic) UILabel *uploadLabel;
@property (strong, nonatomic) UICollectionView *uploadCV;
@property (strong, nonatomic) UIView *uploadContentView;
//@property (strong, nonatomic) UIButton *confirmBtn;

@property (nonatomic ,strong) NSMutableArray<UIImage *> *photosArray;
@property (nonatomic ,strong) NSMutableArray<UIImage *> *assestArray;
@property (nonatomic) BOOL isSelectOriginalPhoto;
@property (nonatomic) NSInteger total_score;
@property (nonatomic) NSInteger effect;
@property (nonatomic) NSInteger teacher;
@property (nonatomic) NSInteger environment;
@property (copy, nonatomic) NSString *comment;
@property (strong, nonatomic) WLKTActivity *activity;
@property (strong, nonatomic) NSMutableArray *childCoordinator;
@property (copy, nonatomic) void (^loginBlock)(void);
@end

@implementation WLKTActivityDetailGoEvaluationVC
- (instancetype)initWithActivity:(WLKTActivity *)activity
{
    self = [super init];
    if (self) {
        _activity = activity;
        [self.view addSubview:self.evaluationView];
        [self.view addSubview:self.uploadContentView];
        [self.uploadContentView addSubview:self.uploadLabel];
        [self.uploadContentView addSubview:self.uploadCV];
//        [self.view addSubview:self.confirmBtn];
        self.title = @"我要评价";
        self.view.backgroundColor = separatorView_color;
        [self makeConstraints];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.total_score = 5;
    self.effect = 5;
    self.teacher = 5;
    self.environment = 5;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnAct)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - go evaluation delegate
- (void)didSelectedPingjiaStar:(NSInteger)starIndex{
    self.total_score = starIndex + 1.0;
}

- (void)didSelectedXiaoguoNumber:(NSInteger)number{
    self.effect = number + 1.0;
}

- (void)didSelectedShiziNumber:(NSInteger)number{
    self.teacher = number + 1.0;
}

- (void)didSelectedHuanjingNumber:(NSInteger)number{
    self.environment = number + 1.0;
}

- (void)didEnterPingjia:(NSString *)text{
    self.comment = text;
}

#pragma mark - network
- (void)uploadCommentWithPhotos:(NSArray<NSData *> *)photos{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObjects:@"application/json", @"text/json",
     @"text/javascript", @"text/html", nil];
    NSDictionary *param = @{
                            @"order_id": @(0),
                            @"user_id": TheCurUser.token ? TheCurUser.token : @"",
                            @"suid": self.activity.suid ? self.activity.suid : @"",
                            @"schoolname": self.activity.schoolname ? self.activity.schoolname : @"",
                            @"pointname": self.activity.address ? self.activity.address : @"",
                            @"course_id": @(0),
                            @"activity_id": self.activity.aid ? self.activity.aid : @(0),
                            @"content": self.comment ? self.comment : @"",
                            @"total_score": @(_total_score),
                            @"effect": @(_effect),
                            @"teacher": @(_teacher),
                            @"environment": @(_environment),
                            RequestMD5String
                            };
    //发出请求
    NSString *url = [NSString stringWithFormat:@"%@comment/sdata", kBaseURL];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //利用时间戳当做图片名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *imageName = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];
        if (photos.count) {
            for (int i = 0; i < photos.count; i++) {
                [formData appendPartWithFileData:photos[i] name:[NSString stringWithFormat:@"picture%d", i] fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (TheCurUser) {
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"正在上传..."];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        if ([dic containsObjectForKey:@"message"]) {
            [SVProgressHUD showInfoWithStatus:dic[@"message"]];
            if ([dic[@"message"] isEqualToString:@"未登录"]) {
                WS(weakSelf);
                if (!TheCurUser) {
                    [self loginWithComepletion:^{
                        [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];
                    }];
                }
            }
        }
        if ([dic containsObjectForKey:@"errorCode"] && [dic[@"errorCode"] isEqual: @0]) {
            !self.successBlock ? : self.successBlock();
            sleep(1.5);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

#pragma mark - aciton
- (void)confirmBtnAct{
    if (self.total_score == 0) {
        [SVProgressHUD showInfoWithStatus:@"请为机构打分"];
        return;
    }
    if (self.effect == 0) {
        [SVProgressHUD showInfoWithStatus:@"请给效果打分"];
        return;
    }
    if (self.teacher == 0) {
        [SVProgressHUD showInfoWithStatus:@"请给师资打分"];
        return;
    }
    if (self.environment == 0) {
        [SVProgressHUD showInfoWithStatus:@"请给环境打分"];
        return;
    }
    if (self.comment.length < 5) {
        [SVProgressHUD showInfoWithStatus:@"评论未输入或过短"];
        return;
    }
    if (self.photosArray.count) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
        for (UIImage *obj in self.photosArray) {
            NSData *data = UIImageJPEGRepresentation(obj, 0.7f);
            [arr addObject:data];
        }
        [self uploadCommentWithPhotos:arr];
        return;
    }
    else if (self.assestArray.count){
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
        for (UIImage *obj in self.assestArray) {
            NSData *data = UIImageJPEGRepresentation(obj, 0.1f);
            [arr addObject:data];
        }
        [self uploadCommentWithPhotos:arr];
    }
    else{
        [self uploadCommentWithPhotos:nil];
    }
}

- (void)deletePhotos:(UIButton *)sender{
    [_photosArray removeObjectAtIndex:sender.tag - 100];
    [_assestArray removeObjectAtIndex:sender.tag - 100];
    [self.uploadCV performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag - 100 inSection:0];
        [self.uploadCV deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.uploadCV reloadData];
    }];
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photosArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WLKTCourseDetailUploadcollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WLKTCourseDetailUploadcollectionCell" forIndexPath:indexPath];
    
    if (indexPath.row == _photosArray.count) {
        cell.imagev.image = [UIImage imageNamed:@"图片"];
        cell.deleteButton.hidden = YES;
        
    }else{
        cell.imagev.image = _photosArray[indexPath.row];
        cell.deleteButton.hidden = NO;
    }
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _photosArray.count) {
        [self checkLocalPhoto];
    }else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assestArray selectedPhotos:_photosArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.photosArray = [NSMutableArray arrayWithArray:photos];
            self.assestArray = [NSMutableArray arrayWithArray:assets];
            self.isSelectOriginalPhoto = isSelectOriginalPhoto;
            [self.uploadCV reloadData];
            //            _collectionView.contentSize = CGSizeMake(0, ((_photosArray.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - image picker
- (void)checkLocalPhoto{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePicker.selectedAssets = _assestArray;
    imagePicker.allowPickingVideo = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.photosArray = [NSMutableArray arrayWithArray:photos];
    self.assestArray = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self.uploadCV reloadData];
    
}

#pragma mark - LSGLoginCoordinatorDelegate
- (void)loginCoordinatorDidFinishLogin:(WLKTLoginCoordinator *)loginCoordinator {
    if (_loginBlock) {
        _loginBlock();
    }
    
    [_childCoordinator removeObject:loginCoordinator];
}

- (void)loginCoordinatorDidFinishLogin:(WLKTLoginCoordinator *)coordinator handler:(void (^)(UIViewController *))handler{
    if (_loginBlock) {
        _loginBlock();
        handler(self);
    }
    
    [_childCoordinator removeObject:coordinator];
}

- (void)loginCoordinatorDidRequestDismissal:(WLKTLoginCoordinator *)loginCoordinator {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.childCoordinator removeObject:loginCoordinator];
    }];
}

- (void)loginWithComepletion:(void (^)(void))completion {
    WLKTLoginCoordinator *cr = [WLKTLoginCoordinator new];
    cr.delegate = self;
    [self.childCoordinator addObject:cr];
    self.loginBlock = completion;
    [self.navigationController presentViewController:cr.navigationController animated:YES completion:nil];
}

#pragma mark - make constraints
- (void)makeConstraints{
    [self.evaluationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 340 *ScreenRatio_6));
        make.top.mas_equalTo(self.view);
    }];
    [self.uploadContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 135 * ScreenRatio_6));
        make.top.mas_equalTo(self.evaluationView.mas_bottom).offset(5);
    }];
    [self.uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.uploadContentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.uploadContentView).offset(15 * ScreenRatio_6);
    }];
    [self.uploadCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 10, 90));
        make.left.mas_equalTo(self.uploadContentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.uploadLabel.mas_bottom).offset(15 * ScreenRatio_6);
    }];
//    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20, 40));
//        make.centerX.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.uploadContentView.mas_bottom).offset(10 * ScreenRatio_6);
//    }];
    
}

#pragma mark - get
- (WLKTActivityDetailGoEvaluationView *)evaluationView{
    if (!_evaluationView) {
        _evaluationView = [[WLKTActivityDetailGoEvaluationView alloc]initWithSchoolName:self.activity.schoolname];
        _evaluationView.delegate = self;
    }
    return _evaluationView;
}
- (UIView *)uploadContentView{
    if (!_uploadContentView) {
        _uploadContentView = [UIView new];
        _uploadContentView.backgroundColor = [UIColor whiteColor];
    }
    return _uploadContentView;
}
- (UILabel *)uploadLabel{
    if (!_uploadLabel) {
        _uploadLabel = [UILabel new];
        _uploadLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _uploadLabel.textColor = KMainTextColor_3;
        _uploadLabel.text = @"上传图片";
    }
    return _uploadLabel;
}
-(UICollectionView *)uploadCV{
    if (!_uploadCV) {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake(80, 80);
        flowLayOut.sectionInset = UIEdgeInsetsMake(0, 10 *ScreenRatio_6, 0, 0);
        flowLayOut.minimumInteritemSpacing = 10 *ScreenRatio_6;
        flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _uploadCV = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:flowLayOut];
        _uploadCV.delegate = self;
        _uploadCV.dataSource = self;
        _uploadCV.backgroundColor = [UIColor whiteColor];
        [_uploadCV registerClass:[WLKTCourseDetailUploadcollectionCell class] forCellWithReuseIdentifier:@"WLKTCourseDetailUploadcollectionCell"];
    }
    return _uploadCV;
}
//- (UIButton *)confirmBtn{
//    if (!_confirmBtn) {
//        _confirmBtn = [UIButton new];
//        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_confirmBtn setTitle:@"提交评价" forState:UIControlStateNormal];
//        [_confirmBtn setTitleColor:UIColorHex(ffffff) forState:UIControlStateNormal];
//        _confirmBtn.backgroundColor = UIColorHex(33c4da);
//        _confirmBtn.layer.masksToBounds = YES;
//        _confirmBtn.layer.cornerRadius = 5;
//        [_confirmBtn addTarget:self action:@selector(confirmBtnAct) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _confirmBtn;
//}
- (NSMutableArray *)photosArray{
    if (!_photosArray) {
        self.photosArray = [NSMutableArray array];
    }
    return _photosArray;
}
- (NSMutableArray *)assestArray{
    if (!_assestArray) {
        self.assestArray = [NSMutableArray array];
    }
    return _assestArray;
}
- (NSMutableArray *)childCoordinator {
    if (!_childCoordinator) {
        _childCoordinator = [NSMutableArray array];
    }
    return _childCoordinator;
}
@end
