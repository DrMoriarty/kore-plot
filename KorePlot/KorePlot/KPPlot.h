//
//  KPPlot.h
//  KorePlot
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum {KPPlotPointX = 0, KPPlotPointY, KPPlotPointMin, KPPlotPointMax} KPPlotPoint;

@class KPPlot;

@protocol KPPlotDelegate
@optional

-(NSInteger)numberOfPointsForPlot:(KPPlot*)plot;
-(CGFloat)plot:(KPPlot*)plot value:(KPPlotPoint)value forPoint:(NSInteger)point;

@end

@interface KPPlot : CALayer

@property (nonatomic, weak) id<KPPlotDelegate> plotDelegate;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, readonly) CGRect plotBounds;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, strong) UIColor *plotColor;
@property (nonatomic, assign) CGFloat lineWidth;

-(id)initWithIdentifier:(NSString*)identifier andDelegate:(id<KPPlotDelegate>)delegate;
-(void)startAnimation;
-(BOOL)update:(CGFloat)dt;
-(void)reloadData;
-(void)drawInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale;

@end
