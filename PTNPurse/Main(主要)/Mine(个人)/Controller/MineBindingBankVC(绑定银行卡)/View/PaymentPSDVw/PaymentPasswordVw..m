//
//  InputPaymentPasswordVw.m
//  FoodFamily
//
//  Created by tam on 2017/11/16.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import "PaymentPasswordVw.h"
#import "GLTextField.h"
#import "UIView+category.h"

@interface PaymentPasswordVw ()<UIAlertViewDelegate>
/** 蒙板 */
@property (nonatomic, weak) UIButton *cover;
/** 密码输入文本框 */
@property (nonatomic,strong) GLTextField *passwordField;
/** 密码原点的数组 */
@property (nonatomic,strong)NSMutableArray *passwordDotsArray;
/** 默认密码 */
@property (nonatomic,strong,readonly) NSString *password;
@property (nonatomic,assign)CGRect alertVwRect;
@property (nonatomic,strong)UIView *textFieldView;
@property (nonatomic,strong)NSString *payThePassword;
@end
//密码位数
static NSInteger const kDotsNumber = 6;
//假密码点点的宽和高  应该是等高等宽的正方形 方便设置为圆
static CGFloat const kDotWith_height = 10;
// 屏幕bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZCScreenBounds [UIScreen mainScreen].bounds
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
// 屏幕适配
#define XMAKE(x) (x) * [UIScreen mainScreen].bounds.size.width / 375
#define YMAKE(y) (y) * [UIScreen mainScreen].bounds.size.height / 667
#define paymentPasswordAlertHeight 250

@implementation PaymentPasswordVw

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:ZCScreenBounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self setupCover];
        [self setuptextField];
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame isNormal:(BOOL)isNormal
{
    self = [super initWithFrame:ZCScreenBounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isNormal = isNormal;
        [self setupCover];
        [self setuptextField];
        [self registerForKeyboardNotifications];
    }
    return self;
}

/** 蒙板 */
- (void)setupCover
{
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor blackColor]];
    self.cover.alpha = 0.4;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
}

/** 输入框*/
-(void)setuptextField{
    [self addSubview:self.paymentPasswordAlertVw];
    [self.paymentPasswordAlertVw.backgroundVw addSubview:self.textFieldView];
    [self addDotsViews];
    self.alertVwRect = self.paymentPasswordAlertVw.frame;
}

/** 监测键盘的高度*/
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat keyboardHeight = kbSize.height;
//    CGFloat maxHeight = [UIApplication sharedApplication].keyWindow.frame.size.height;
//    CGFloat currentHeight = maxHeight - keyboardHeight - CGRectGetHeight(self.alertVwRect) - YMAKE(80);
    CGFloat popupHeight = kScreenHeight - keyboardHeight - CGRectGetHeight(self.paymentPasswordAlertVw.frame);
    [UIView animateWithDuration:duration animations:^{
        self.paymentPasswordAlertVw.frame = CGRectMake(0, popupHeight, CGRectGetWidth(self.paymentPasswordAlertVw.frame), CGRectGetHeight(self.paymentPasswordAlertVw.frame));
    }];
}

///键盘消失事件
- (void) keyboardWillBeHidden:(NSNotification *)notification {
    // 键盘动画时间
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.paymentPasswordAlertVw.frame = CGRectMake(0, self.alertVwRect.origin.y, CGRectGetWidth(self.paymentPasswordAlertVw.frame), CGRectGetHeight(self.paymentPasswordAlertVw.frame));
    }];
}

-(void)coverClick{
    [_passwordField resignFirstResponder];
    [self cancel];
}

- (void)show
{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)cancel
{
    [self.paymentPasswordAlertVw resignFirstResponder];
    self.paymentPasswordAlertVw.hidden = YES;
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view{
     [view addSubview:self];
}

#pragma mark == private method
- (void)addDotsViews
{
    //每个间隙之间的宽度
    CGFloat clearanceWidth = 1;
    //六等分 每等分的宽度
    CGFloat password_width = CGRectGetWidth(self.textFieldView.frame);
    //计算背景图的宽度
    CGFloat contextWidth = (password_width - 5 * clearanceWidth)/6;
    
    CGFloat contextHeight = contextWidth;
    
    for (int i = 0; i < kDotsNumber; i ++)
    {
        UIView *contextView = [[UIView alloc] initWithFrame:CGRectMake(i * contextWidth + i * clearanceWidth,0, contextWidth  , contextHeight)];
        contextView.backgroundColor = [UIColor whiteColor];
        [self.textFieldView addSubview:contextView];

        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDotWith_height, kDotWith_height)];
        dotView.center = contextView.center;
        dotView.backgroundColor = UIColorFromRGB(0x222222);
        [dotView setCornerRadius:kDotWith_height/2.0];
        dotView.hidden = YES;
        [self.textFieldView addSubview:dotView];
        [self.passwordDotsArray addObject:dotView];
    }
    
    _textFieldView.frame = CGRectMake(_textFieldView.frame.origin.x, _textFieldView.frame.origin.y, CGRectGetWidth(_textFieldView.frame), contextHeight);
    _textFieldView.backgroundColor = [UIColor colorWithRed:238/255.0 green:237/255.0 blue:239/255.0 alpha:1];
    _textFieldView.layer.borderWidth = clearanceWidth;
    _textFieldView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:237/255.0 blue:239/255.0 alpha:1].CGColor;
    [self.paymentPasswordAlertVw.backgroundVw addSubview:self.passwordField];
}


- (void)cleanPassword
{
    _passwordField.text = @"";
    
    [self setDotsViewHidden];
}

//将所有的假密码点设置为隐藏状态
- (void)setDotsViewHidden
{
    for (UIView *view in _passwordDotsArray)
    {
        [view setHidden:YES];
    }
}


#pragma mark == UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除键
    if (string.length == 0)
    {
        return YES;
    }
    
    if (_passwordField.text.length >= kDotsNumber)
    {
        return NO;
    }
    
    return YES;
}

- (void)passwordFieldDidChange:(UITextField *)field
{
    [self setDotsViewHidden];
    for (int i = 0; i < _passwordField.text.length; i ++)
    {
        if (_passwordDotsArray.count > i )
        {
            UIView *dotView = _passwordDotsArray[i];
            [dotView setHidden:NO];
        }
    }
    if (_passwordField.text.length == 6)
    {
        
        [self cancel];
        if ([self.delegate respondsToSelector:@selector(inputPaymentPassword:)]) {
            [self.delegate inputPaymentPassword:_passwordField.text];
        }
    }
}

#pragma mark == 懒加载
- (NSMutableArray *)passwordDotsArray
{
    if (nil == _passwordDotsArray)
    {
        _passwordDotsArray = [[NSMutableArray alloc] initWithCapacity:kDotsNumber];
    }
    return _passwordDotsArray;
}

-(PaymentAlertVw *)paymentPasswordAlertVw{
    if (nil == _paymentPasswordAlertVw) {
        _paymentPasswordAlertVw = [[NSBundle mainBundle] loadNibNamed:@"PaymentAlertVw" owner:nil options:nil].lastObject;
        _paymentPasswordAlertVw.frame = CGRectMake(0, kScreenHeight - 217 - 190, kScreenWidth, 190);
        [_paymentPasswordAlertVw.forgetPwdBtn addTarget:self action:@selector(forgetPasswordOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_paymentPasswordAlertVw.closeBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserLanguage"];
        if ([str isEqualToString:@"zh-Hans"]) {
            _paymentPasswordAlertVw.titleLabel.text = @"输入密码";
            [_paymentPasswordAlertVw.forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        }else{
            [_paymentPasswordAlertVw.forgetPwdBtn setTitle:@"Forget psd" forState:UIControlStateNormal];
             _paymentPasswordAlertVw.titleLabel.text = @"Please enter payment password";
        }
    }
    return _paymentPasswordAlertVw;
}

-(void)forgetPasswordOnClick{
    if ([self.delegate respondsToSelector:@selector(inputPaymentPasswordChangeForgetPassword)]) {
        [self cancel];
        [self.delegate inputPaymentPasswordChangeForgetPassword];
    }
}

-(UIView *)textFieldView{
    if (nil == _textFieldView) {
       CGFloat height = self.isNormal ? _paymentPasswordAlertVw.forgetPwdBtn.frame.origin.y - 70 : CGRectGetMaxY(_paymentPasswordAlertVw.titleLabel.frame) + 30;
        _textFieldView = [[UIView alloc] initWithFrame:CGRectMake(20, height, [UIScreen mainScreen].bounds.size.width - 46 - 40,0)];
        _textFieldView.backgroundColor = [UIColor clearColor];
    }
    return _textFieldView;
}

- (GLTextField *)passwordField
{
    if (nil == _passwordField)
    {
        _passwordField = [[GLTextField alloc] initWithFrame:CGRectMake(_textFieldView.frame.origin.x, _textFieldView.frame.origin.y,CGRectGetWidth(_textFieldView.frame),CGRectGetHeight(_textFieldView.frame))];
        _passwordField.delegate = (id)self;
        _passwordField.backgroundColor = [UIColor clearColor];
        //将密码的文字颜色和光标颜色设置为透明色
        //之前是设置的白色 这里有个问题 如果密码太长的话 文字和光标的位置如果到了第一个黑色的密码点的时候 就看出来了
        _passwordField.textColor = [UIColor clearColor];
        _passwordField.tintColor = [UIColor clearColor];
//        [_passwordField setBorderColor:UIColorFromRGB(0xdddddd) width:1];
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordField.secureTextEntry = YES;
        [_passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_passwordField becomeFirstResponder];
    }
    return _passwordField;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //重新输入
    if (buttonIndex == 0) {
        _paymentPasswordAlertVw.hidden = NO;
        [self cleanPassword];
    //忘记密码
    }else{
        
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    /** 蒙板 */
    self.cover.frame = self.bounds;
}

@end
