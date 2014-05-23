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
    KPLinePlot *plot = [[KPLinePlot alloc] initWithIdentifier:@"two" andDelegate:self];
    plot.dotType = KPPlotDotTypeCircle;
    plot.lineType = KPPlotLineTypeDash;
    plot.plotColor = [UIColor brownColor];
    [plotView addPlot:plot animated:YES];
    plotView.contentSize = CGSizeMake(280, 200);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scroll setContentSize:CGSizeMake(480, self.scroll.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KPPlotDelegate

-(NSInteger)numberOfPointsForPlot:(id<KPPlot>)plot
{
    return 20;
}

-(CGFloat)plot:(id<KPPlot>)plot value:(KPPlotPoint)value forPoint:(NSInteger)point
{
    return cosf(0.3f * point) * 5.f;
}

@end
