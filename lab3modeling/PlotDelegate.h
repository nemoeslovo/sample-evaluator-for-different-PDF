//
// Created by danilakolesnikov on 4/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CorePlot/CPTGraphHostingView.h>

@class CPTGraph;


@interface PlotDelegate : NSObject <CPTPlotDataSource>

@property (unsafe_unretained) CPTGraphHostingView *graphView;

- (CPTGraph *)createGraphStartX:(double)startX andStartY:(double)startY andMaxX:(double)maxX andMaxY:(double)maxY;

- (void)addPlot:(NSArray *)plotData;

- (void)redraw;

- (id)initWithPlotView:(CPTGraphHostingView *)view;

+ (PlotDelegate *)plotWithPlotView:(CPTGraphHostingView *)view;

@end