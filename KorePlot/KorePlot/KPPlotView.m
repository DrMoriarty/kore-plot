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
    CGFloat paddingLeft, paddingRight, paddingTop, paddingBottom;
    CGPoint panStart, panMove;
    CGPoint targetOffset;
    BOOL bounce, forceUpdate;
}

@synthesize contentSize, contentOffset, scrollEnabled, xAxis, centerPlot;

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
    paddingBottom = paddingLeft = paddingRight = paddingTop = 0.f;
    scrollEnabled = YES;
    timer = [NSTimer timerWithTimeInterval:DT target:self selector:@selector(updateAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    forceUpdate = YES;
    centerPlot = NO;
}

-(void)updateAnimation
{
    BOOL update = NO;
    for (id<KPPlot> kp in plots) {
        if([kp respondsToSelector:@selector(update:)]) {
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
    if(update || forceUpdate) [self.layer setNeedsDisplay];
    forceUpdate = NO;
}

-(void)drawRect:(CGRect)rect
{
    [self drawLayer:nil inContext:UIGraphicsGetCurrentContext()];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if(centerPlot && contentSize.width < self.frame.size.width) {
        contentOffset = CGPointMake((self.frame.size.width - contentSize.width) * 0.5f, 0.f);
    }
    CGContextSaveGState(ctx);
    CGRect r = CGContextGetClipBoundingBox(ctx);
	CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
	CGContextFillRect(ctx, r);
    
    CGSize plotSize = CGSizeMake(contentSize.width-paddingLeft-paddingRight, contentSize.height-paddingBottom-paddingTop);
    if(xAxis) plotSize.height -= xAxis.size;

    CGFloat xscale = plotSize.width / plotb.size.width;
    CGFloat yscale = plotSize.height / plotb.size.height;
    CGContextTranslateCTM(ctx, contentOffset.x+paddingLeft, contentOffset.y+(plotSize.height-contentSize.height)+paddingBottom);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -r.size.height);
    
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextSetShouldAntialias(ctx, true);
    CGContextSetShouldSmoothFonts(ctx, false);
    CGContextSetAllowsFontSmoothing(ctx, false);

    if(xAxis) {
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, (-plotb.origin.x)*xscale, (-plotb.origin.y)*yscale);
        [xAxis drawGridInContext:ctx withXScale:xscale andYScale:yscale];
        CGContextRestoreGState(ctx);
    }

    for (id<KPPlot> p in plots) {
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, (-plotb.origin.x)*xscale, (-plotb.origin.y)*yscale);
        [p drawInContext:ctx withXScale:xscale andYScale:yscale];
        CGContextRestoreGState(ctx);
    }
    
    for (id<KPPlot> p in plots) {
        if(p.showLabels) {
            CGContextSaveGState(ctx);
            CGContextTranslateCTM(ctx, (-plotb.origin.x)*xscale, (-plotb.origin.y)*yscale);
            [p drawLabelsInContext:ctx withXScale:xscale andYScale:yscale];
            CGContextRestoreGState(ctx);
        }
    }
    
    if(xAxis) {
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, (-plotb.origin.x)*xscale, -paddingBottom);
        [xAxis drawInContext:ctx withXScale:xscale andYScale:yscale];
        [xAxis drawLabelsInContext:ctx withXScale:xscale andYScale:yscale];
        CGContextRestoreGState(ctx);
    }
    
    CGContextRestoreGState(ctx);
}


-(void)addPlot:(id<KPPlot>)plot animated:(BOOL)animated
{
    if(CGRectEqualToRect(plotb, CGRectNull)) {
        plotb = plot.plotBounds;
        paddingTop = paddingRight = paddingLeft = paddingBottom = plot.padding;
    } else {
        plotb = CGRectUnion(plotb, plot.plotBounds);
        if(plot.plotBounds.origin.x <= plotb.origin.x && plot.padding > paddingLeft) paddingLeft = plot.padding;
        if(plot.plotBounds.origin.y <= plotb.origin.y && plot.padding > paddingBottom) paddingBottom = plot.padding;
        if(plot.plotBounds.origin.x+plot.plotBounds.size.width >= plotb.origin.x+plotb.size.width && plot.padding > paddingRight) paddingRight = plot.padding;
        if(plot.plotBounds.origin.y+plot.plotBounds.size.height >= plotb.origin.y+plotb.size.height && plot.padding > paddingTop) paddingTop = plot.padding;
    }
    if(animated && [plot respondsToSelector:@selector(startAnimationWithDelay:)]) {
        [plot startAnimationWithDelay:plots.count*0.2f];
    } 
    [plots addObject:plot];
}

-(void)removePlot:(id<KPPlot>)plot
{
    NSArray *pls = [plots filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isEqual:plot];
    }]];
    [self removeAllPlots];
    for (id<KPPlot> p in pls) {
        [self addPlot:p animated:NO];
    }
}

-(void)removeAllPlots
{
    plotb = CGRectNull;
    [plots removeAllObjects];
    contentSize = self.frame.size;
    contentOffset = CGPointZero;
    paddingBottom = paddingLeft = paddingRight = paddingTop = 0.f;
    forceUpdate = YES;
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
    if(scrollEnabled) {
        UITouch *t = [touches anyObject];
        panStart = [t locationInView:self];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(scrollEnabled) {
        [self calcBounce];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(scrollEnabled) {
        [self calcBounce];
    }
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
    if(!scrollEnabled) return;
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

-(void)redraw
{
    [self.layer setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self redraw];
}

-(CGRect)plotBounds
{
    return plotb;
}

-(void)setPlotBounds:(CGRect)plotBounds
{
    plotb = plotBounds;
}

@end
