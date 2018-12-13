//
//  WLKTConfirmOrderVC.m
//  wlkt
//
//  Created by 尹平江 on 17/4/1.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTRepayOrderVC.h"
#import "WLKTAlipayRepay.h"
#import "WLKTTianfuPayRepay.h"
#import "WLKTPaySuccessVC.h"
#import "WLKTPayFailVC.h"
#import "WLKTCoursePriceRange.h"
//#import <BaiduMapKit/BaiduMapAPI_Base/BMKUserLocation.h>
//#import <BaiduMapKit/BaiduMapAPI_Map/BMKAnnotation.h>
//#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapView.h>
//#import <BaiduMapKit/BaiduMapAPI_Map/BMKPointAnnotation.h>
//#import <BaiduMapKit/BaiduMapAPI_Map/BMKPinAnnotationView.h>
//#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationService.h>
//#import <BaiduMapKit/BaiduMapAPI_Search/BMKGeocodeSearch.h>


@interface WLKTRepayOrderVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) UITableView *orderTableView;
@property (strong, nonatomic) UIButton *payButton;
@property (copy, nonatomic) NSString *studentName;
@property (assign) int studentAge;
@property (copy, nonatomic) NSString *studentPhoneNum;
@property (assign) int payButtonTag;
@property (copy, nonatomic) NSString *currentPrice;
@property (copy, nonatomic) NSString *bkprice;
//@property (strong, nonatomic) BMKLocationService *location;
@property (assign) int onecut;
@end

@implementation WLKTRepayOrderVC

- (instancetype)initWithSchoolName:(NSString *)schoolName
                       schoolImage:(NSString *)schoolImage
                       courseName :(NSString *)courseName
                             price:(NSArray *)price
                         classType:(NSString *)classType
                     teachLocation:(NSString *)teachLocation
                           address:(NSString *)address
                              suid:(NSString *)suid
                          courseId:(NSString *)courseId
                           bkprice:(NSString *)bkprice
                       courseCount:(int)courseCount
                            onecut:(int)onecut
{
    self = [super init];
    if (self) {
        _schoolName = schoolName;
        _schoolImage = schoolImage;
        _courseName = courseName;
        _price = [NSArray arrayWithArray:price];
        _classType = classType;
        _teachLocation = teachLocation;
        _address = address;
        _suid = suid;
        _courseId = courseId;
        _courseCount = courseCount;
        _bkprice = bkprice;
        _onecut = onecut;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}


- (void)updateViewConstraints{
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight));
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 55 * ScreenRatio_6));
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.location startUserLocationService];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"箭头左"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAct)];
    
    [self.view addSubview:self.orderTableView];
    [self.view addSubview:self.payButton];
    [self.payButton addTarget:self action:@selector(payOrderAct:) forControlEvents:UIControlEventTouchUpInside];
    
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    
    //keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //pay
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail:) name:@"payFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payWayTag:) name:@"payWayTag" object:nil];
}

- (void)backButtonAct{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - pay

- (void)paySuccess:(NSNotification *)noti{
    WLKTPaySuccessVC *vc = [[WLKTPaySuccessVC alloc]init];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.25);
    dispatch_after(t, dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}

- (void)payFail:(NSNotification *)noti{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.25);
    dispatch_after(t, dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[[WLKTPayFailVC alloc]init] animated:YES];
    });
    
}

#pragma mark - keyboard

- (void)keyboardFrameChange:(NSNotification *)noti{
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.view.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - self.view.frame.size.height - 64);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenHeight + 210 * ScreenRatio_6;
}

#pragma mark - button
- (void)payWayTag:(NSNotification *)noti{
    NSString *tag = noti.userInfo[@"tag"];
    self.payButtonTag = tag.intValue;
}

- (void)payOrderAct:(UIButton *)payOrderButton{
    [self.view endEditing:YES];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    if (self.studentName.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入您的姓名"];
    }
    else if (self.studentName.length < 2 || self.studentName.length > 4){
        [SVProgressHUD showInfoWithStatus:@"姓名格式不对"];
    }
//    else if (self.cell.studentAgeTF.text.length == 0){
//        [SVProgressHUD showInfoWithStatus:@"请输入您的年龄"];
//    }
    else if (self.studentAge > 999 || self.studentAge < 1){
        [SVProgressHUD showInfoWithStatus:@"年龄格式不对"];
    }
    else if (self.studentPhoneNum.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入您的联系电话"];
    }
    else if (self.studentPhoneNum.length != 11){
        [SVProgressHUD showInfoWithStatus:@"电话格式不对"];
    }
    else if (self.courseCount < 1){
        [SVProgressHUD showInfoWithStatus:@"没有选择课时数"];
    }
    else{
        dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.25);
        dispatch_after(t, dispatch_get_main_queue(), ^{
            if (self.payButtonTag == 0) {//天府银行
                [WLKTTianfuPayRepay tianfuPayWithOrderId:self.courseId target:self];
                //NSLog(@"天府银行");
            }
            if (self.payButtonTag == 1) {//支付宝
                [WLKTAlipayRepay AlipayWithOrderId:self.courseId];
                //NSLog(@"支付宝");
            }
            if (self.payButtonTag == 2) {//weixin
                
                
            }
        });
        
    }
    
}

#pragma mark - TextField

- (void)studentNameTFAct:(UITextField *)studentNameTF{
    self.studentName = studentNameTF.text;
}

- (void)studentAgeTFAct:(UITextField *)studentAgeTF{
    self.studentAge = studentAgeTF.text.intValue;
}

- (void)phoneTFAct:(UITextField *)phoneTF{
    self.studentPhoneNum = phoneTF.text;
}

#pragma mark - get

- (UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]init];
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _orderTableView;
}
- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [[UIButton alloc]init];
        [_payButton setTitle:@"确认支付" forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:16 * ScreenRatio_6];
        _payButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _payButton.backgroundColor = navigationBgColor;
    }
    return _payButton;
}

//- (BMKLocationService *)location {
//    if (!_location) {
//        _location = [[BMKLocationService alloc] init];
//        //        _location.delegate = self;
//    }
//    return _location;
//}

#pragma mark -

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
