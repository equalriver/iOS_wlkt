//
//  WLKTHPRecommendFoundCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/24.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTHPRecommendFoundCell.h"

@interface HPRecommendFoundCell: UICollectionViewCell
@property (strong, nonatomic) UIImageView *imgIV;
@end

@implementation HPRecommendFoundCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgIV];
        [self.imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(115 *ScreenRatio_6, 90 *ScreenRatio_6));
            make.center.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imgIV.image = nil;
}

- (UIImageView *)imgIV{
    if (!_imgIV) {
        _imgIV = [UIImageView new];
        _imgIV.layer.masksToBounds = YES;
    }
    return _imgIV;
}

@end


//****************************************************************************************
@interface WLKTHPRecommendFoundCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *classifyLabel;
@property (strong, nonatomic) UILabel *sourseLabel;
@property (strong, nonatomic) UIImageView *commentIV;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) UIView *separatorView;
//@property (strong, nonatomic) UIImageView *videoTagIV;
@property (strong, nonatomic) UIImageView *videoIV;
@property (strong, nonatomic) UICollectionView *imgCV;
@property (strong, nonatomic) WLKTNewsNormalNewsList *data;
@end

@implementation WLKTHPRecommendFoundCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.classifyLabel];
        [self.contentView addSubview:self.sourseLabel];
        [self.contentView addSubview:self.commentIV];
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.separatorView];
        [self makeConstraints];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.classifyLabel.text = nil;
    self.sourseLabel.text = nil;
    self.commentLabel.text = nil;
    self.imgCV = nil;
    self.videoIV = nil;
}

- (void)setCellData:(WLKTNewsNormalNewsList *)data{
    _data = data;
    HPRecommendFoundType type = 0;
    switch (data.imglist.count) {
        case 0: case 2:
            type = HPRecommendFoundTypeTextOnly;
            break;
        case 1:
            type = HPRecommendFoundTypeOneImage;
            break;
        default:
            type = HPRecommendFoundTypeMoreImage;
            break;
    }
    if (type == HPRecommendFoundTypeMoreImage) {
        [self.contentView addSubview:self.imgCV];
        [self.imgCV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10 *ScreenRatio_6);
            make.left.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 95 *ScreenRatio_6));
        }];
    }
    if (type == HPRecommendFoundTypeOneImage) {
        [self.contentView addSubview:self.videoIV];
        NSString *urlStr = [NSString stringWithFormat:@"%@", data.imglist.firstObject];
        [self.videoIV setImageURL:[NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-10 *ScreenRatio_6);
            make.top.mas_equalTo(self.contentView).offset(15 *ScreenRatio_6);
            make.size.mas_equalTo(CGSizeMake(120 *ScreenRatio_6, 80 *ScreenRatio_6));
        }];

        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
            make.top.mas_equalTo(self.contentView).offset(15 *ScreenRatio_6);
            make.right.mas_equalTo(self.videoIV.mas_left).offset(-10 *ScreenRatio_6);
        }];
        
        NSString *s = [NSString stringWithFormat:@"%@·%@", data.from, data.displaytime];
        [self.sourseLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.classifyLabel.mas_right).offset(5);
            make.width.mas_equalTo(s.length *13 > 115 ? 115 : s.length *13);
            make.centerY.mas_equalTo(self.classifyLabel);
        }];
        
    }
    self.titleLabel.text = data.title;
    self.classifyLabel.text = data.newstag;
    self.classifyLabel.textColor = [UIColor colorWithHexString:data.tagcolor];
    self.classifyLabel.layer.borderColor = [UIColor colorWithHexString:data.tagcolor].CGColor;
    self.sourseLabel.text = [NSString stringWithFormat:@"%@·%@", data.from, data.displaytime];
    self.commentLabel.text = [NSString stringWithFormat:@"评论 %@", data.comment_num];
    
    [self.classifyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(data.newstag.length * 15, 15));
    }];
}


#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.imglist.count > 3 ? 3 : self.data.imglist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HPRecommendFoundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HPRecommendFoundCell" forIndexPath:indexPath];
    [cell.imgIV setImageURL:[NSURL URLWithString:self.data.imglist[indexPath.item]]];
    return cell;
}

- (void)makeConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(15 *ScreenRatio_6);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView);
    }];
    [self.classifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
        make.size.mas_equalTo(CGSizeMake(30, 15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10 *ScreenRatio_6);
    }];
    [self.sourseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.classifyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.classifyLabel);
    }];
    [self.commentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourseLabel.mas_right).offset(20 *ScreenRatio_6);
        make.centerY.mas_equalTo(self.classifyLabel);
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentIV.mas_right).offset(5);
        make.centerY.mas_equalTo(self.classifyLabel);
    }];
}

#pragma mark - get
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17 *ScreenRatio_6 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
- (UILabel *)classifyLabel{
    if (!_classifyLabel) {
        _classifyLabel = [UILabel new];
        _classifyLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _classifyLabel.textColor = KMainTextColor_9;
        _classifyLabel.layer.borderWidth = 0.5;
        _classifyLabel.layer.cornerRadius = 3;
        _classifyLabel.layer.masksToBounds = YES;
        _classifyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _classifyLabel;
}
- (UILabel *)sourseLabel{
    if (!_sourseLabel) {
        _sourseLabel = [UILabel new];
        _sourseLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _sourseLabel.textColor = KMainTextColor_9;
    }
    return _sourseLabel;
    
}
- (UIImageView *)commentIV{
    if (!_commentIV) {
        _commentIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"编辑"]];
    }
    return _commentIV;
}
- (UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [UILabel new];
        _commentLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _commentLabel.textColor = KMainTextColor_9;
    }
    return _commentLabel;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = separatorView_color;
    }
    return _separatorView;
}
//- (UIImageView *)videoTagIV{
//    if (!_videoTagIV) {
//        _videoTagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新闻视频"]];
//    }
//    return _videoTagIV;
//}
- (UIImageView *)videoIV{
    if (!_videoIV) {
        _videoIV = [UIImageView new];

    }
    return _videoIV;
}
- (UICollectionView *)imgCV{
    if (!_imgCV) {
        UICollectionViewFlowLayout *l = [UICollectionViewFlowLayout new];
        l.itemSize = CGSizeMake(115 * ScreenRatio_6, 90 *ScreenRatio_6);
        l.minimumLineSpacing = 1;
        l.minimumInteritemSpacing = 1;
        l.sectionInset = UIEdgeInsetsMake(0, 10 *ScreenRatio_6, 0, 10 *ScreenRatio_6);
        _imgCV = [[UICollectionView alloc]initWithFrame:CGRectNull collectionViewLayout:l];
        _imgCV.dataSource = self;
        _imgCV.delegate = self;
        _imgCV.backgroundColor = UIColorHex(ffffff);
        _imgCV.showsHorizontalScrollIndicator = false;
        _imgCV.userInteractionEnabled = false;
        [_imgCV registerClass:[HPRecommendFoundCell class] forCellWithReuseIdentifier:@"HPRecommendFoundCell"];
    }
    return _imgCV;
}
@end

