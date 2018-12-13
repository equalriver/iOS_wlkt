//
//  WLKTActivityDetail_Q_A_2_headerQuestionView.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/13.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTActivityDetail_Q_A_2_headerQuestionView.h"

@interface WLKTActivityDetail_Q_A_2_headerQuestionView ()
@property (strong, nonatomic) UIImageView *iconIV;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *username_timeLabel;
@property (strong, nonatomic) UIButton *answerBtn;
@property (nonatomic) NSInteger index;
@end

@implementation WLKTActivityDetail_Q_A_2_headerQuestionView
- (instancetype)initWithIndex:(NSInteger)index frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = index;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconIV];
        [self addSubview:self.detailLabel];
        [self addSubview:self.username_timeLabel];
        [self addSubview:self.answerBtn];
        [self makeConstraints];
    }
    return self;
}

- (void)setCellData:(WLKTActivityDetail_QA_question *)data{
    self.detailLabel.text = data.question;
    self.username_timeLabel.text = [NSString stringWithFormat:@"提问人：%@  提问时间：%@", data.username, data.create_time];
    if (data.answerlist.count >= 5) {
        self.answerBtn.hidden = YES;
    }
    else{
        self.answerBtn.hidden = false;
    }
    
}

- (void)answerBtnAct:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectedAnswerButtonAtIndex:)]) {
        [self.delegate didSelectedAnswerButtonAtIndex:self.index];
    }
}

- (void)makeConstraints{
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self).offset(15 * ScreenRatio_6);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconIV.mas_right).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.iconIV);
        make.right.mas_equalTo(self.answerBtn.mas_left).offset(-10 * ScreenRatio_6);
    }];
    [self.username_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.detailLabel);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(10 * ScreenRatio_6);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenRatio_6);
    }];
    [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(53, 17));
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenRatio_6);
        make.top.mas_equalTo(self).offset(15 * ScreenRatio_6);
    }];
}

#pragma mark - get
- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"问"]];
    }
    return _iconIV;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _detailLabel.textColor = KMainTextColor_3;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}
- (UILabel *)username_timeLabel{
    if (!_username_timeLabel) {
        _username_timeLabel = [UILabel new];
        _username_timeLabel.font = [UIFont systemFontOfSize:11 * ScreenRatio_6];
        _username_timeLabel.textColor = KMainTextColor_9;
    }
    return _username_timeLabel;
}
- (UIButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [UIButton new];
        _answerBtn.titleLabel.font = [UIFont systemFontOfSize:11 * ScreenRatio_6];
        [_answerBtn setTitle:@"我来回答" forState:UIControlStateNormal];
        [_answerBtn setTitleColor:UIColorHex(f6c447) forState:UIControlStateNormal];
        _answerBtn.layer.borderColor = UIColorHex(f6c447).CGColor;
        _answerBtn.layer.borderWidth = 0.5;
        _answerBtn.layer.masksToBounds = YES;
        _answerBtn.layer.cornerRadius = 2 * ScreenRatio_6;
        [_answerBtn addTarget:self action:@selector(answerBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerBtn;
}

@end

