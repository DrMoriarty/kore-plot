//
//  KPPlotView.m
//  KorePlot
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import "KPPlotView.h"

#define DT 0.02f

@implementation KPPlotView {
    NSMutableArray *plots;
    NSTimer *timer;
    CGRect plotb;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self internalInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) [self internalInit];
    return self;
}

-(void)internalInit
{
    plotb = CGRectNull;
    plots = [NSMutableArray array];
    timer = [NSTimer timerWithTimeInterval:DT target:self selector:@selector(updateAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)updateAnimation
{
    BOOL update = NO;
    for (CALayer *l in self.layer.sublayers) {
        if([l isKindOfClass:KPPlot.class]) {
            KPPlot *kp = (KPPlot*)l;
            if([kp update:DT]) update = YES;
        }
    }
    if(update) [self.layer setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [self drawLayer:nil inContext:UIGraphicsGetCurrentContext()];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CGRect r = CGContextGetClipBoundingBox(ctx);
	CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
	CGContextFillRect(ctx, r);

    CGFloat xscale = r.size.width / plotb.size.width;
    CGFloat yscale = r.size.height / plotb.size.height;
    //CGContextScaleCTM(ctx, r.size.width / plotb.size.width, r.size.height / plotb.size.height);
    //CGContextTranslateCTM(ctx, -plotb.origin.x, -plotb.origin.y);
    
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextSetShouldAntialias(ctx, true);
    CGContextSetShouldSmoothFonts(ctx, false);
    CGContextSetAllowsFontSmoothing(ctx, false);

    for (CALayer *l in self.layer.sublayers) {
        if([l isKindOfClass:KPPlot.class]) {
            KPPlot *p = (KPPlot*)l;
            CGContextSaveGState(ctx);
            CGContextTranslateCTM(ctx, (-plotb.origin.x)*xscale, (-plotb.origin.y)*yscale);
            [p drawInContext:ctx withXScale:xscale andYScale:yscale];
            CGContextRestoreGState(ctx);
        } else {
            [l drawInContext:ctx];
        }
    }
    
    CGContextRestoreGState(ctx);
}


-(void)addPlot:(KPPlot*)plot animated:(BOOL)animated
{
    if(CGRectEqualToRect(plotb, CGRectNull)) {
        plotb = plot.plotBounds;
    } else {
        plotb = CGRectUnion(plotb, plot.plotBounds);
    }
    [self.layer addSublayer:plot];
    if(animated) {
        [plot startAnimation];
    } 
}

@end
