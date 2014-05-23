//
//  KPPlot.h
//  KorePlot
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "KPPlot.h"
#import "KPLabel.h"

typedef enum {KPPlotDotTypeNone = 0, KPPlotDotTypeCircle } KPPlotDotType;
typedef enum {KPPlotLineTypeSolid = 0, KPPlotLineTypeDot, KPPlotLineTypeDash, KPPlotLineTypeDashDot} KPPlotLineType;

@class KPLinePlot;

@interface KPLinePlot : NSObject <KPPlot>

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
