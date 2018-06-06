//
//  OCTools.h
//  DHSWallet
//
//  Created by tam on 2018/1/22.
//  Copyright © 2018年 zhengyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"

@interface OCTools : NSObject
+(BOOL)existenceDecimal:(NSString *)text Range:(NSRange)range replacementString:(NSString *)string;
+(BOOL)isPositionTextViewDidChange:(UITextView *)textView;
+(BOOL)isPositionTextFieldDidChange:(UITextField *)textField;
+(BOOL)hasString:(NSString *)str otherStr:(NSString *)otherStr;
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;
+(BOOL)existenceDecimal:(NSString *)text Range:(NSRange)range replacementString:(NSString *)string num:(NSInteger)num;
+(void)registerShareSDK;
+(void)shareConfigurationShareText:(NSString *)text shareTitle:(NSString *)title shareImageArray:(NSArray *)imagesArray url:(NSString *)url;
+ (UIViewController *)getCurrentVC;
+ (NSString *)formatFloat:(float)f;
+(CGFloat)getDecimalsNum:(float)f;
+(CGFloat)getDecimalsOfPlaces:(float)f;
+(NSString *)decimalNumberWithDouble:(double)conversionValue;
//将图片裁剪成正方形
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect
            centerBool:(BOOL)centerBool;
//实现逆序功能
+(NSString *)traversingString:(NSString *)string;
//科学计数法保留4位
+(NSString *) toExponent:(double)d rms:(NSInteger)n;
+(BOOL)validateNumber:(NSString*)number;
+(NSString*)encrypt:(NSString*)plainText;
@end
