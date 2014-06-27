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
    
    KPXAxis *axis = [[KPXAxis alloc] initWithIdentifier:@"x" andDelegate:self];
    plotView.xAxis = axis;
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

#pragma mark - KPAxisDelegate

-(CGFloat)axisMinumumFor:(KPXAxis*)axis
{
    return -.5f;
}

-(CGFloat)axisMaximumFor:(KPXAxis*)axis
{
    return 20.5f;
}

-(KPLabel*)labelForAxis:(KPXAxis*)axis point:(NSInteger)point
{
    KPLabel *l = [KPLabel new];
    l.angle = -1.f;
    l.alignment = NSTextAlignmentRight;
    l.offset = CGPointMake(0, -2);
    l.textFont = [UIFont systemFontOfSize:8.f];
    if(point%4) return l;
    switch (point) {
        case 0:
            l.text = @"first";
            break;
        case 1:
            l.text = @"second";
            break;
        case 2:
            l.text = @"third";
            break;
        default:
            l.text = [NSString stringWithFormat:@"%dth", point+1];
            break;
    }
    return l;
}

@end
