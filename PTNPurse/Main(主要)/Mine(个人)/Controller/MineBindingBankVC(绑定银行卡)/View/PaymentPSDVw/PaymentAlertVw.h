//
//  PaymentPasswordAlertVw.h
//  FoodFamily
//
//  Created by tam on 2017/11/16.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLTextField.h"
@interface PaymentAlertVw : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIView *backgroundVw;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *poundageLab;

@property (weak, nonatomic) IBOutlet UILabel *tradeNumberTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *poundageTitleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopY;

@end
