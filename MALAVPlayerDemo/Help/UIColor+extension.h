//
//  UIColor+extension.h
//  CarModelHeadlines
//
//  Created by wy on 16/1/6.
//  Copyright © 2016年 北京智阅网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(extension)
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;

+ (UIColor *)colorWithHexString:(NSString *)color;
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
