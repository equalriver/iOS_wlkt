//
//  WLKTUserGenderVC.m
//  wlkt
//
//  Created by 尹平江 on 17/3/21.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTUserGenderVC.h"
#import "WLKTLogin.h"
#import "WLKTUserinfoChangeApi.h"
#import <SCLAlertView.h>

@interface WLKTUserGenderVC ()<UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSArray *genderArr;
@property (strong, nonatomic) UITableView *pickTableView;
@property (strong, nonatomic) UILabel *genderLabel;
@property (strong, nonatomic) UIView *labelBgView;
@property (strong, nonatomic) UIView *separatorView_one;
@property (strong, nonatomic) UIView *separatorView_two;
@end

@implementation WLKTUserGenderVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)updateViewConstraints{
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = userinfoBgColor;
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [self.view addSubview:self.labelBgView];
    [self.labelBgView addSubview:self.genderLabel];
    [self.labelBgView addSubview:self.separatorView_one];
    [self.labelBgView addSubview:self.separatorView_two];
    [self.view addSubview:self.pickTableView];
    
    self.pickTableView.hidden = YES;
    self.pickTableView.dataSource = self;
    self.pickTableView.delegate = self;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTapAct)];
    [self.genderLabel addGestureRecognizer:labelTap];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveChangedAct:)];
    [barItem setTitleTextAttributes:@{
                                     NSFontAttributeName:[UIFont systemFontOfSize:16 *ScreenRatio_6],
                                     NSForegroundColorAttributeName:KMainTextColor_3} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barItem;
    self.navigationItem.title = @"性别";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"箭头左"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAct)];
    
}

- (void)labelTapAct{
    self.pickTableView.hidden = NO;

}

- (void)backButtonAct{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveChangedAct:(UIBarButtonItem *)barButtonItem{
    if (![self.userGenderTemp isEqualToString:self.genderLabel.text]) {
        if (![SVProgressHUD isVisible]) {
            [SVProgressHUD showInfoWithStatus:@"正在保存..."];
        }
        WLKTUserinfoChangeApi *api = [[WLKTUserinfoChangeApi alloc]initWithUsername:TheCurUser.truename sex:self.genderLabel.text phone:TheCurUser.phone hobby:nil];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [SVProgressHUD dismiss];
            //保存更改
            TheCurUser.sex = self.genderLabel.text;
            [WLKTLogin saveUserData:TheCurUser];
            dispatch_async(dispatch_get_main_queue(), ^{
                !self.userGenderBlock ?: self.userGenderBlock(self.genderLabel.text);
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(__kindof YTKBaseRequest *request) {
            ShowApiError;
        }];

    }
    else{
        [SVProgressHUD showInfoWithStatus:@"请输入新信息"];
    }
//    else{
//        [SVProgressHUD showErrorWithStatus:@"性别不能为空"];
//    }
   
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.genderArr[indexPath.section];
    cell.backgroundColor = userinfoBgColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.genderLabel.text = self.genderArr[indexPath.section];
    self.pickTableView.hidden = YES;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        separatorView.backgroundColor = separatorView_color;
        return separatorView;
    }
    else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    separatorView.backgroundColor = separatorView_color;
    return separatorView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

#pragma mark - get

- (UITableView *)pickTableView{
    if (!_pickTableView) {
        _pickTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -IphoneXBottomInsetHeight) style:UITableViewStylePlain];
        _pickTableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _pickTableView.scrollEnabled = NO;
        _pickTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _pickTableView;
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 15 * ScreenRatio_6, ScreenWidth, 44 * ScreenRatio_6)];
        _labelBgView.backgroundColor = [UIColor whiteColor];
    }
    return _labelBgView;
}

- (UILabel *)genderLabel{
    if (!_genderLabel) {
        _genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * ScreenRatio_6, 0, ScreenWidth - 10 * ScreenRatio_6, 44 * ScreenRatio_6)];
        _genderLabel.font = [UIFont systemFontOfSize:16 * ScreenRatio_6];
        _genderLabel.backgroundColor = [UIColor whiteColor];
        _genderLabel.textColor = userLabelColor;
        _genderLabel.userInteractionEnabled = YES;
        _genderLabel.text = self.userGenderTemp;
    }
    return _genderLabel;
}

- (UIView *)separatorView_one{
    if (!_separatorView_one) {
        _separatorView_one = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        _separatorView_one.backgroundColor = separatorView_color;
    }
    return _separatorView_one;
}

- (UIView *)separatorView_two{
    if (!_separatorView_two) {
        _separatorView_two = [[UIView alloc]initWithFrame:CGRectMake(0, 43 * ScreenRatio_6, ScreenWidth, 1)];
        _separatorView_two.backgroundColor = separatorView_color;
    }
    return _separatorView_two;
}

- (NSArray *)genderArr{
    if (!_genderArr) {
        _genderArr = @[@"男", @"女"];
    }
    return _genderArr;
}

- (NSString *)userGenderTemp{
    if (!_userGenderTemp) {
        _userGenderTemp = TheCurUser.sex ? TheCurUser.sex : @"" ;
    }
    return _userGenderTemp;
}

//- (UIButton *)genderBtn{
//    if (!_genderBtn) {
//        _genderBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15 * ScreenRatio_6, ScreenWidth, 40 * ScreenRatio_6)];
//        _genderBtn.backgroundColor = [UIColor whiteColor];
//        _genderBtn.titleLabel.font = [UIFont systemFontOfSize:14 * ScreenRatio_6];
//        [_genderBtn setTitleColor:userLabelColor forState:UIControlStateNormal];
//        _genderBtn.layer.borderWidth = 0.5;
//        _genderBtn.layer.borderColor = userLabelColor.CGColor;
//    }
//    return _genderBtn;
//}

@end
