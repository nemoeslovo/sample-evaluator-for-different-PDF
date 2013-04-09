//
// Created by danilakolesnikov on 4/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CorePlot/CorePlot.h>
#import "PlotDelegate.h"


@implementation PlotDelegate {
    @private
    CPTGraphHostingView *_graphView;
}


- (CPTGraph *)createGraphStartX:(double)startX
                      andStartY:(double)startY
                        andMaxX:(double)maxX
                        andMaxY:(double)maxY {
    CPTXYGraph *graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    CPTXYPlotSpace *space = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    space.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(startX)
                                                length:CPTDecimalFromFloat(maxX)];

    space.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(startY)
                                                length: CPTDecimalFromFloat(maxY)];
    CPTXYAxisSet *axis = (CPTXYAxisSet *)graph.axisSet;

    axis.yAxis.minorTicksPerInterval       = 5;
    axis.yAxis.majorIntervalLength         = CPTDecimalFromString([NSString stringWithFormat:@"%f", maxY / 10]);

    axis.xAxis.minorTicksPerInterval       = 5;
    axis.xAxis.majorIntervalLength         = CPTDecimalFromString([NSString stringWithFormat:@"%f", maxX / 10]);

    [axis.yAxis.labelFormatter setMaximumFractionDigits:5];
    [axis.xAxis.labelFormatter setMaximumFractionDigits:5];

    return graph;
}

- (id)initWithPlotView:(CPTGraphHostingView *)view {
    self = [super init];
    if (self) {
        _graphView = view;
        [_graphView setHostedGraph:[self createGraphStartX:0 andStartY:0 andMaxX:0 andMaxY:0]];
    }
    return self;
}

- (void)addPlot:(NSDictionary *)plotData {
    
}

+ (PlotDelegate *)plotWithPlotView:(CPTGraphHostingView *)view {
    return [[self alloc] initWithPlotView:view];
}


@end