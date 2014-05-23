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
    NSMutableArray *labels;
    BOOL needRedraw;
    CGRect plotb;
}

@synthesize plotDelegate, identifier, padding, plotColor, lineWidth, dotType, lineType, showLabels;

-(id)init
{
    if((self = [super init])) {
        [self internalInit];
    }
    return self;
}

-(id)initWithIdentifier:(NSString *)_identifier andDelegate:(id<KPPlotDelegate>)delegate
{
    if((self = [super init])) {
        [self internalInit];
        identifier = _identifier;
        plotDelegate = delegate;
        [self reloadData];
    }
    return self;
}

-(void)internalInit
{
    padding = 0.5f;
    lineWidth = 1.f;
    plotColor = [UIColor blackColor];
    dotType = KPPlotDotTypeNone;
    lineType = KPPlotLineTypeSolid;
    showLabels = YES;
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
        labels = [NSMutableArray arrayWithCapacity:num];
        CGFloat min = MAXFLOAT, max = -MAXFLOAT;
        for(int i =0; i<num; i++) {
            CGFloat d = [plotDelegate plot:self value:KPPlotPointY forPoint:i];
            if(d < min) min = d;
            if(d > max) max = d;
            data[i] = [NSNumber numberWithFloat:d];
            if([plotDelegate respondsToSelector:@selector(labelForPlot:point:)]) {
                labels[i] = [plotDelegate labelForPlot:self point:i];
            } else {
                KPLabel *l = [KPLabel new];
                l.text = [NSString stringWithFormat:@"%f", d];
                labels[i] = l;
            }
        }
        plotb.origin.y = min - padding;
        plotb.size.height = max-min + 2.f*padding;
    }
    needRedraw = YES;
}

-(void)drawInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    NSLog(@"draw in context");
    CGContextSetFillColorWithColor(ctx, plotColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, plotColor.CGColor);
    switch(lineType) {
        default:
        case KPPlotLineTypeSolid:
            break;
        case KPPlotLineTypeDot: {
            float dash[2]={1, 2};
            CGContextSetLineDash(ctx, 2, dash, 2);
            break;
        }
        case KPPlotLineTypeDash: {
            float dash[2]={6, 3};
            CGContextSetLineDash(ctx, 2, dash, 2);
            break;
        }
        case KPPlotLineTypeDashDot: {
            float dash[4]={6, 3, 1, 3};
            CGContextSetLineDash(ctx, 2, dash, 4);
            break;
        }
    }
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGPoint pts[data.count];
    for(int i=0; i<data.count; i++) {
        pts[i] = CGPointMake(i*xscale, [data[i] floatValue]*yscale * animationProgress);
    }
    CGContextAddLines(ctx, pts, data.count);
    CGContextStrokePath(ctx);
    switch (dotType) {
        default:
        case KPPlotDotTypeNone:
            break;
        case KPPlotDotTypeCircle:
            for (int i=0; i<data.count; i++) {
                CGFloat y = [data[i] floatValue];
                CGContextFillEllipseInRect(ctx, CGRectMake(i*xscale-lineWidth, y*yscale*animationProgress-lineWidth, 2.f*lineWidth, 2.f*lineWidth));
            }
            break;
    }
}

-(void)drawLabelsInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    if(!showLabels) return;
    for(int i=0; i<labels.count; i++) {
        KPLabel *l = labels[i];
        NSNumber *n = data[i];
        [l drawLabelInContext:ctx toPoint:CGPointMake(i*xscale, n.floatValue*yscale*animationProgress)];
    }
}

@end
