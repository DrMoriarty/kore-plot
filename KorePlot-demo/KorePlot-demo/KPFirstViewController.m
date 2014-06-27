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
    KPLinePlot *plot = [[KPLinePlot alloc] initWithIdentifier:@"one" andDelegate:self];
    plot.dotType = KPPlotDotTypeCircle;
    plot.lineType = KPPlotLineTypeDashDot;
    plot.lineWidth = 2.f;
    
    KPBarPlot *bar = [[KPBarPlot alloc] initWithIdentifier:@"two" andDelegate:self];
    
    [plotView addPlot:bar animated:YES];
    [plotView addPlot:plot animated:YES];
    plotView.contentSize = CGSizeMake(360, 150);
    
    KPXAxis *axis = [[KPXAxis alloc] initWithIdentifier:@"x" andDelegate:self];
    plotView.xAxis = axis;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scroll setContentSize:CGSizeMake(320, 480)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KPPlotDelegate

-(NSInteger)numberOfPointsForPlot:(id<KPPlot>)plot
{
    if([plot.identifier isEqualToString:@"one"]) return 10;
    else return 5;
}

-(CGFloat)plot:(id<KPPlot>)plot value:(KPPlotPoint)value forPoint:(NSInteger)point
{
    if([plot.identifier isEqualToString:@"one"])
        return sinf(0.5f * point) * 10.f;
    else if([plot.identifier isEqualToString:@"two"]) {
        switch (value) {
            case KPPlotPointMin:
                return 0.f;//-sinf(0.5f * point+0.5f) * 10.f;
                break;
            case KPPlotPointMax:
            default:
                return sinf(0.5f * point+0.5f) * 10.f;
                break;
        }
    }
    return 0.f;
}

-(KPLabel*)labelForPlot:(id<KPPlot>)plot value:(KPPlotPoint)value point:(NSInteger)point
{
    KPLabel *l = [KPLabel new];
    CGFloat val = [self plot:plot value:value forPoint:point];
    if([plot.identifier isEqualToString:@"one"]) {
        l.text = [NSString stringWithFormat:@"%.2f", val];
        l.textFont = [UIFont systemFontOfSize:8.f];
        if(val < 0)
            l.textColor = [UIColor redColor];
        else
            l.textColor = [UIColor greenColor];
        l.backgroundColor = [UIColor lightGrayColor];
        l.offset = CGPointMake(0, 3);
        l.alignment = NSTextAlignmentLeft;
        return l;
    } else if([plot.identifier isEqualToString:@"two"]) {
        if(value == KPPlotPointMax)
            l.text = [NSString stringWithFormat:@"%.1f", val];
        l.textFont = [UIFont systemFontOfSize:10.f];
        if(val < 0)
            l.textColor = [UIColor brownColor];
        else
            l.textColor = [UIColor blueColor];
        l.backgroundColor = [UIColor clearColor];
        l.offset = CGPointMake(-5, 3);
        l.alignment = NSTextAlignmentRight;
        return l;
    }
    return l;
}

#pragma mark - KPAxisDelegate

-(CGFloat)axisMinumumFor:(KPXAxis*)axis
{
    return -.5f;
}

-(CGFloat)axisMaximumFor:(KPXAxis*)axis
{
    return 10.5f;
}

-(KPLabel*)labelForAxis:(KPXAxis*)axis point:(NSInteger)point
{
    KPLabel *l = [KPLabel new];
    l.angle = 1.f;
    l.alignment = NSTextAlignmentLeft;
    l.offset = CGPointMake(0, -2);
    l.textFont = [UIFont systemFontOfSize:8.f];
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
