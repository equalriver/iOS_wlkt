//
//  WLKTCDData.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/3/29.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTCDData.h"

@implementation WLKTCDData
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"topimage": [CDDataTopImage class],
             @"youhui": [WLKTCDDataYouhui class],
             @"yhq": [WLKTCDDataCoupon class],
             @"license": [CDDataLicense class],
             @"tlist": [CDDataTlist class],
             @"point": [WLKTCDDataPoint class],
             @"aboutlist": [WLKTCDDataAboutlist class],
             @"price_system": [WLKTCDDataPriceSystem class],
             @"pg_price_system": [WLKTCDDataPriceSystem class]
             };
}

@end


@implementation CDDataTopImage

@end

@implementation CDDataLicense

@end

@implementation CDDataTlist

@end