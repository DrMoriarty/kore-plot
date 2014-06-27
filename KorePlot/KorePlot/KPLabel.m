//
//  KPLabelFormat.m
//  KorePlot
//
//  Created by Василий Макаров on 23.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import "KPLabel.h"

@implementation KPLabel

@synthesize textColor, backgroundColor, text, textFont, alignment, offset, angle;

-(id)init
{
    if((self = [super init])) {
        textColor = [UIColor blackColor];
        backgroundColor = nil;
        text = @"";
        textFont = [UIFont systemFontOfSize:UIFont.systemFontSize];
        alignment = NSTextAlignmentCenter;
        offset = CGPointZero;
        angle = 0.f;
    }
    return self;
}

-(void)drawLabelInContext:(CGContextRef)ctx toPoint:(CGPoint)point
{
    if(!text) return;
    CGSize size = [text sizeWithFont:textFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = CGRectMake(point.x+offset.x, point.y+offset.y+size.height, size.width, size.height);
    if(alignment == NSTextAlignmentLeft) {
        // nothing to do
    } else if(alignment == NSTextAlignmentRight) {
        rect.origin.x -= size.width;
    } else {
        rect.origin.x -= size.width * 0.5f;
    }
    [self drawLabelInContext:ctx toRect:rect];
}

-(void)drawLabelInContext:(CGContextRef)ctx toRect:(CGRect)rect
{
    if(!text) return;
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y);
    CGContextScaleCTM(ctx, 1, -1);
    if(angle != 0.f) CGContextRotateCTM(ctx, angle);
    UIGraphicsPushContext(ctx);
    if(backgroundColor) {
        CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
        CGContextFillRect(ctx, CGRectMake(0, 0, rect.size.width, rect.size.height));
    }
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [text drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) withAttributes:@{UITextAttributeFont: textFont, UITextAttributeTextColor: textColor}];
    } else {
        CGContextSetStrokeColorWithColor(ctx, textColor.CGColor);
        [text drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) withFont:textFont lineBreakMode:NSLineBreakByClipping alignment:alignment];
    }
    UIGraphicsPopContext();
    CGContextRestoreGState(ctx);
}

-(CGRect)rectForPoint:(CGPoint)point
{
    CGSize size = [text sizeWithFont:textFont];
    return CGRectMake(point.x+offset.x, point.y+offset.y+size.height, size.width, size.height);
}

@end
