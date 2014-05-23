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
    NSMutableArray *data;
    BOOL needRedraw;
    CGRect plotb;
}

@synthesize plotDelegate, identifier, padding, plotColor, lineWidth;

-(id)init
{
    if((self = [super init])) {
        padding = 0.5f;
        lineWidth = 1.f;
        plotColor = [UIColor blackColor];
    }
    return self;
}

-(id)initWithIdentifier:(NSString *)_identifier andDelegate:(id<KPPlotDelegate>)delegate
{
    if((self = [super init])) {
        padding = 0.5f;
        plotColor = [UIColor blackColor];
        lineWidth = 1.f;
        identifier = _identifier;
        plotDelegate = delegate;
        [self reloadData];
    }
    return self;
}

-(CGRect)plotBounds
{
    return plotb;
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
        BOOL nr = needRedraw;
        needRedraw = NO;
        return nr;
    }
}

-(void)reloadData
{
    data = nil;
    plotb = CGRectNull;
    if(plotDelegate) {
        NSInteger num = [plotDelegate numberOfPointsForPlot:self];
        if(num <= 0) return;
        plotb.size.width = num + 2.f*padding;
        plotb.origin.x = - padding;
        data = [NSMutableArray arrayWithCapacity:num];
        CGFloat min = MAXFLOAT, max = -MAXFLOAT;
        for(int i =0; i<num; i++) {
            CGFloat d = [plotDelegate plot:self value:KPPlotPointY forPoint:i];
            if(d < min) min = d;
            if(d > max) max = d;
            data[i] = [NSNumber numberWithFloat:d];
        }
        plotb.origin.y = min - padding;
        plotb.size.height = max-min + 2.f*padding;
    }
    needRedraw = YES;
}

-(void)drawInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    NSLog(@"draw in context");
    //CGFloat c[4] = {.5f, .5f, .5f, .5f};
    //CGContextSetFillColor(ctx, c);
    //CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, 20+30*animationProgress, 20+30*animationProgress));
    //CGContextSetStrokeColor(ctx, c);
    CGContextSetStrokeColorWithColor(ctx, plotColor.CGColor);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGPoint pts[data.count];
    for(int i=0; i<data.count; i++) {
        pts[i] = CGPointMake(i*xscale, [data[i] floatValue]*yscale * animationProgress);
    }
    CGContextAddLines(ctx, pts, data.count);
    CGContextStrokePath(ctx);
}

@end
