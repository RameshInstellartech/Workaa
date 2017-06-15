//
//  AlphaGradientView.h
//  HomeApp
//
//  Created by IN1947 on 16/04/15.
//  Copyright (c) 2015 IN1947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlphaGradientView : UIView

typedef enum gradientDirections
{
    GRADIENT_UP,
    GRADIENT_DOWN,
    GRADIENT_LEFT,
    GRADIENT_RIGHT
} GradientDirection;

@property (nonatomic) UIColor* color;
@property (nonatomic) GradientDirection direction;

@end
