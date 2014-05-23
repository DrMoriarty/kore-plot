//
//  KPLabelFormat.m
//  KorePlot
//
//  Created by Василий Макаров on 23.05.14.
//  Copyright (c) 2014 Trilan. All rights reserved.
//

#import "KPLabel.h"

@implementation KPLabel

@synthesize textColor, backgroundColor, text, textFont, alignment, offset;

-(id)init
{
    if((self = [super init])) {
        textColor = [UIColor blackColor];
        backgroundColor = nil;
        text = @"";
        textFont = [UIFont systemFontOfSize:UIFont.systemFontSize];
        alignment = NSTextAlignmentCenter;
        offset = CGPointZero;
    }
    return self;
}

-(void)drawLabelInContext:(CGContextRef)ctx toPoint:(CGPoint)point
{
    CGSize size = [text sizeWithFont:textFont];
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
    if(backgroundColor) {
        CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
        CGContextFillRect(ctx, rect);
    }
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y);
    CGContextScaleCTM(ctx, 1, -1);
    UIGraphicsPushContext(ctx);
    [text drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) withAttributes:@{UITextAttributeFont: textFont, UITextAttributeTextColor: textColor}];
    UIGraphicsPopContext();
    CGContextRestoreGState(ctx);
}

@end
