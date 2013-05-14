//
// Created by danilakolesnikov on 4/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CorePlot/CPTGraphHostingView.h>

#define RED    [CPTColor colorWithComponentRed:1.0 green:0.0 blue:0.0 alpha:1.0]
#define GREEN  [CPTColor colorWithComponentRed:0.0 green:1.0 blue:0.0 alpha:1.0]
#define BLUE   [CPTColor colorWithComponentRed:0.2 green:0.2 blue:0.8 alpha:1.0]


@class CPTGraph;


@interface PlotDelegate : NSObject <CPTPlotDataSource>

@property (unsafe_unretained) CPTGraphHostingView *graphView;

- (CPTGraph *)createGraphStartX:(double)startX andStartY:(double)startY andMaxX:(double)maxX andMaxY:(double)maxY;

- (void)addPlot:(NSArray *)plotData withColor:(CPTColor *)_color;

- (void)cleenup;

- (id)initWithPlotView:(CPTGraphHostingView *)view;

+ (PlotDelegate *)plotWithPlotView:(CPTGraphHostingView *)view;

@end