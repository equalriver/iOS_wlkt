//
//  WLKTTeamworkVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/11.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTTeamworkVC.h"
#import "PlaceholderTextView.h"
#import "WLKTLogin.h"
#import "WLKTUserTeamworkApi.h"

@interface WLKTTeamworkVC ()<UITextViewDelegate>
@property (strong, nonatomic) UIView *topContentView;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) PlaceholderTextView *messageTV;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UITextField *phoneTF;
@property (strong, nonatomic) UILabel *phoneTagLabel;
@property (strong, nonatomic) UILabel *teamworkLabel;
@property (strong, nonatomic) UIButton *guangGaoBtn;
@property (strong, nonatomic) UIButton *payBtn;
@property (strong, nonatomic) UIButton *flowBtn;
@property (strong, nonatomic) UIButton *otherBtn;

@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *phone;
@property (nonatomic) WLKTTeamworkType type;
@end

@implementation WLKTTeamworkVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view addSubview:self.topContentView];
        [self.topContentView addSubview:self.separatorView];
        [self.topContentView addSubview:self.messageLabel];
        [self.topContentView addSubview:self.messageTV];
        [self.topContentView addSubview:self.phoneLabel];
        [self.topContentView addSubview:self.phoneTF];
        [self.topContentView addSubview:self.phoneTagLabel];
        [self.topContentView addSubview:self.teamworkLabel];
        [self.topContentView addSubview:self.guangGaoBtn];
        [self.topContentView addSubview:self.payBtn];
        [self.topContentView addSubview:self.flowBtn];
        [self.topContentView addSubview:self.otherBtn];
        self.view.backgroundColor = separatorView_color;
        [self makeConstraints];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要合作";
    UIBarButtonItem *rigt = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAct)];
    self.navigationItem.rightBarButtonItem = rigt;
}

#pragma mark - network
- (void)teamworkConfirm{
    NSString *s = @"";
    switch (self.type) {
        case WLKTTeamworkTypeGuangGao:
            s = @"广告";
            break;
        case WLKTTeamworkTypePay:
            s = @"支付";
            break;
        case WLKTTeamworkTypeFlow:
            s = @"流量";
            break;
        case WLKTTeamworkTypeOther:
            s = @"其他";
            break;
        default:
            break;
    }
    WLKTUserTeamworkApi *api = [[WLKTUserTeamworkApi alloc]initWithDescribe:self.message phone:self.phone type:s];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [SVProgressHUD showSuccessWithStatus:request.responseJSONObject[@"message"]];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
}

#pragma mark - aciton
- (void)textViewDidChange:(UITextView *)textView{
    self.message = textView.text;
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

- (void)rightBarButtonAct{
    if (self.message.length < 5 || self.message.length > 200) {
        [SVProgressHUD showInfoWithStatus:@"描述内容太短或太长"];
        return;
    }
    if (![self.phone isValidPhoneNumber]) {
        [SVProgressHUD showInfoWithStatus:@"联系电话输入不正确"];
        return;
    }
    [self teamworkConfirm];
}

- (void)teamworkTypeAct:(UIButton *)sender{
    NSArray *arr = @[self.guangGaoBtn, self.payBtn, self.flowBtn, self.otherBtn];
    for (UIButton *b in arr) {
        if (b.tag == sender.tag) {
            b.selected = YES;
            self.type = b.tag;
        }
        else{
            b.selected = false;
        }
    }
}

#pragma mark - make constraints
- (void)makeConstraints{
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topContentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.topContentView).offset(30);
    }];
    [self.messageTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(270 * ScreenRatio_6, 100));
        make.left.mas_equalTo(self.messageLabel.mas_right).offset(13 * ScreenRatio_6);
        make.top.mas_equalTo(self.topContentView).offset(15);
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 30));
        make.top.mas_equalTo(self.messageTV.mas_bottom).offset(15);
        make.left.mas_equalTo(self.messageTV.mas_left);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topContentView).offset(10 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.phoneTF);
    }];
    [self.phoneTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTF.mas_bottom).offset(10);
        make.left.mas_equalTo(self.phoneTF);
        make.right.mas_equalTo(self.topContentView.mas_right).offset(-10 * ScreenRatio_6);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 5));
        make.top.mas_equalTo(self.phoneTagLabel.mas_bottom).offset(15);
    }];
    [self.teamworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.separatorView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.topContentView).offset(10 * ScreenRatio_6);
    }];
    [self.guangGaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topContentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.teamworkLabel.mas_bottom).offset(10);
    }];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.guangGaoBtn);
        make.left.mas_equalTo(self.guangGaoBtn.mas_right).offset(25 *ScreenRatio_6);
    }];
    [self.flowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.payBtn);
        make.left.mas_equalTo(self.payBtn.mas_right).offset(25 *ScreenRatio_6);
    }];
    [self.otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.flowBtn);
        make.left.mas_equalTo(self.flowBtn.mas_right).offset(25 *ScreenRatio_6);
    }];
}

#pragma mark - get
- (UIView *)topContentView{
    if (!_topContentView) {
        _topContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 275)];
        _topContentView.backgroundColor = [UIColor whiteColor];
    }
    return _topContentView;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = separatorView_color;
    }
    return _separatorView;
}
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.textColor = KMainTextColor_3;
        _messageLabel.text = @"合作描述：";
    }
    return _messageLabel;
}
- (PlaceholderTextView *)messageTV{
    if (!_messageTV) {
        _messageTV = [[PlaceholderTextView alloc]initWithPlaceholderColor:KMainTextColor_9 font:11];
        _messageTV.myPlaceholder = @"请输入想合作的内容(5~200个字)";
        _messageTV.font = [UIFont systemFontOfSize:12];
        _messageTV.textColor = KMainTextColor_3;
        _messageTV.layer.borderColor = KMainTextColor_9.CGColor;
        _messageTV.layer.borderWidth = 0.5;
        _messageTV.delegate = self;
    }
    return _messageTV;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.font = [UIFont systemFontOfSize:12];
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
        _phoneTF.font = [UIFont systemFontOfSize:11];
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
        _phoneTagLabel.font = [UIFont systemFontOfSize:10];
        _phoneTagLabel.textColor = KMainTextColor_9;
        _phoneTagLabel.text = @"请留下联系方式，以便尽快联系您，此联系方式不会对外公开。";
        _phoneTagLabel.numberOfLines = 0;
    }
    return _phoneTagLabel;
}
- (UILabel *)teamworkLabel{
    if (!_teamworkLabel) {
        _teamworkLabel = [UILabel new];
        _teamworkLabel.font = [UIFont systemFontOfSize:12];
        _teamworkLabel.textColor = KMainTextColor_3;
        _teamworkLabel.text = @"合作方式";
    }
    return _teamworkLabel;
}
- (UIButton *)guangGaoBtn{
    if (!_guangGaoBtn) {
        _guangGaoBtn = [UIButton new];
        _guangGaoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_guangGaoBtn setTitle:@" 广告" forState:UIControlStateNormal];
        [_guangGaoBtn setTitleColor:KMainTextColor_3 forState:UIControlStateNormal];
        [_guangGaoBtn setImage:[UIImage imageNamed:@"我的-未选中"] forState:UIControlStateNormal];
        [_guangGaoBtn setImage:[UIImage imageNamed:@"我的-打钩"] forState:UIControlStateSelected];
        [_guangGaoBtn addTarget:self action:@selector(teamworkTypeAct:) forControlEvents:UIControlEventTouchUpInside];
        _guangGaoBtn.tag = WLKTTeamworkTypeGuangGao;
        _guangGaoBtn.selected = YES;
    }
    return _guangGaoBtn;
}
- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton new];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_payBtn setTitle:@" 支付" forState:UIControlStateNormal];
        [_payBtn setTitleColor:KMainTextColor_3 forState:UIControlStateNormal];
        [_payBtn setImage:[UIImage imageNamed:@"我的-未选中"] forState:UIControlStateNormal];
        [_payBtn setImage:[UIImage imageNamed:@"我的-打钩"] forState:UIControlStateSelected];
        [_payBtn addTarget:self action:@selector(teamworkTypeAct:) forControlEvents:UIControlEventTouchUpInside];
        _payBtn.tag = WLKTTeamworkTypePay;
    }
    return _payBtn;
}
- (UIButton *)flowBtn{
    if (!_flowBtn) {
        _flowBtn = [UIButton new];
        _flowBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_flowBtn setTitle:@" 流量" forState:UIControlStateNormal];
        [_flowBtn setTitleColor:KMainTextColor_3 forState:UIControlStateNormal];
        [_flowBtn setImage:[UIImage imageNamed:@"我的-未选中"] forState:UIControlStateNormal];
        [_flowBtn setImage:[UIImage imageNamed:@"我的-打钩"] forState:UIControlStateSelected];
        [_flowBtn addTarget:self action:@selector(teamworkTypeAct:) forControlEvents:UIControlEventTouchUpInside];
        _flowBtn.tag = WLKTTeamworkTypeFlow;
    }
    return _flowBtn;
}
- (UIButton *)otherBtn{
    if (!_otherBtn) {
        _otherBtn = [UIButton new];
        _otherBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_otherBtn setTitle:@" 其他" forState:UIControlStateNormal];
        [_otherBtn setTitleColor:KMainTextColor_3 forState:UIControlStateNormal];
        [_otherBtn setImage:[UIImage imageNamed:@"我的-未选中"] forState:UIControlStateNormal];
        [_otherBtn setImage:[UIImage imageNamed:@"我的-打钩"] forState:UIControlStateSelected];
        [_otherBtn addTarget:self action:@selector(teamworkTypeAct:) forControlEvents:UIControlEventTouchUpInside];
        _otherBtn.tag = WLKTTeamworkTypeOther;
    }
    return _otherBtn;
}
@end
