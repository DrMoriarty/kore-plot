//
//  KPXAxis.m
//  KorePlot
//
//  Created by Василий Макаров on 27.06.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import "KPXAxis.h"

@implementation KPXAxis {
    CGFloat min, max;
    NSMutableArray *labels;
}

@synthesize axisDelegate, identifier, size, axisColor;

-(id)initWithIdentifier:(NSString*)_identifier andDelegate:(id<KPAxisDelegate>)delegate
{
    if((self = [super init])) {
        identifier = _identifier;
        axisDelegate = delegate;
        labels = [NSMutableArray array];
        size = 30.f;
        axisColor = [UIColor blackColor];
        [self reloadData];
    }
    return self;
}

-(void)setAxisDelegate:(id<KPAxisDelegate>)_axisDelegate
{
    axisDelegate = _axisDelegate;
    [self reloadData];
}

-(void)drawInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    CGContextSetFillColorWithColor(ctx, axisColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, axisColor.CGColor);
    CGContextMoveToPoint(ctx, min*xscale, size);
    CGContextAddLineToPoint(ctx, max*xscale, size);
    CGContextStrokePath(ctx);
    for(int i=min; i<= max; i++) {
        CGContextMoveToPoint(ctx, i*xscale, size);
        CGContextAddLineToPoint(ctx, i*xscale, size-5);
        CGContextStrokePath(ctx);
    }
}

-(void)drawLabelsInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    for(int i=min; i<= max; i++) {
        KPLabel *l = labels[i];
        [l drawLabelInContext:ctx toPoint:CGPointMake(i*xscale, size*0.5f)];
    }
}

-(void)reloadData
{
    [labels removeAllObjects];
    if(axisDelegate) {
        min = [axisDelegate axisMinumumFor:self];
        max = [axisDelegate axisMaximumFor:self];
        if([axisDelegate respondsToSelector:@selector(labelForAxis:point:)]) {
            for(int i=min; i<= max; i++) {
                [labels addObject:[axisDelegate labelForAxis:self point:i]];
            }
        }
    }
}

@end
