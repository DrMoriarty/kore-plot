//
//  KPPlot.h
//  KorePlot
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface KPPlot : CALayer

-(void)startAnimation;
-(BOOL)update:(CGFloat)dt;

@end
