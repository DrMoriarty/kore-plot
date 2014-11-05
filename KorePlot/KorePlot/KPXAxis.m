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

@synthesize axisDelegate, identifier, size, axisColor, drawGrid, gridStep;

-(id)initWithIdentifier:(NSString*)_identifier andDelegate:(id<KPAxisDelegate>)delegate
{
    if((self = [super init])) {
        identifier = _identifier;
        axisDelegate = delegate;
        labels = [NSMutableArray array];
        size = 30.f;
        axisColor = [UIColor blackColor];
        drawGrid = NO;
        gridStep = 5.f;
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
    CGContextMoveToPoint(ctx, min*xscale, 0.f);
    CGContextAddLineToPoint(ctx, max*xscale, 0.f);
    CGContextStrokePath(ctx);
    for(int i=min; i<= max; i++) {
        CGContextMoveToPoint(ctx, i*xscale, 0.f);
        CGContextAddLineToPoint(ctx, i*xscale, -5.f);
        CGContextStrokePath(ctx);
    }
}

-(void)drawLabelsInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    for(int i=min; i<= max; i++) {
        KPLabel *l = labels[i];
        [l drawLabelInContext:ctx toPoint:CGPointMake(i*xscale, -size*0.5f)];
    }
}

-(void)drawGridInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale
{
    if(drawGrid) {
        CGContextSetFillColorWithColor(ctx, axisColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, axisColor.CGColor);
        CGRect r = CGContextGetClipBoundingBox(ctx);
        CGFloat st = gridStep * yscale;
        CGFloat gmin = ((int)((r.origin.y+size) / st)) * st;
        for(CGFloat y = gmin; y <= r.origin.y+r.size.height; y += st) {
            CGContextMoveToPoint(ctx, min*xscale, y);
            CGContextAddLineToPoint(ctx, max*xscale, y);
            CGContextStrokePath(ctx);
        }
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
