//
//  WLKTNews_Q_A_cell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/26.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTNews_Q_A_cell.h"

@interface WLKTNews_Q_A_cell ()
@property (strong, nonatomic) UIImageView *quesIconIV;
@property (strong, nonatomic) UILabel *quesLabel;
@property (strong, nonatomic) UILabel *quesname_timeLabel;

@property (strong, nonatomic) UIImageView *iconIV;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *username_timeLabel;
@property (strong, nonatomic) UIImageView *answerIV;
@end

@implementation WLKTNews_Q_A_cell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.contentView addSubview:self.quesIconIV];
        [self.contentView addSubview:self.quesLabel];
        [self.contentView addSubview:self.quesname_timeLabel];
        [self.contentView addSubview:self.iconIV];
        [self.contentView addSubview:self.answerIV];
        [self.answerIV addSubview:self.detailLabel];
        [self.answerIV addSubview:self.username_timeLabel];
        [self makeConstraints];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.quesLabel.text = nil;
    self.quesname_timeLabel.text = nil;
    self.detailLabel.text = nil;
    self.username_timeLabel.text = nil;
}

//- (void)setCellData:(WLKTNews_Q_A_list *)data{
//    self.detailLabel.text = data.answerlist.firstObject.result;
//    self.username_timeLabel.text = [NSString stringWithFormat:@"回答人：%@  回答时间：%@", data.answerlist.firstObject.username, data.answerlist.firstObject.create_time];
//}
- (void)setCellData:(WLKTNewsCommentList *)data{
    self.quesLabel.text = data.question;
    self.quesname_timeLabel.text = [NSString stringWithFormat:@"提问人：%@  提问时间：%@", data.username, data.displaytime];
    if (data.answerlist) {
        self.detailLabel.hidden = false;
        self.username_timeLabel.hidden = false;
        self.answerIV.hidden = false;
        self.iconIV.hidden = false;
        self.detailLabel.text = data.answerlist.answer;
        self.username_timeLabel.text = [NSString stringWithFormat:@"回答人：%@  回答时间：%@", data.answerlist.username, data.answerlist.create_time];
    }
    else{
        self.detailLabel.hidden = YES;
        self.username_timeLabel.hidden = YES;
        self.answerIV.hidden = YES;
        self.iconIV.hidden = YES;
    }
   
}

#pragma mark - make constraints
- (void)makeConstraints{
    [self.quesIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(15 *ScreenRatio_6);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    [self.quesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.quesIconIV.mas_right).offset(10 *ScreenRatio_6);
        make.centerY.mas_equalTo(self.quesIconIV);
        make.right.mas_equalTo(self.contentView).offset(-10 *ScreenRatio_6);
    }];
    [self.quesname_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.quesLabel);
        make.top.mas_equalTo(self.quesLabel.mas_bottom).offset(10 *ScreenRatio_6);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
    }];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
        make.top.mas_equalTo(self.quesname_timeLabel.mas_bottom).offset(11 *ScreenRatio_6);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    [self.answerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.quesname_timeLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
        make.left.mas_equalTo(self.iconIV.mas_right).offset(10 *ScreenRatio_6);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconIV.mas_right).offset(20 *ScreenRatio_6);
        make.top.mas_equalTo(self.answerIV).offset(5);
        make.right.mas_equalTo(self.answerIV.mas_right).offset(-5);
    }];
    [self.username_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.detailLabel);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(10 *ScreenRatio_6);

    }];
}

#pragma mark - get
- (UIImageView *)quesIconIV{
    if (!_quesIconIV) {
        _quesIconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"问"]];
    }
    return _quesIconIV;
}
- (UILabel *)quesLabel{
    if (!_quesLabel) {
        _quesLabel = [UILabel new];
        _quesLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _quesLabel.textColor = KMainTextColor_3;
        _quesLabel.numberOfLines = 1;
    }
    return _quesLabel;
}
- (UILabel *)quesname_timeLabel{
    if (!_quesname_timeLabel) {
        _quesname_timeLabel = [UILabel new];
        _quesname_timeLabel.font = [UIFont systemFontOfSize:11 *ScreenRatio_6];
        _quesname_timeLabel.textColor = KMainTextColor_9;
    }
    return _quesname_timeLabel;
}
- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"答"]];
    }
    return _iconIV;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _detailLabel.textColor = KMainTextColor_3;
        _detailLabel.numberOfLines = 1;
    }
    return _detailLabel;
}
- (UILabel *)username_timeLabel{
    if (!_username_timeLabel) {
        _username_timeLabel = [UILabel new];
        _username_timeLabel.font = [UIFont systemFontOfSize:11 *ScreenRatio_6];
        _username_timeLabel.textColor = KMainTextColor_9;
    }
    return _username_timeLabel;
}
- (UIImageView *)answerIV{
    if (!_answerIV) {
        _answerIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"气泡框"]];
    }
    return _answerIV;
}

@end

