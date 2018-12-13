//
//  WLKTTianfuPay.m
//  wlkt
//
//  Created by 尹平江 on 17/3/31.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTTianfuPay.h"
#import "WLKTTianfuPayApi.h"
#import "WLKTTianfuPayVC.h"

@interface WLKTTianfuPay ()

@end

@implementation WLKTTianfuPay

+ (void)tianfuPayWithGoodsName :(NSString *)goodsName
                         counts:(NSInteger)counts
                           suid:(NSString *)suid
                            uid:(NSString *)uid
                      classType:(NSString *)classType
                        address:(NSString *)address
                     personName:(NSString *)personName
                            age:(int)age
                          phone:(NSString *)phone
                         target:(__kindof UIViewController *)vc
                       pay_type:(NSString *)pay_type
                      school_mj:(NSString *)school_mj
                     school_yhq:(NSString *)school_yhq
                         pt_yhq:(NSString *)pt_yhq
{
   __block NSString *url = nil;
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showProgress:-1 status:@"正在发起支付..."];
    }
    WLKTTianfuPayApi *api = [[WLKTTianfuPayApi alloc]initWithGoodsName:goodsName counts:counts suid:suid uid:uid classType:classType address:address personName:personName age:age phone:phone pay_type:pay_type school_mj:school_mj school_yhq:school_yhq pt_yhq:pt_yhq];

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",request.responseJSONObject);
        NSString *code = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"errorCode"]];
        if (![code isEqualToString:@"0"]) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", request.responseJSONObject[@"message"]]];
        }
        else{
            url = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"result"]];
            if (url) {
                WLKTTianfuPayVC *tianfu = [[WLKTTianfuPayVC alloc]init];
                tianfu.url = url;
                [vc.navigationController pushViewController:tianfu animated:YES];
                
            }
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
        NSLog(@"%ld", (long)request.responseStatusCode);
        //ShowApiError;
    }];
    
}

@end
