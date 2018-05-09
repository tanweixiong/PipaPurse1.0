//
//  PaymentPasswordAlertVw.h
//  FoodFamily
//
//  Created by tam on 2017/11/16.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLTextField.h"
@interface PaymentPasswordAlertVw : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberTransactionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberTransactionsTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *handicapCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *handicapCostTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIView *backgroundVw;
@end
