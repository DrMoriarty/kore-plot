//
//  KPFirstViewController.h
//  KorePlot-demo
//
//  Created by Василий Макаров on 22.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KorePlot.h"

@interface KPFirstViewController : UIViewController <KPPlotDelegate>

@property (nonatomic, strong) IBOutlet KPPlotView *plotView;

@end
