//
//  WLKTActivityDetailSchoolCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/12.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTActivityDetailSchoolCell.h"

@interface WLKTActivityDetailSchoolCell ()
@property (strong, nonatomic) UIImageView *iconIV;
@property (strong, nonatomic) UILabel *schoolNameLabel;
@property (strong, nonatomic) UIImageView *rightArrowIV;

@end

@implementation WLKTActivityDetailSchoolCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.contentView addSubview:self.iconIV];
        [self.contentView addSubview:self.schoolNameLabel];
        [self.contentView addSubview:self.rightArrowIV];
        [self makeConstraints];
    }
    return self;
}

- (void)setCellData:(WLKTActivity *)data{
    self.schoolNameLabel.text = data.schoolname;
}

#pragma mark - make constaints
- (void)makeConstraints{
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15 * ScreenRatio_6);
    }];
    [self.schoolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconIV.mas_right).offset(10 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

#pragma mark - get
- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"学校"]];
    }
    return _iconIV;
}
- (UILabel *)schoolNameLabel{
    if (!_schoolNameLabel) {
        _schoolNameLabel = [[UILabel alloc]init];
        _schoolNameLabel.font = [UIFont systemFontOfSize:15 * ScreenRatio_6 weight:UIFontWeightSemibold];
        _schoolNameLabel.textColor = KMainTextColor_3;
    }
    return _schoolNameLabel;
}
- (UIImageView *)rightArrowIV{
    if (!_rightArrowIV) {
        _rightArrowIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"课程详情进入"]];
    }
    return _rightArrowIV;
}
@end

