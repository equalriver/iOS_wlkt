//
//  WLKTCourseDetailImagesCollectionCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/11/16.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTCourseDetailImagesCollectionCell.h"

@interface WLKTCourseDetailImagesCollectionCell ()
@property (strong, nonatomic) UIImageView *imgIV;
@end

@implementation WLKTCourseDetailImagesCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgIV];
    }
    return self;
}

- (void)setCellData:(NSString *)data{
    [self.imgIV setImageURL:[NSURL URLWithString:data]];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imgIV.image = nil;
}

- (UIImageView *)imgIV{
    if (!_imgIV) {
        _imgIV = [[UIImageView alloc]initWithFrame:self.bounds];
        _imgIV.layer.masksToBounds = YES;
    }
    return _imgIV;
}

@end
