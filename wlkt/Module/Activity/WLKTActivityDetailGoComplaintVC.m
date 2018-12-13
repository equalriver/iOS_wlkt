//
//  WLKTActivityDetailGoComplaintVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/13.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTActivityDetailGoComplaintVC.h"
#import "TZImagePickerController.h"
#import "WLKTCourseDetailUploadcollectionCell.h"
#import "PlaceholderTextView.h"
#import <AFNetworking.h>
#import "WLKTLogin.h"

@interface WLKTActivityDetailGoComplaintVC ()<TZImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) UIView *topContentView;
@property (strong, nonatomic) UILabel *schoolNameLabel;
@property (strong, nonatomic) UILabel *schoolTagLabel;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UILabel *complaintLabel;
@property (strong, nonatomic) PlaceholderTextView *complaintTV;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UITextField *phoneTF;
@property (strong, nonatomic) UILabel *phoneTagLabel;
@property (strong, nonatomic) UILabel *uploadLabel;
@property (strong, nonatomic) UICollectionView *uploadCV;
@property (strong, nonatomic) UIView *uploadContentView;
//@property (strong, nonatomic) UIButton *confirmBtn;

@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic ,strong) NSMutableArray *assestArray;
@property (copy, nonatomic) NSString *complaint;
@property (copy, nonatomic) NSString *phone;
@property (nonatomic) BOOL isSelectOriginalPhoto;
@property (strong, nonatomic) WLKTActivity *activity;
@end

@implementation WLKTActivityDetailGoComplaintVC
- (instancetype)initWithActivity:(WLKTActivity *)activity
{
    self = [super init];
    if (self) {
        _activity = activity;
        [self.view addSubview:self.topContentView];
        [self.topContentView addSubview:self.schoolNameLabel];
        [self.topContentView addSubview:self.schoolTagLabel];
        [self.topContentView addSubview:self.separatorView];
        [self.topContentView addSubview:self.complaintLabel];
        [self.topContentView addSubview:self.complaintTV];
        [self.topContentView addSubview:self.phoneLabel];
        [self.topContentView addSubview:self.phoneTF];
        [self.topContentView addSubview:self.phoneTagLabel];
        [self.view addSubview:self.uploadContentView];
        [self.uploadContentView addSubview:self.uploadLabel];
        [self.uploadContentView addSubview:self.uploadCV];
//        [self.view addSubview:self.confirmBtn];
        self.title = @"我要投诉";
        self.view.backgroundColor = separatorView_color;
        [self makeConstraints];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnAct)];
    self.navigationItem.rightBarButtonItem = right;
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
                            @"user_id": TheCurUser.token ? TheCurUser.token : @"",
                            @"suid": self.activity.suid ? self.activity.suid : @"",
                            @"position_id": self.activity.schoolname ? self.activity.schoolname : @"",
                            @"course_id": @(0),
                            @"act_id": self.activity.aid ? self.activity.aid : @(0),
                            @"describe": self.complaint ? self.complaint : @"",
                            @"phone": self.phone ? self.phone : @"",
                            RequestMD5String
                            };
    
    //发出请求
    NSString *url = [NSString stringWithFormat:@"%@tousu/sdata", kBaseURL];
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
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"正在上传..."];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
        !self.successBlock ? : self.successBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

#pragma mark - aciton
- (void)textViewDidChange:(UITextView *)textView{
    self.complaint = textView.text;
}

- (void)phoneTFAct:(UITextField *)sender{
    if (sender.text.length > 11) {
        sender.text = [sender.text substringToIndex:11];
    }
    self.phone = sender.text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)confirmBtnAct{
    if (self.complaint.length < 5) {
        [SVProgressHUD showInfoWithStatus:@"描述未输入或太短"];
        return;
    }
    if (![self.phone isValidPhoneNumber]) {
        [SVProgressHUD showInfoWithStatus:@"手机号未输入或不正确"];
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

#pragma mark - make constraints
- (void)makeConstraints{
    [self.schoolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topContentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.topContentView).offset(15 * ScreenRatio_6);
    }];
    [self.schoolTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.schoolNameLabel.mas_right).offset(3);
        make.bottom.mas_equalTo(self.schoolNameLabel.mas_bottom);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.top.mas_equalTo(self.schoolNameLabel.mas_bottom).offset(15 * ScreenRatio_6);
    }];
    [self.complaintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topContentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.separatorView).offset(30 * ScreenRatio_6);
    }];
    [self.complaintTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(270 * ScreenRatio_6, 100));
        make.left.mas_equalTo(self.complaintLabel.mas_right).offset(13 * ScreenRatio_6);
        make.top.mas_equalTo(self.separatorView).offset(15 * ScreenRatio_6);
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 30));
        make.top.mas_equalTo(self.complaintTV.mas_bottom).offset(15 * ScreenRatio_6);
        make.left.mas_equalTo(self.complaintTV.mas_left);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topContentView).offset(10 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.phoneTF);
    }];
    [self.phoneTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTF.mas_bottom).offset(10 * ScreenRatio_6);
        make.left.mas_equalTo(self.phoneTF);
        make.right.mas_equalTo(self.topContentView.mas_right).offset(-10 * ScreenRatio_6);
    }];
    [self.uploadContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 135));
        make.top.mas_equalTo(self.phoneTagLabel.mas_bottom).offset(20 * ScreenRatio_6);
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
//        make.top.mas_equalTo(self.uploadContentView.mas_bottom).offset(10);
//    }];
}

#pragma mark - get
- (UIView *)topContentView{
    if (!_topContentView) {
        _topContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 245)];
        _topContentView.backgroundColor = [UIColor whiteColor];
    }
    return _topContentView;
}
- (UILabel *)schoolNameLabel{
    if (!_schoolNameLabel) {
        _schoolNameLabel = [UILabel new];
        _schoolNameLabel.font = [UIFont systemFontOfSize:14 * ScreenRatio_6];
        _schoolNameLabel.textColor = UIColorHex(37becc);
        _schoolNameLabel.text = _activity.schoolname;
    }
    return _schoolNameLabel;
}
- (UILabel *)schoolTagLabel{
    if (!_schoolTagLabel) {
        _schoolTagLabel = [UILabel new];
        _schoolTagLabel.font = [UIFont systemFontOfSize:11 * ScreenRatio_6];
        NSString *s = @"(*为必填项目)";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
        [str setAttributes:@{NSForegroundColorAttributeName: KMainTextColor_9} range:NSMakeRange(0, 1)];
        [str setAttributes:@{NSForegroundColorAttributeName: UIColorHex(37becc)} range:NSMakeRange(1, 1)];
        [str setAttributes:@{NSForegroundColorAttributeName: KMainTextColor_9} range:NSMakeRange(2, s.length - 2)];
        _schoolTagLabel.attributedText = str;
    }
    return _schoolTagLabel;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = separatorView_color;
    }
    return _separatorView;
}
- (UILabel *)complaintLabel{
    if (!_complaintLabel) {
        _complaintLabel = [UILabel new];
        _complaintLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        NSString *ts = [NSString stringWithFormat:@"投诉描述：*"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:ts];
        [str setAttributes:@{NSForegroundColorAttributeName: KMainTextColor_3} range:NSMakeRange(0, ts.length - 1)];
        [str setAttributes:@{NSForegroundColorAttributeName: UIColorHex(37becc)} range:NSMakeRange(ts.length - 1, 1)];
        _complaintLabel.attributedText = str;
    }
    return _complaintLabel;
}
- (PlaceholderTextView *)complaintTV{
    if (!_complaintTV) {
        _complaintTV = [[PlaceholderTextView alloc]initWithPlaceholderColor:KMainTextColor_9 font:11 * ScreenRatio_6];
        _complaintTV.myPlaceholder = @"活动怎么样？环境如何？效果还满意吗？(5~200个字)";
        _complaintTV.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _complaintTV.textColor = KMainTextColor_3;
        _complaintTV.layer.borderColor = KMainTextColor_9.CGColor;
        _complaintTV.layer.borderWidth = 0.5;
        _complaintTV.delegate = self;
    }
    return _complaintTV;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        NSString *ts = [NSString stringWithFormat:@"联系电话：*"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:ts];
        [str setAttributes:@{NSForegroundColorAttributeName: KMainTextColor_3} range:NSMakeRange(0, ts.length - 1)];
        [str setAttributes:@{NSForegroundColorAttributeName: UIColorHex(37becc)} range:NSMakeRange(ts.length - 1, 1)];
        _phoneLabel.attributedText = str;
    }
    return _phoneLabel;
}
- (UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [UITextField new];
        _phoneTF.font = [UIFont systemFontOfSize:11 * ScreenRatio_6];
        _phoneTF.textColor = KMainTextColor_3;
        _phoneTF.layer.borderWidth = 0.5;
        _phoneTF.layer.borderColor = KMainTextColor_9.CGColor;
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneTF addTarget:self action:@selector(phoneTFAct:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTF;
}
- (UILabel *)phoneTagLabel{
    if (!_phoneTagLabel) {
        _phoneTagLabel = [UILabel new];
        _phoneTagLabel.font = [UIFont systemFontOfSize:10 * ScreenRatio_6];
        _phoneTagLabel.textColor = KMainTextColor_9;
        _phoneTagLabel.text = @"请留下联系方式，供投诉反馈用，此联系方式不会对外公开。";
        _phoneTagLabel.numberOfLines = 0;
    }
    return _phoneTagLabel;
}
//- (UIButton *)confirmBtn{
//    if (!_confirmBtn) {
//        _confirmBtn = [UIButton new];
//        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_confirmBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
//        [_confirmBtn setTitleColor:UIColorHex(ffffff) forState:UIControlStateNormal];
//        _confirmBtn.layer.cornerRadius = 3;
//        _confirmBtn.layer.masksToBounds = YES;
//        _confirmBtn.backgroundColor = UIColorHex(33c4da);
//        [_confirmBtn addTarget:self action:@selector(confirmBtnAct) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _confirmBtn;
//}
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

