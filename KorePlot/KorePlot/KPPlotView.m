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
    CGPoint panStart, panMove;
    CGPoint targetOffset;
    BOOL bounce;
}

@synthesize contentSize, contentOffset, scrollEnabled;

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
    contentSize = self.frame.size;
    contentOffset = CGPointZero;
    scrollEnabled = YES;
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
    if(bounce) {
        CGFloat dx = fabsf(contentOffset.x-targetOffset.x) * 10.f;
        dx = DT * (dx < 300.f ? 300.f : dx);
        CGFloat dy = fabsf(contentOffset.y-targetOffset.y) * 10.f;
        dy = DT * (dy < 300.f ? 300.f : dy);
        if(contentOffset.x < targetOffset.x) {
            contentOffset.x += dx;
            if(contentOffset.x > targetOffset.x) contentOffset.x = targetOffset.x;
        }
        if(contentOffset.x > targetOffset.x) {
            contentOffset.x -= dx;
            if(contentOffset.x < targetOffset.x) contentOffset.x = targetOffset.x;
        }
        if(contentOffset.y < targetOffset.y) {
            contentOffset.y += dy;
            if(contentOffset.y > targetOffset.y) contentOffset.y = targetOffset.y;
        }
        if(contentOffset.y > targetOffset.y) {
            contentOffset.y -= dy;
            if(contentOffset.y < targetOffset.y) contentOffset.y = targetOffset.y;
        }
        update = YES;
        if(CGPointEqualToPoint(contentOffset, targetOffset)) bounce = NO;
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

    CGFloat xscale = contentSize.width / plotb.size.width;
    CGFloat yscale = contentSize.height / plotb.size.height;
    CGContextTranslateCTM(ctx, contentOffset.x, contentOffset.y);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -r.size.height);
    
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
    
    for (CALayer *l in self.layer.sublayers) {
        if([l isKindOfClass:KPPlot.class]) {
            KPPlot *p = (KPPlot*)l;
            CGContextSaveGState(ctx);
            CGContextTranslateCTM(ctx, (-plotb.origin.x)*xscale, (-plotb.origin.y)*yscale);
            [p drawLabelsInContext:ctx withXScale:xscale andYScale:yscale];
            CGContextRestoreGState(ctx);
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

-(BOOL)canScrollVertical
{
    return scrollEnabled && contentSize.height > self.frame.size.height;
}

-(BOOL)canScrollHorizontal
{
    return scrollEnabled && contentSize.width > self.frame.size.width;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    panStart = [t locationInView:self];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self calcBounce];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self calcBounce];
}

-(void)calcBounce
{
    targetOffset = contentOffset;
    if(targetOffset.x < self.frame.size.width - contentSize.width) {
        targetOffset.x = self.frame.size.width - contentSize.width;
        bounce = YES;
    }
    if(targetOffset.y < 0) {
        targetOffset.y = 0;
        bounce = YES;
    }
    if(targetOffset.x > 0) {
        targetOffset.x = 0;
        bounce = YES;
    }
    if(targetOffset.y > contentSize.height - self.frame.size.height) {
        targetOffset.y = contentSize.height - self.frame.size.height;
        bounce = YES;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    if(self.canScrollHorizontal) {
        contentOffset.x += p.x - panStart.x;
        [self setNeedsDisplay];
    }
    if(self.canScrollVertical) {
        contentOffset.y += p.y - panStart.y;
        [self setNeedsDisplay];
    }
    panStart = p;
}

@end
