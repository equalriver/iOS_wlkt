//
//  WLKTCourseDetailAppointment.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/10/27.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTCourseDetailAppointment.h"

@interface WLKTCourseDetailAppointment ()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *noticeLabel;
@property (strong, nonatomic) UIView *separatorView_1;
@property (strong, nonatomic) UILabel *phonePlaceholderLabel;
@property (strong, nonatomic) UITextField *phoneTF;
@property (strong, nonatomic) UILabel *detailPlaceholderLabel;
@property (strong, nonatomic) UITextView *detailTV;
@property (strong, nonatomic) UIImageView *bottomTagIcon_1;
@property (strong, nonatomic) UIImageView *bottomTagIcon_2;
@property (strong, nonatomic) UILabel *bottomTagLabel_1;
@property (strong, nonatomic) UILabel *bottomTagLabel_2;
@property (strong, nonatomic) UIButton *confirmBtn;

@end

@implementation WLKTCourseDetailAppointment
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
        //keyboard
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        self.userInteractionEnabled = YES;
        [UIView viewAnimateComeOutWithDuration:0.7 delay:0 target:self.contentView completion:^(BOOL finished) {
            
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [self endEditing:YES];
            [UIView viewAnimateDismissWithDuration:0.7 delay:0 target:self.contentView completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                }
            }];
        }];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)addViews{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.noticeLabel];
    [self.contentView addSubview:self.separatorView_1];
    [self.contentView addSubview:self.phonePlaceholderLabel];
    [self.contentView addSubview:self.phoneTF];
    [self.contentView addSubview:self.detailPlaceholderLabel];
    [self.contentView addSubview:self.detailTV];
    [self.contentView addSubview:self.bottomTagIcon_1];
    [self.contentView addSubview:self.bottomTagIcon_2];
    [self.contentView addSubview:self.bottomTagLabel_1];
    [self.contentView addSubview:self.bottomTagLabel_2];
    [self.contentView addSubview:self.confirmBtn];
    [self makeConstraints];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - action
- (void)confirmBtnAct:(UIButton *)sender{
    if (![self.phoneTF.text isValidPhoneNumber]) {
        [SVProgressHUD showInfoWithStatus:@"电话输入不正确或未输入"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(CourseDetailAppointmentConfirmPhone:detail:success:)]) {
        [self endEditing:YES];
        dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.25);
        dispatch_after(t, dispatch_get_main_queue(), ^{
            [self.delegate CourseDetailAppointmentConfirmPhone:self.phoneTF.text detail:self.detailTV.text success:^{
                [UIView viewAnimateDismissWithDuration:0.7 delay:0 target:self.contentView completion:^(BOOL finished) {
                    if (finished) {
                        [self removeFromSuperview];
                    }
                }];
            }];
        });
    }
}

- (void)phoneTFAct:(UITextField *)sender{
    if (sender.text.length > 11) {
        sender.text = [sender.text substringToIndex:11];
    }
}

#pragma mark - keyboard
- (void)keyboardFrameChange:(NSNotification *)noti{
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - self.frame.size.height);
}

#pragma mark - make constraints
- (void)makeConstraints{
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(40 * ScreenRatio_6);
    }];
    [self.separatorView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.top.mas_equalTo(self.noticeLabel.mas_bottom).offset(15 * ScreenRatio_6);
    }];
    [self.phonePlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.separatorView_1).offset(15 * ScreenRatio_6);
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(350 * ScreenRatio_6, 25));
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.phonePlaceholderLabel.mas_bottom).offset(10 * ScreenRatio_6);
    }];
    [self.detailPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.phoneTF.mas_bottom).offset(15 * ScreenRatio_6);
    }];
    [self.detailTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(350 * ScreenRatio_6, 80));
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.detailPlaceholderLabel.mas_bottom).offset(10 * ScreenRatio_6);
    }];
    [self.bottomTagIcon_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.detailTV.mas_bottom).offset(15 * ScreenRatio_6);
    }];
    [self.bottomTagLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 15));
        make.left.mas_equalTo(self.bottomTagIcon_1.mas_right).offset(5);
        make.centerY.mas_equalTo(self.bottomTagIcon_1);
    }];
    [self.bottomTagIcon_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.bottomTagLabel_1.mas_right);
        make.centerY.mas_equalTo(self.bottomTagIcon_1);
    }];
    [self.bottomTagLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomTagIcon_2.mas_right).offset(5);
        make.centerY.mas_equalTo(self.bottomTagIcon_1);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 50));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - get
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 410)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
        [_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [self endEditing:YES];
        }]];
    }
    return _contentView;
}
- (UILabel *)noticeLabel{
    if (!_noticeLabel) {
        _noticeLabel = [UILabel new];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"未来课堂独家优惠，预约即可获得：免费试听"];
        [str setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 * ScreenRatio_6], NSForegroundColorAttributeName: KMainTextColor_3} range:NSMakeRange(0, str.length - 4)];
        [str setAttributes:@{NSForegroundColorAttributeName: UIColorHex(f6c447), NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSFontAttributeName: [UIFont systemFontOfSize:13 * ScreenRatio_6]} range:NSMakeRange(str.length - 4, 4)];
        _noticeLabel.attributedText = str;
    }
    return _noticeLabel;
}
- (UIView *)separatorView_1{
    if (!_separatorView_1) {
        _separatorView_1 = [UIView new];
        _separatorView_1.backgroundColor = separatorView_color;
    }
    return _separatorView_1;
}
- (UILabel *)phonePlaceholderLabel{
    if (!_phonePlaceholderLabel) {
        _phonePlaceholderLabel = [UILabel new];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"请输入您的联系电话(方式)以便培训机构尽快联系您(必填)"];
        [str setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 * ScreenRatio_6], NSForegroundColorAttributeName: KMainTextColor_9} range:NSMakeRange(0, str.length - 4)];
        [str setAttributes:@{NSForegroundColorAttributeName: UIColorHex(37becc), NSFontAttributeName: [UIFont systemFontOfSize:12 * ScreenRatio_6]} range:NSMakeRange(str.length - 4, 4)];
        _phonePlaceholderLabel.attributedText = str;
    }
    return _phonePlaceholderLabel;
}
- (UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [UITextField new];
        _phoneTF.layer.borderColor = KMainTextColor_9.CGColor;
        _phoneTF.layer.borderWidth = 0.5;
        _phoneTF.tintColor = KMainTextColor_9;
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 25)];
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
//        _phoneTF.placeholder = @"请输入联系电话";
        _phoneTF.font = [UIFont systemFontOfSize:14];
        [_phoneTF addTarget:self action:@selector(phoneTFAct:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTF;
}
- (UILabel *)detailPlaceholderLabel{
    if (!_detailPlaceholderLabel) {
        _detailPlaceholderLabel = [UILabel new];
        _detailPlaceholderLabel.text = @"请输入想要学习课程的内容、时间安排等";
        _detailPlaceholderLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _detailPlaceholderLabel.textColor = KMainTextColor_9;
    }
    return _detailPlaceholderLabel;
}
- (UITextView *)detailTV{
    if (!_detailTV) {
        _detailTV = [UITextView new];
        _detailTV.layer.borderColor = KMainTextColor_9.CGColor;
        _detailTV.layer.borderWidth = 0.5;
        _detailTV.tintColor = KMainTextColor_9;
    }
    return _detailTV;
}
- (UIImageView *)bottomTagIcon_1{
    if (!_bottomTagIcon_1) {
        _bottomTagIcon_1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bz"]];
    }
    return _bottomTagIcon_1;
}
- (UIImageView *)bottomTagIcon_2{
    if (!_bottomTagIcon_2) {
        _bottomTagIcon_2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bz"]];
    }
    return _bottomTagIcon_2;
}
- (UILabel *)bottomTagLabel_1{
    if (!_bottomTagLabel_1) {
        _bottomTagLabel_1 = [UILabel new];
        _bottomTagLabel_1.text = @"无强行推销";
        _bottomTagLabel_1.textColor = KMainTextColor_3;
        _bottomTagLabel_1.font = [UIFont systemFontOfSize:11 * ScreenRatio_6];
    }
    return _bottomTagLabel_1;
}
- (UILabel *)bottomTagLabel_2{
    if (!_bottomTagLabel_2) {
        _bottomTagLabel_2 = [UILabel new];
        _bottomTagLabel_2.text = @"号码仅此机构可见";
        _bottomTagLabel_2.textColor = KMainTextColor_3;
        _bottomTagLabel_2.font = [UIFont systemFontOfSize:11 * ScreenRatio_6];
    }
    return _bottomTagLabel_2;
}
- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        _confirmBtn.backgroundColor = UIColorHex(33c4da);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:UIColorHex(ffffff) forState:UIControlStateNormal];
        _confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_confirmBtn addTarget:self action:@selector(confirmBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
@end
