//
//  WLKTAlipay.h
//  wlkt
//
//  Created by 尹平江 on 17/3/31.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLKTAlipay : NSObject
+ (void)AlipayWithGoodsName:(NSString *)goodsName
                     counts:(NSInteger)counts
                       suid:(NSString *)suid
                        uid:(NSString *)uid
                  classType:(NSString *)classType
                    address:(NSString *)address
                 personName:(NSString *)personName
                        age:(int)age
                      phone:(NSString *)phone
               total_amount:(NSString *)total_amount
                   pay_type:(NSString *)pay_type
                  school_mj:(NSString *)school_mj
                 school_yhq:(NSString *)school_yhq
                     pt_yhq:(NSString *)pt_yhq;
@end
