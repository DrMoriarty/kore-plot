//
//  KPPlot.m
//  KorePlot
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import "KPPlot.h"
#import <UIKit/UIKit.h>

@implementation KPPlot {
    CGFloat animationProgress;
}

-(id)init
{
    if((self = [super init])) {
        //self.delegate = self;
    }
    return self;
}

-(void)startAnimation
{
    animationProgress = 0.f;
}

-(BOOL)update:(CGFloat)dt
{
    if(animationProgress <= 1.f) {
        animationProgress += 0.1f;
        return YES;
    } else {
        return NO;
    }
}

-(void)drawInContext:(CGContextRef)ctx
{
    NSLog(@"draw in context");
    CGFloat c[4] = {.5f, .5f, .5f, .5f};
    CGContextSetFillColor(ctx, c);
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, 20+30*animationProgress, 20+30*animationProgress));
}

@end
