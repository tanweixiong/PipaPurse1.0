//
//  InputPaymentPasswordVw.h
//  FoodFamily
//
//  Created by tam on 2017/11/16.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentAlertVw.h"
@protocol PaymentPasswordDelegate <NSObject>
- (NSString *)inputPaymentPassword:(NSString *)pwd;
@optional
/** 输入完成后进行回调 */
-(void)inputPaymentPasswordChangeForgetPassword;
@end
@interface PaymentPasswordVw : UIView
@property (nonatomic,assign)BOOL isNormal;
@property (nonatomic,strong)PaymentAlertVw *paymentPasswordAlertVw;
@property (nonatomic, weak) id<PaymentPasswordDelegate> delegate;
- (void)show;
- (instancetype)initWithFrame:(CGRect)frame isNormal:(BOOL)isNormal;
- (instancetype)initWithFrame:(CGRect)frame;
@end
