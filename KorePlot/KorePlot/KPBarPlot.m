//
//  KPBarPlot.m
//  KorePlot
//
//  Created by Василий Макаров on 23.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import "KPBarPlot.h"

@implementation KPBarPlot {
    CGFloat animationProgress;
    NSMutableArray *data;
    NSMutableArray *labels;
    BOOL needRedraw;
    CGRect plotb;
}

@synthesize identifier, plotDelegate, showLabels, padding, plotColor, barWidth;

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
    padding = 10.f;
    barWidth = 10.f;
    plotColor = [UIColor blackColor];
    showLabels = YES;
}

-(void)startAnimation
{
    animationProgress = 0.f;
}

-(CGRect)plotBounds
{
    return plotb;
}

-(void)reloadData
{
    data = nil;
    plotb = CGRectNull;
    needRedraw = YES;
    BOOL haveLabels = [plotDelegate respondsToSelector:@selector(labelForPlot:value:point:)];
    if(plotDelegate) {
        NSInteger num = [plotDelegate numberOfPointsForPlot:self];
        if(num <= 0) return;
        plotb.size.width = num;// + 2.f*padding;
        plotb.origin.x = 0.f;//- padding;
        data = [NSMutableArray arrayWithCapacity:num];
        labels = [NSMutableArray arrayWithCapacity:num];
        CGFloat Min = MAXFLOAT, Max = -MAXFLOAT;
        for(int i =0; i<num; i++) {
            CGFloat min = [plotDelegate plot:self value:KPPlotPointMin forPoint:i];
            CGFloat max = [plotDelegate plot:self value:KPPlotPointMax forPoint:i];
            if(min < Min) Min = min;
            if(max > Max) Max = max;
            data[i] =  @[[NSNumber numberWithFloat:min], [NSNumber numberWithFloat:max]];
            if(haveLabels) {
                labels[i] = @[[plotDelegate labelForPlot:self value:KPPlotPointMin point:i], [plotDelegate labelForPlot:self value:KPPlotPointMax point:i]];
            } else {
                KPLabel *l1 = [KPLabel new];
                l1.text = [NSString stringWithFormat:@"%f", Min];
                KPLabel *l2 = [KPLabel new];
                l2.text = [NSString stringWithFormat:@"%f", Max];
                labels[i] = @[l1, l2];
            }
        }
        plotb.origin.y = Min;// - padding;
        plotb.size.height = Max-Min;// + 2.f*padding;
        /*
        for(int i=0; i < labels.count; i++) {
            KPLabel *l1 = [labels[i] objectAtIndex:0];
            CGRect lrect = [l1 rectForPoint:CGPointMake(i, [[data[i] objectAtIndex:0] floatValue])];
            plotb = CGRectUnion(plotb, lrect);
            KPLabel *l2 = [labels[i] objectAtIndex:1];
            lrect = [l2 rectForPoint:CGPointMake(i, [[data[i] objectAtIndex:1] floatValue])];
            plotb = CGRectUnion(plotb, lrect);
        }
         */
    }
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

-(void)drawInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    CGContextSetFillColorWithColor(ctx, plotColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, plotColor.CGColor);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    for(int i=0; i<data.count; i++) {
        CGFloat min = [[data[i] objectAtIndex:0] floatValue];
        CGFloat max = [[data[i] objectAtIndex:1] floatValue];
        CGRect rect = CGRectMake(i*xscale-barWidth/2, MIN(min,max)*yscale, barWidth, fabsf(max-min)*yscale*animationProgress);
        CGContextFillRect(ctx, rect);
    }
}

-(void)drawLabelsInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    for(int i=0; i<labels.count; i++) {
        KPLabel *l1 = [labels[i] objectAtIndex:0];
        NSNumber *n1 = [data[i] objectAtIndex:0];
        [l1 drawLabelInContext:ctx toPoint:CGPointMake(i*xscale, n1.floatValue*yscale*animationProgress)];
        KPLabel *l2 = [labels[i] objectAtIndex:1];
        NSNumber *n2 = [data[i] objectAtIndex:1];
        [l2 drawLabelInContext:ctx toPoint:CGPointMake(i*xscale, n2.floatValue*yscale*animationProgress)];
    }
}

@end
