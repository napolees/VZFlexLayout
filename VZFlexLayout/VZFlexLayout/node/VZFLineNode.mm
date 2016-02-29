//
//  VZFLineNode.m
//  VZFlexLayout
//
//  Created by Sleen on 16/2/29.
//  Copyright © 2016年 Vizlab. All rights reserved.
//

#import "VZFLineNode.h"

@implementation VZFLineNode

+ (instancetype)lineNode {
    return [self lineNodeWithColor:[UIColor colorWithWhite:0xDD/255.f alpha:1]];
}

+ (instancetype)lineNodeWithColor:(UIColor *)color {
    return [self lineNodeWithColor:color thickness:1/[UIScreen mainScreen].scale];
}

+ (instancetype)lineNodeWithColor:(UIColor *)color thickness:(CGFloat)thickness {
    return [self lineNodeWithColor:color thickness:thickness margin:UIEdgeInsetsZero];
}

+ (instancetype)lineNodeWithColor:(UIColor *)color thickness:(CGFloat)thickness margin:(UIEdgeInsets)margin {
    NSAssert(thickness != VZFlexValueAuto, @"thickness can't be auto");
    
    return [super newWithView:[UIView class] NodeSpecs:{
        .view = {
            .backgroundColor = color,
        },
        .flex = {
            .flexShrink = 0,
            .flexBasis = thickness,
            .alignSelf = VZFlexStretch,
            .marginLeft = margin.left,
            .marginTop = margin.top,
            .marginRight = margin.right,
            .marginBottom = margin.bottom,
        }
    }];
}

@end