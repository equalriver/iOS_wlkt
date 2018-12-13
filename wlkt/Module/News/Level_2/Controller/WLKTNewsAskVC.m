//
//  WLKTNewsAskVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/27.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTNewsAskVC.h"
#import "PlaceholderTextView.h"
#import "WLKTNewsGetAskTypeApi.h"
#import "WLKTNewsAskTypeData.h"
#import "WLKTLogin.h"
#import "WLKTLoginCoordinator.h"
#import "WLKTCourseDetailUploadcollectionCell.h"
#import "TZImagePickerController.h"

@protocol NewsAskTypeDelegate <NSObject>
- (void)didSelectedAskType:(UIButton *)sender;
@end

@interface NewsAskTypeCell: UICollectionViewCell
@property (strong, nonatomic) UIImageView *iconIV;
@property (strong, nonatomic) UIButton *typeBtn;
@property (assign) NSInteger index;

@property (weak, nonatomic) id<NewsAskTypeDelegate> delegate;
- (void)setCellData:(WLKTNewsAskTypeData *)data index:(NSInteger)index;
@end

@implementation NewsAskTypeCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconIV];
        [self.contentView addSubview:self.typeBtn];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.mas_equalTo(self.contentView);
        }];
        [self.typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 15));
            make.centerY.mas_equalTo(self.iconIV);
            make.left.mas_equalTo(self.iconIV.mas_right).offset(5);
        }];
    }
    return self;
}

- (void)setCellData:(WLKTNewsAskTypeData *)data index:(NSInteger)index{
    self.index = index;
    self.typeBtn.tag = index;
    [self.typeBtn setTitle:[NSString stringWithFormat:@"%@", data.title] forState:UIControlStateNormal];

    [self.typeBtn setTitleColor:[UIColor colorWithHexString:data.color] forState:UIControlStateNormal];
    self.typeBtn.layer.borderColor = [UIColor colorWithHexString:data.color].CGColor;
    [self.typeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(data.title.length *17, 15));
    }];
}



- (void)askTypeAct:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectedAskType:)]) {
        [self.delegate didSelectedAskType:sender];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.typeBtn setTitle:nil forState:UIControlStateNormal];
    self.typeBtn.selected = false;
//    self.iconIV.image = nil;
}

#pragma mark - get
- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"举报未选中"]];
    }
    return _iconIV;
}
- (UIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [UIButton new];
        _typeBtn.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _typeBtn.layer.cornerRadius = 3;
        _typeBtn.layer.masksToBounds = YES;
        _typeBtn.layer.borderWidth = 0.5;
//        [_typeBtn setImage:[UIImage imageNamed:@"举报选中"] forState:UIControlStateSelected];
//        [_typeBtn setImage:[UIImage imageNamed:@"举报未选中"] forState:UIControlStateNormal];
        [_typeBtn setTitleColor:KMainTextColor_3 forState:UIControlStateNormal];
        [_typeBtn addTarget:self action:@selector(askTypeAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeBtn;
}

@end

//@interface RequestModel: NSObject
//@property (copy, nonatomic) NSString *message;
//@property (copy, nonatomic) NSArray *result;
//@end
//
//@implementation RequestModel
//@end

/***********************************************************************/
@interface WLKTNewsAskVC ()<UICollectionViewDelegate, UICollectionViewDataSource, NewsAskTypeDelegate, WLKTLoginCoordinatorDelegate, TZImagePickerControllerDelegate>
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *detailNewsLabel;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UILabel *askFixLabel;
@property (strong, nonatomic) PlaceholderTextView *askTV;
@property (strong, nonatomic) UILabel *askTypeFixLabel;
//@property (strong, nonatomic) UIButton *confirmBtn;
@property (strong, nonatomic) UICollectionView *typeCV;
@property (strong, nonatomic) UILabel *uploadLabel;
@property (strong, nonatomic) UICollectionView *uploadCV;
@property (strong, nonatomic) UIView *uploadContentView;

@property (copy, nonatomic) NSString *askType;
@property (copy, nonatomic) NSArray<WLKTNewsAskTypeData *> *dataArr;
@property (strong, nonatomic) NSMutableArray<NewsAskTypeCell *> *typeItemArr;
@property (strong, nonatomic) NSMutableArray *childCoordinator;
@property (copy, nonatomic) void (^loginBlock)(void);
@property (nonatomic ,strong) NSMutableArray<UIImage *> *photosArray;
@property (nonatomic ,strong) NSMutableArray<UIImage *> *assestArray;
@property (nonatomic) BOOL isSelectOriginalPhoto;
@end

@implementation WLKTNewsAskVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要提问";
    self.view.backgroundColor = separatorView_color;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnAct)];
    self.navigationItem.rightBarButtonItem = right;
    [self addViews];
    [self loadAskType];
}

- (void)addViews{
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.detailNewsLabel];
    [self.contentView addSubview:self.separatorView];
    [self.contentView addSubview:self.askFixLabel];
    [self.contentView addSubview:self.askTV];
    [self.contentView addSubview:self.askTypeFixLabel];
    [self.contentView addSubview:self.typeCV];
    [self.view addSubview:self.uploadContentView];
    [self.uploadContentView addSubview:self.uploadLabel];
    [self.uploadContentView addSubview:self.uploadCV];
//    [self.view addSubview:self.confirmBtn];
    [self makeConstraints];
}

#pragma mark - network
- (void)loadAskType{
    WLKTNewsGetAskTypeApi *api = [[WLKTNewsGetAskTypeApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSArray *arr = [NSArray modelArrayWithClass:[WLKTNewsAskTypeData class] json:request.responseJSONObject[@"result"]];
        self.dataArr = [NSArray arrayWithArray:arr];
        [self.typeCV reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        ShowApiError
    }];
}

- (void)uploadCommentWithPhotos:(NSArray<NSData *> *)photos{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObjects:@"application/json", @"text/json",
     @"text/javascript", @"text/html", nil];
    NSDictionary *param = @{
                            @"user_id": TheCurUser.token ? TheCurUser.token : @"",
                            @"question": self.askTV.text,
                            @"asktype": _askType,
                            RequestMD5String
                            };
    //发出请求
    NSString *url = [NSString stringWithFormat:@"%@ask/sask", kBaseURL];
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
//            !self.successBlock ? : self.successBlock();
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

#pragma mark - action
- (void)confirmBtnAct{
    if (self.askTV.text.length < 5) {
        [SVProgressHUD showInfoWithStatus:@"描述字数不够"];
        return;
    }
    if (!self.askType.length) {
        [SVProgressHUD showInfoWithStatus:@"请选择问题类型"];
        return;
    }
    if (self.askTV.text.length > 200) {
        [SVProgressHUD showInfoWithStatus:@"超过字数限制"];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - ask type delegate
- (void)didSelectedAskType:(UIButton *)sender{
    for (NewsAskTypeCell *obj in self.typeItemArr) {
        if (obj.typeBtn.tag == sender.tag) {
            obj.iconIV.image = [UIImage imageNamed:@"举报选中"];
        }
        else{
            obj.iconIV.image = [UIImage imageNamed:@"举报未选中"];
        }
    }
    self.askType = self.dataArr[sender.tag].title;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.uploadCV) {
        return self.photosArray.count + 1;
    }
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.uploadCV) {
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
    else{
        NewsAskTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsAskTypeCell" forIndexPath:indexPath];
        cell.delegate = self;
        if ([self.typeItemArr containsObject:cell]) {
            [self.typeItemArr replaceObjectAtIndex:indexPath.item withObject:cell];
        }
        else{
            [self.typeItemArr addObject:cell];
        }

        [cell setCellData:self.dataArr[indexPath.item] index:indexPath.item];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.uploadCV) {
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

            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
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

#pragma mark -
- (void)makeConstraints{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 250));
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    [self.detailNewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15 * ScreenRatio_6);
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.detailNewsLabel.mas_bottom).offset(10 * ScreenRatio_6);
    }];
    [self.askFixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.separatorView).offset(30);
    }];
    [self.askTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(275 * ScreenRatio_6, 100));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * ScreenRatio_6);
        make.top.mas_equalTo(self.separatorView).offset(15 * ScreenRatio_6);
    }];
    [self.askTypeFixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.askFixLabel.mas_bottom).offset(100);
    }];
    [self.typeCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.askTV);
        make.top.mas_equalTo(self.askTypeFixLabel).offset(-5);
        make.right.mas_equalTo(self.view.mas_right).offset(-10 * ScreenRatio_6);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10 * ScreenRatio_6);
    }];
    [self.uploadContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 135 * ScreenRatio_6));
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(5);
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
}

#pragma mark - get
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColorHex(ffffff);
    }
    return _contentView;
}
- (UILabel *)detailNewsLabel{
    if (!_detailNewsLabel) {
        _detailNewsLabel = [UILabel new];
    }
    return _detailNewsLabel;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = separatorView_color;
    }
    return _separatorView;
}
- (UILabel *)askFixLabel{
    if (!_askFixLabel) {
        _askFixLabel = [UILabel new];
        _askFixLabel.font = [UIFont systemFontOfSize:14 * ScreenRatio_6];
        _askFixLabel.textColor = KMainTextColor_3;
        _askFixLabel.text = @"问题描述： ";
    }
    return _askFixLabel;
}
- (PlaceholderTextView *)askTV{
    if (!_askTV) {
        _askTV = [[PlaceholderTextView alloc]initWithPlaceholderColor:KMainTextColor_9 font:11 * ScreenRatio_6];
        _askTV.myPlaceholder = @"请输入具体问题描述(5~200个字)";
        _askTV.layer.borderColor = KMainTextColor_9.CGColor;
        _askTV.layer.borderWidth = 0.5;
        _askTV.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _askTV.textColor = KMainTextColor_3;
    }
    return _askTV;
}
- (UILabel *)askTypeFixLabel{
    if (!_askTypeFixLabel) {
        _askTypeFixLabel = [UILabel new];
        NSString *s = @"问题类型：*";
        NSMutableAttributedString *ats = [[NSMutableAttributedString alloc]initWithString:s];
        [ats setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 * ScreenRatio_6], NSForegroundColorAttributeName: KMainTextColor_3} range:NSMakeRange(0, 5)];
        [ats setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 * ScreenRatio_6], NSForegroundColorAttributeName: kMainTextColor_red} range:NSMakeRange(5, 1)];
        _askTypeFixLabel.attributedText = ats;
    }
    return _askTypeFixLabel;
}
- (UICollectionView *)typeCV{
    if (!_typeCV) {
        UICollectionViewFlowLayout *l = [UICollectionViewFlowLayout new];
        l.itemSize = CGSizeMake(60, 25);
        l.minimumInteritemSpacing = 5 * ScreenRatio_6;
        l.minimumLineSpacing = 5 * ScreenRatio_6;
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _typeCV = [[UICollectionView alloc]initWithFrame:CGRectNull collectionViewLayout:l];
        _typeCV.backgroundColor = [UIColor whiteColor];
        _typeCV.dataSource = self;
        _typeCV.delegate = self;
        _typeCV.scrollEnabled = false;
        [_typeCV registerClass:[NewsAskTypeCell class] forCellWithReuseIdentifier:@"NewsAskTypeCell"];
    }
    return _typeCV;
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
        _uploadLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _uploadLabel.textColor = KMainTextColor_3;
        _uploadLabel.text = @"上传图片";
    }
    return _uploadLabel;
}
-(UICollectionView *)uploadCV{
    if (!_uploadCV) {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake(80, 80);
        flowLayOut.sectionInset = UIEdgeInsetsMake(0, 10 * ScreenRatio_6, 0, 0);
        flowLayOut.minimumInteritemSpacing = 10 * ScreenRatio_6;
        flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _uploadCV = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:flowLayOut];
        _uploadCV.delegate = self;
        _uploadCV.dataSource = self;
        _uploadCV.backgroundColor = [UIColor whiteColor];
        [_uploadCV registerClass:[WLKTCourseDetailUploadcollectionCell class] forCellWithReuseIdentifier:@"WLKTCourseDetailUploadcollectionCell"];
    }
    return _uploadCV;
}
- (NSMutableArray<NewsAskTypeCell *> *)typeItemArr{
    if (!_typeItemArr) {
        _typeItemArr = [NSMutableArray arrayWithCapacity:6];
    }
    return _typeItemArr;
}
- (NSMutableArray *)childCoordinator {
    if (!_childCoordinator) {
        _childCoordinator = [NSMutableArray array];
    }
    return _childCoordinator;
}
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
@end

