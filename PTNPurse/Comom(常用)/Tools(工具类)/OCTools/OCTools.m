//
//  OCTools.m
//  DHSWallet
//
//  Created by tam on 2018/1/22.
//  Copyright © 2018年 zhengyi. All rights reserved.
//

#import "OCTools.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@implementation OCTools

+(void)registerShareSDK{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxcb9de830698d0826"
                                                        appSecret:@"98c95c5589584aad04153f563890e599"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106750559"
                                      appKey:@"FgOnVlPbRzRRyGAt"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

+(void)shareConfigurationShareText:(NSString *)text shareTitle:(NSString *)title shareImageArray:(NSArray *)imagesArray url:(NSString *)url{
    //1、创建分享参数
    NSArray* imageArray = imagesArray;
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:text
                                         images:@[[UIImage imageNamed:@"ic_launcher"]]
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
//
//        [shareParams SSDKSetupQQParamsByText:text title:title url:url thumbImage:imagesArray image:imagesArray type:SSDKContentTypeText forPlatformSubType:SSDKPlatformSubTypeQZone]
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
  items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)
                                         ]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }
}

+(BOOL)existenceDecimal:(NSString *)text Range:(NSRange)range replacementString:(NSString *)string{
    NSMutableString * futureString = [NSMutableString stringWithString:text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 4;//小数点后需要限制的个数
    for (int i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return true;
}

+(BOOL)isPositionTextViewDidChange:(UITextView *)textView{
    NSString *lang = textView.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计、限制等处理
        if (!position) {
            return true;
        }else{
            // 有高亮选择的字符串，则暂不对文字进行统计、限制等处理
            return false;
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        return true;
    }
}

+(BOOL)isPositionTextFieldDidChange:(UITextField *)textField{
    NSString *lang = textField.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计、限制等处理
        if (!position) {
            return true;
        }else{
            // 有高亮选择的字符串，则暂不对文字进行统计、限制等处理
            return false;
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        return true;
    }
}

+(BOOL)hasString:(NSString *)str otherStr:(NSString *)otherStr{
    if([str rangeOfString:otherStr].location!=NSNotFound){
        return YES;
    }
    return NO;
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(BOOL)existenceDecimal:(NSString *)text Range:(NSRange)range replacementString:(NSString *)string num:(NSInteger)num{
    NSMutableString * futureString = [NSMutableString stringWithString:text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = num;//小数点后需要限制的个数
    for (int i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return true;
}
    
+ (UIViewController *)getCurrentVC{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal){
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for(UIWindow * tmpWin in windows){
            
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
        
    }
    return result;
}

+ (NSString *)formatFloat:(float)f
{
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else if (fmodf(f*100, 1)==0){
        return [NSString stringWithFormat:@"%.2f",f];
    }else if (fmodf(f*1000, 1)==0){
        return [NSString stringWithFormat:@"%.3f",f];
    }else if (fmodf(f*10000, 1)==0){
        return [NSString stringWithFormat:@"%.4f",f];
    }else if (fmodf(f*100000, 1)==0){
        return [NSString stringWithFormat:@"%.5f",f];
    }else{
        return [NSString stringWithFormat:@"%.6f",f];
    }
}

//获取小数点的位数
+(CGFloat)getDecimalsNum:(float)f{
    CGFloat powNum = 0;
    NSString *str = [NSString stringWithFormat:@"%f",f];
    if ((f > -1) && ([str rangeOfString:@"."].location == NSNotFound)) {
        return 1;
    }
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return 0;
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return 0.1;
    } else if (fmodf(f*100, 1)==0){
        return 0.01;
    }else if (fmodf(f*1000, 1)==0){
        return 0.001;
    }else if (fmodf(f*10000, 1)==0){
        return 0.0001;
    }else if (fmodf(f*100000, 1)==0){
        return 0.00001;
    }else if (fmodf(f*1000000, 1)==0){
        return 0.000001;
    }else{
        return powNum;
    }
}

//获取当前小数位数
+(CGFloat)getDecimalsOfPlaces:(float)f{
    CGFloat powNum = 0;
    NSString *str = [NSString stringWithFormat:@"%f",f];
    if ((f > -1) && ([str rangeOfString:@"."].location == NSNotFound)) {
        return 1;
    }
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return 1;
    } else if (fmodf(f*10, 1)==0) {
        return 10;
    } else if (fmodf(f*100, 1)==0){
        return 100;
    }else if (fmodf(f*1000, 1)==0){
        return 1000;
    }else if (fmodf(f*10000, 1)==0){
        return 10000;
    }else if (fmodf(f*100000, 1)==0){
        return 100000;
    }else if (fmodf(f*1000000, 1)==0){
        return 10000000;
    }else{
        return powNum;
    }
}

+(NSString *)decimalNumberWithDouble:(double)conversionValue
{
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect
             centerBool:(BOOL)centerBool{
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    float imgWidth = image.size.width;
    float imgHeight = image.size.height;
    float viewWidth = mCGRect.size.width;
    float viewHidth = mCGRect.size.height;
    CGRect rect;
    if(centerBool){
        rect = CGRectMake((imgWidth-viewWidth)/2,(imgHeight-viewHidth)/2,viewWidth,viewHidth);
    }else{
        if(viewHidth < viewWidth){
            if(imgWidth <= imgHeight){
                rect = CGRectMake(0, 0, imgWidth, imgWidth*imgHeight/viewWidth);
            }else{
                float width = viewWidth*imgHeight/viewHidth;
                float x = (imgWidth - width)/2;
                if(x > 0){
                    rect = CGRectMake(x, 0, width, imgHeight);
                }else{
                    rect = CGRectMake(0, 0, imgWidth, imgWidth*viewHidth/viewWidth);
                }
            }
        }else{
            if(imgWidth <= imgHeight){
                float height = viewHidth*imgWidth/viewWidth;
                if(height < imgHeight){
                    rect = CGRectMake(0,0, imgWidth, height);
                }else{
                    rect = CGRectMake(0,0, viewWidth*imgHeight/viewHidth,imgHeight);
                }
            }else{
                float width = viewWidth * imgHeight / viewHidth;
                if(width < imgWidth){
                    float x = (imgWidth - width)/2;
                    rect = CGRectMake(x,0,width, imgHeight);
                }else{
                    rect = CGRectMake(0,0,imgWidth, imgHeight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0,0,CGImageGetWidth(subImageRef),CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+(NSString *)traversingString:(NSString *)string{
    //实现字符串的逆序
    string= [OCTools stringByReversed:string];
    NSString *traversingStr = string;
    for (int i = 0; i<[string length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:@"0"]) {
            NSRange range = NSMakeRange(0, 1);
            //将字符串中的“m”转化为“w”
            traversingStr =  [traversingStr stringByReplacingCharactersInRange:range withString:@""];
        }else{
            //终止循环
            break;
        }
    }
    NSString *positiveSequenceStr = [OCTools stringByReversed:traversingStr];
    return  positiveSequenceStr;
}

//字符串逆序
+(NSString *)stringByReversed:(NSString *)str
{
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=str.length; i>0; i--) {
        [s appendString:[str substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}

+(NSString *) toExponent:(double)d rms:(NSInteger)n
{
    if(n==0)
    {
        return nil;
    }
    //科学计算法 一般写法4.232E这种样式 这里的n代表所有数字的个数 所以这里n++
    n++;
    //判断小数的位数是否超过设定的n的值 如果超过了保留n位有效数字 如果不超过则保留默认小数位数
    //先将double转换成字符串
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *dbStr = [formatter stringFromNumber:[NSDecimalNumber numberWithDouble:d]];
    NSInteger length = dbStr.length;
    if ([dbStr containsString:@"."]) {
        length = dbStr.length - 1;
    }
    if (length < n) {
        n = length;
    }
    
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef customCurrencyFormatter = CFNumberFormatterCreate
    (NULL, currentLocale, kCFNumberFormatterCurrencyStyle);
    NSString *s_n = @"#";
    if(n > 1)
    {
        for(int j = 0; j < n; j++)
        {
            NSString *temp = s_n;
            if(j == 0)
            {
                s_n = [temp stringByAppendingString:@"."];
            }
            else
            {
                s_n = [temp stringByAppendingString:@"0"];
            }
            
        }
        
    }
    CFNumberFormatterSetFormat(customCurrencyFormatter, (CFStringRef)s_n);
    
    double i=1;
    int exponent = 0;
    while (1) {
        i = i*10;
        if(d < i)
        {
            break;
        }
        exponent++;
    }
    double n1 = d * 10 / i;
    
    CFNumberRef number1 = CFNumberCreate(NULL, kCFNumberDoubleType, &n1);
    CFStringRef string1 = CFNumberFormatterCreateStringWithNumber
    (NULL, customCurrencyFormatter, number1);
    NSLog(@"%@", (__bridge NSString *)string1);
    
    NSString * result = [NSString stringWithFormat:@"%@e%d",(__bridge NSString *)string1,exponent];
    
    CFRelease(currentLocale);
    CFRelease(customCurrencyFormatter);
    CFRelease(number1);
    CFRelease(string1);
    
    return result;
    
}

@end
