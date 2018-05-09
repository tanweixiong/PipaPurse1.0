//
//  UIViewController+Cloudox.m
//  SmoothNavDemo
//
//  Created by Cloudox on 2017/3/20.
//  Copyright © 2017年 Cloudox. All rights reserved.
//

#import "UINavigationBar+Other.h"

@implementation UINavigationBar (Cloudox)

-(void)setColor:(UIColor *)color{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.bounds.size.width, 64)];
    view.backgroundColor = color;
    [self setValue:view forKey:@"backgroundView"];
}

@end
