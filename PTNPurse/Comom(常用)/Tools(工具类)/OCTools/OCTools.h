//
//  OCTools.h
//  DHSWallet
//
//  Created by tam on 2018/1/22.
//  Copyright © 2018年 zhengyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
@end
