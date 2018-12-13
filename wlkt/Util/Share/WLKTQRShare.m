//
//  WLKTQRShare.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/9/1.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTQRShare.h"

#define screenShotRatio (667 - 160)/667

@implementation WLKTQRShare

+ (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType image:(UIImage *_Nonnull)image {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSNSPush"];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //    if (message) {
    //        //设置文本
    //        messageObject.text = message;
    //
    //    }
//    UMShareWebpageObject *web = [UMShareWebpageObject shareObjectWithTitle:title descr:detail thumImage:urlImage];
//    web.webpageUrl = url;
//    messageObject.shareObject = web;
    //创建图片内容对象

     UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
     //如果有缩略图，则设置缩略图
//     if (image) {
//     shareObject.thumbImage = image;
//     }

     [shareObject setShareImage:image];
     //分享消息对象设置分享内容对象
     messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isSNSPush"];
            NSLog(@"分享成功——————response data is %@",data);
        }
    }];
}

+ (UIImage *_Nonnull)combineScreenshotsImage:(UIImage *_Nonnull)screenImage URLString:(NSString *)url{
    UIImage *QRImage = [self createQRImageWithWidth:ScreenWidth * screenShotRatio URLString:url];
    CGSize size = CGSizeMake(ScreenWidth * screenShotRatio, ScreenHeight * screenShotRatio + QRImage.size.height * screenShotRatio);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [screenImage drawInRect:CGRectMake(0, 0, ScreenWidth * screenShotRatio, ScreenHeight * screenShotRatio)];
    [QRImage drawInRect:CGRectMake(0, ScreenHeight * screenShotRatio, ScreenWidth * screenShotRatio, QRImage.size.height * screenShotRatio)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *_Nonnull) createQRForString:(NSString *_Nonnull)qrString logo:(NSString *__nullable)logoImageName{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    //创建一个二维码的滤镜
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *qrCIImage = qrFilter.outputImage;//拿到二维码图片
    
    // 创建一个颜色滤镜,黑白色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setDefaults];
    [colorFilter setValue:qrCIImage forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    // 返回二维码image
    UIImage *codeImage = [UIImage imageWithCIImage:[colorFilter.outputImage imageByApplyingTransform:CGAffineTransformMakeScale(3.7, 3.7)]];
    CIContext *context = [CIContext context];
    CIImage *ciimg = [qrCIImage imageByApplyingTransform:CGAffineTransformMakeScale(3.7, 3.7)];
    CGImageRef cgimg = [context createCGImage:ciimg fromRect:ciimg.extent];
    
    // 中间一般放logo
    if (logoImageName) {
        UIImage *logo = [UIImage imageNamed:logoImageName];
        CGRect rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height);
        UIGraphicsBeginImageContext(rect.size);
        [codeImage drawInRect:rect];
        CGSize avatarSize = CGSizeMake(rect.size.width * 0.25, rect.size.height * 0.25);
        CGFloat x = (rect.size.width - avatarSize.width) * 0.5;
        CGFloat y = (rect.size.height - avatarSize.height) * 0.5;
        [logo drawInRect:CGRectMake(x, y, avatarSize.width, avatarSize.height)];
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;//返回带logo的二维码
    }
    //不带logo
    return [UIImage imageWithCGImage:cgimg];
}

+ (UIImage *)createQRImageWithWidth:(CGFloat)width URLString:(NSString *)url {
    CGRect rect = CGRectMake(0, 0, width, 105);
    UIView *v = [[UIView alloc]initWithFrame:rect];
    v.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    UIImageView *qrIV = [[UIImageView alloc]initWithImage:[[self createQRForString:url logo:@"placeholder_logo"] imageByInsetEdge:UIEdgeInsetsMake(-8, -8, -8, -8) withColor:[UIColor whiteColor]]];
    qrIV.backgroundColor = [UIColor whiteColor];
    qrIV.frame = CGRectMake(20 * ScreenRatio_6 * screenShotRatio, 10, 85, 85);

    UILabel *title_1 = [[UILabel alloc]initWithFrame:CGRectMake(25 * ScreenRatio_6 + qrIV.size.width, 13, 250 * ScreenRatio_6, 15)];
    title_1.font = [UIFont systemFontOfSize:13];
    title_1.textColor = KMainTextColor_3;
    title_1.text = @"长按图片识别二维码";
    
    UILabel *title_2 = [[UILabel alloc]initWithFrame:CGRectMake(25 * ScreenRatio_6 + qrIV.size.width, 35, 250 * ScreenRatio_6, 15)];
    title_2.font = [UIFont systemFontOfSize:13];
    title_2.textColor = KMainTextColor_3;
    title_2.text = @"快速查看原文及更多精彩内容";
    UILabel *title_3 = [[UILabel alloc]initWithFrame:CGRectMake(25 * ScreenRatio_6 + qrIV.size.width, 55, 250 * ScreenRatio_6, 15)];
    title_3.font = [UIFont systemFontOfSize:13];
    title_3.textColor = KMainTextColor_3;
    title_3.text = @"学校入驻，收入翻番";
    
    UILabel *title_4 = [[UILabel alloc]initWithFrame:CGRectMake(25 * ScreenRatio_6 + qrIV.size.width, 75, 250 * ScreenRatio_6, 15)];
    title_4.font = [UIFont systemFontOfSize:13];
    title_4.textColor = KMainTextColor_3;
    title_4.text = @"请致电400-028-3996";
    [v addSubview:qrIV];
    [v addSubview:title_1];
    [v addSubview:title_2];
    [v addSubview:title_3];
    [v addSubview:title_4];
//    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(85, 85));
//        make.top.mas_equalTo(v).offset(10);
//        make.left.mas_equalTo(v).offset(20 * ScreenRatio_6);
//    }];
//    [title_1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(qrIV.mas_right).offset(5);
//        make.top.mas_equalTo(v).offset(35);
//    }];
//    [title_2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(qrIV.mas_right).offset(5);
//        make.top.mas_equalTo(title_1.mas_bottom).offset(2);
//    }];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
+ (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    //if (UIInterfaceOrientationIsPortrait(orientation)){
        imageSize = [UIScreen mainScreen].bounds.size;
    //}
//    else{
//        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

// 返回截取到的图片
+ (UIImage *_Nonnull)imageWithScreenshot{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

@end
