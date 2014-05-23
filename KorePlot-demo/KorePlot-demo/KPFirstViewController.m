//
//  KPFirstViewController.m
//  KorePlot-demo
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import "KPFirstViewController.h"

@interface KPFirstViewController ()

@end

@implementation KPFirstViewController

@synthesize plotView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    KPPlot *plot = [[KPPlot alloc] initWithIdentifier:@"one" andDelegate:self];
    plot.dotType = KPPlotDotTypeCircle;
    plot.lineType = KPPlotLineTypeDashDot;
    plot.lineWidth = 2.f;
    [plotView addPlot:plot animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KPPlotDelegate

-(NSInteger)numberOfPointsForPlot:(KPPlot *)plot
{
    return 10;
}

-(CGFloat)plot:(KPPlot *)plot value:(KPPlotPoint)value forPoint:(NSInteger)point
{
    return sinf(0.5f * point) * 10.f;
}

@end
