//
//  InputPaymentPasswordVw.h
//  FoodFamily
//
//  Created by tam on 2017/11/16.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentPasswordAlertVw.h"
typedef enum{
    balancePayment = 0,
    bankCardPayment = 1
} InputPaymentPasswordType;

@protocol InputPaymentPasswordDelegate <NSObject>
- (NSString *)inputPaymentPassword:(NSString *)pwd;
@optional
/** 输入完成后进行回调 */
-(void)inputPaymentPasswordChangeForgetPassword;
@end
@interface InputPaymentPasswordVw : UIView
@property (nonatomic,assign)BOOL isNormal;
@property (nonatomic,strong)PaymentPasswordAlertVw *paymentPasswordAlertVw;
@property (nonatomic,assign)InputPaymentPasswordType  style;
@property (nonatomic, weak) id<InputPaymentPasswordDelegate> delegate;
- (void)show;
- (instancetype)initWithFrame:(CGRect)frame isNormal:(BOOL)isNormal;
- (instancetype)initWithFrame:(CGRect)frame;
-(void)setPaymentPasswordAlertPrice:(NSString *)price;
-(void)setPaymentPasswordAlertHandicapCost:(NSString *)handicapCost;
-(void)setPaymentPasswordAlertPriceTitle:(NSString *)priceTitle;
-(void)setPaymentPasswordAlertHandicapCostTitle:(NSString *)handicapCostTitle;
-(void)setNumberOfTransactions:(NSString *)TransactionsNum;
-(void)setNumberOfTransactionsTitle:(NSString *)transactionsNumTitle;
@end
