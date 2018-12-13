//
//  WLKTConfirmOrderHeadCell.h
//  wlkt
//
//  Created by nanbojiaoyu on 2017/8/28.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKTCourseDetailData.h"
#import "WLKTCourseManjianData.h"
#import "WLKTCourseDetailCouponAlert.h"
#import "WLKTCDData.h"

@protocol couponHeadCellDelegate <NSObject>
@optional
- (void)didSelectedTotalCourse:(NSInteger)total;
@end

NS_ASSUME_NONNULL_BEGIN
@interface WLKTConfirmOrderHeadCell : UITableViewCell
@property (weak, nonatomic) id<couponHeadCellDelegate> delegate;
- (instancetype)initWithCourse:(WLKTCDData *)data oneprice:(WLKTCDOneprice *)oneprice courseNumber:(NSInteger)courseNumber manjian:(NSArray<WLKTCourseManjianData *> *)manjian isPingou:(BOOL)isPingou priceName:(NSString *)priceName;

@end
NS_ASSUME_NONNULL_END