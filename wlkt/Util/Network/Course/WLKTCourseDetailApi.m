//
//  WLKTCourseDetailApi.m
//  wlkt
//
//  Created by slovelys on 17/4/6.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTCourseDetailApi.h"

@interface WLKTCourseDetailApi ()
@property (copy, nonatomic) NSString *lat;
@property (copy, nonatomic) NSString *lng;
@property (copy, nonatomic) NSString *courseId;

@end

@implementation WLKTCourseDetailApi

- (instancetype)initWithCourseId:(NSString *)courseId latitude:(NSString *)lat longitude:(NSString *)lng{
    WLKT_INIT(
              _lat = lat;
              _lng = lng;
              _courseId = [courseId copy];
    )
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl {
    return  @"course3/details";
}

- (id)requestArgument {
    return @{
             @"lat": _lat,
             @"lng": _lng,
             @"id" : _courseId
             };
}

@end
