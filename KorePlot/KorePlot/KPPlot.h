//
//  KPPlot.h
//  KorePlot
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "KPLabel.h"

typedef enum {KPPlotPointX = 0, KPPlotPointY, KPPlotPointMin, KPPlotPointMax} KPPlotPoint;
typedef enum {KPPlotDotTypeNone = 0, KPPlotDotTypeCircle } KPPlotDotType;
typedef enum {KPPlotLineTypeSolid = 0, KPPlotLineTypeDot, KPPlotLineTypeDash, KPPlotLineTypeDashDot} KPPlotLineType;

@class KPPlot;

@protocol KPPlotDelegate <NSObject>

-(NSInteger)numberOfPointsForPlot:(KPPlot*)plot;
-(CGFloat)plot:(KPPlot*)plot value:(KPPlotPoint)value forPoint:(NSInteger)point;

@optional
-(KPLabel*)labelForPlot:(KPPlot*)plot point:(NSInteger)point;

@end

@interface KPPlot : CALayer

@property (nonatomic, weak) id<KPPlotDelegate> plotDelegate;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, readonly) CGRect plotBounds;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, strong) UIColor *plotColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) KPPlotDotType dotType;
@property (nonatomic, assign) KPPlotLineType lineType;
@property (nonatomic, assign) BOOL showLabels;

-(id)initWithIdentifier:(NSString*)identifier andDelegate:(id<KPPlotDelegate>)delegate;
-(void)startAnimation;
-(BOOL)update:(CGFloat)dt;
-(void)reloadData;
-(void)drawInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale;
-(void)drawLabelsInContext:(CGContextRef)ctx withXScale:(CGFloat)xscale andYScale:(CGFloat)yscale;

@end
