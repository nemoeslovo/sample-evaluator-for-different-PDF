//
// Created by danilakolesnikov on 4/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class CPTGraph;
@class CPTGraphHostingView;


@interface PlotDelegate : NSObject

+ (CPTGraph *)createGraphStartX:(double)startX andStartY:(double)startY andMaxX:(double)maxX andMaxY:(double)maxY;

- (id)initWithPlotView:(CPTGraphHostingView *)view;

+ (PlotDelegate *)plotWithPlotView:(CPTGraphHostingView *)view;
@end