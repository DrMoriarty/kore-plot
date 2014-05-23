//
//  KPPlot.h
//  KorePlot
//
//  Created by Василий Макаров on 23.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPLabel.h"

typedef enum {KPPlotPointX = 0, KPPlotPointY, KPPlotPointMin, KPPlotPointMax} KPPlotPoint;

@protocol KPPlot;

@protocol KPPlotDelegate <NSObject>

-(NSInteger)numberOfPointsForPlot:(id<KPPlot>)plot;
-(CGFloat)plot:(id<KPPlot>)plot value:(KPPlotPoint)value forPoint:(NSInteger)point;

@optional
-(KPLabel*)labelForPlot:(id<KPPlot>)plot point:(NSInteger)point;

@end

@protocol KPPlot <NSObject>

@property (nonatomic, readonly) CGRect plotBounds;

-(BOOL)update:(CGFloat)dt;
-(void)drawInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale;
-(void)drawLabelsInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale;

@optional
-(void)startAnimation;

@end
