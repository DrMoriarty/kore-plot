//
//  KPPlotView.h
//  KorePlot
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPPlot.h"

@interface KPPlotView : UIView

@property (nonatomic, readonly) CGRect plotBounds;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) BOOL scrollEnabled;

-(void)addPlot:(KPPlot*)plot animated:(BOOL)animated;

@end
