//
//  KPSecondViewController.m
//  KorePlot-demo
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import "KPSecondViewController.h"

@interface KPSecondViewController ()

@end

@implementation KPSecondViewController

@synthesize plotView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    KPPlot *plot = [[KPPlot alloc] initWithIdentifier:@"two" andDelegate:self];
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
    return 20;
}

-(CGFloat)plot:(KPPlot *)plot value:(KPPlotPoint)value forPoint:(NSInteger)point
{
    return cosf(0.3f * point) * 5.f;
}

@end
