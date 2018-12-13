//
//  WLKTWLKTGetCouponCell.m
//  wlkt
//
//  Created by 尹平江 on 2017/8/16.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTGetCouponCell.h"


@implementation WLKTGetCouponCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgIV];
        [self.contentView addSubview:self.priceFixLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.couponLabel];
        [self.contentView addSubview:self.couponDetailLabel];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.separatorView_1];
        [self.contentView addSubview:self.separatorView_2];
        [self.contentView addSubview:self.getCouponLabel];
        
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.bgIV.image = nil;
    self.priceLabel.text = nil;
    self.couponLabel.text = nil;
    self.couponDetailLabel.text = nil;
    self.bottomLabel.text = nil;
    self.getCouponLabel.text = nil;
}

- (void)setCellData:(WLKTCouponCenterData *)data{
    if (data) {
        if (data.color.intValue == 0) {//优惠券面额的颜色区分,0是红色,1是黄色
            self.bgIV.image = [UIImage imageNamed:@"领券中心优惠券1"];
        }
        else{
            self.bgIV.image = [UIImage imageNamed:@"领券中心优惠券2"];
        }
        if (data.cstatus.intValue == 1) {//优惠券状态 1可以领取,0已经领完
            if (data.ustatus.intValue == 0) {
                self.getCouponLabel.text = @"立即领取";
            }
            else{
                self.getCouponLabel.text = @"马上逛逛";
            }
        }
        else{
            self.getCouponLabel.text = @"已领完";
        }
        self.couponLabel.text = data.name;
        self.couponDetailLabel.text = data.rule;
        self.priceLabel.text = data.money;
        self.bottomLabel.text = data.school;
        [self.priceLabel sizeToFit];
        [self makeConstraintsData:data];
    }
}

#pragma mark - makeConstraints
- (void)makeConstraintsData:(WLKTCouponCenterData *)data{
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20 * ScreenRatio_6, 80 * ScreenRatio_6));
        make.center.mas_equalTo(self.contentView);
    }];
    [self.priceFixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 15));
        make.left.mas_equalTo(self.contentView).offset(53 * ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(35 * ScreenRatio_6);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([data.money getSizeWithHeight:30 Font:35]);
        make.left.mas_equalTo(self.priceFixLabel.mas_right);
        make.bottom.mas_equalTo(self.priceFixLabel.mas_bottom).offset(7);
    }];
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(135, 15));
        make.right.mas_equalTo(self.getCouponLabel.mas_left);
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(7 * ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(20 * ScreenRatio_6);
    }];
    [self.couponDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.couponLabel);
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(7 * ScreenRatio_6);
        make.top.mas_equalTo(self.couponLabel.mas_bottom);
    }];
    [self.separatorView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35 * ScreenRatio_6, 0.5));
        make.left.mas_equalTo(self.contentView).offset(35 * ScreenRatio_6);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20 * ScreenRatio_6);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140 * ScreenRatio_6, 15));
        make.centerY.mas_equalTo(self.separatorView_1);
        make.left.mas_equalTo(self.separatorView_1.mas_right);
    }];
    [self.separatorView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35 * ScreenRatio_6, 0.5));
        make.left.mas_equalTo(self.bottomLabel.mas_right);
        make.centerY.mas_equalTo(self.separatorView_1);
    }];
    [self.getCouponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

#pragma mark - get
- (UIImageView *)bgIV{
    if (!_bgIV) {
        _bgIV = [[UIImageView alloc]init];
    }
    return _bgIV;
}
- (UILabel *)priceFixLabel{
    if (!_priceFixLabel) {
        _priceFixLabel = [[UILabel alloc]init];
        _priceFixLabel.font = [UIFont systemFontOfSize:14];
        _priceFixLabel.textColor = [UIColor colorWithHexString:@"#f85f54"];
        _priceFixLabel.textAlignment = NSTextAlignmentRight;
        _priceFixLabel.text = @"¥";
    }
    return _priceFixLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = [UIFont systemFontOfSize:34];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#f85f54"];
    }
    return _priceLabel;
}
- (UILabel *)couponLabel{
    if (!_couponLabel) {
        _couponLabel = [[UILabel alloc]init];
        _couponLabel.font = [UIFont systemFontOfSize:14];
        _couponLabel.textColor = [UIColor colorWithHexString:@"#f85f54"];
        _couponLabel.numberOfLines = 1;
    }
    return _couponLabel;
}
- (UILabel *)couponDetailLabel{
    if (!_couponDetailLabel) {
        _couponDetailLabel = [[UILabel alloc]init];
        _couponDetailLabel.font = [UIFont systemFontOfSize:14];
        _couponDetailLabel.textColor = [UIColor colorWithHexString:@"#f85f54"];
        _couponDetailLabel.numberOfLines = 1;
    }
    return _couponDetailLabel;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textColor = [UIColor colorWithHexString:@"#c3c3c3"];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}
- (UIView *)separatorView_1{
    if (!_separatorView_1) {
        _separatorView_1 = [[UIView alloc]init];
        _separatorView_1.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8"];
    }
    return _separatorView_1;
}
- (UIView *)separatorView_2{
    if (!_separatorView_2) {
        _separatorView_2 = [[UIView alloc]init];
        _separatorView_2.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8"];
    }
    return _separatorView_2;
}
- (UILabel *)getCouponLabel{
    if (!_getCouponLabel) {
        _getCouponLabel = [[UILabel alloc]init];
        _getCouponLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _getCouponLabel.font = [UIFont systemFontOfSize:15];
        _getCouponLabel.textAlignment = NSTextAlignmentRight;
    }
    return _getCouponLabel;
}

@end
