//
// Created by danilakolesnikov on 4/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CorePlot/CorePlot.h>
#import "PlotDelegate.h"

#define RED    [CPTColor colorWithComponentRed:1.0 green:0.0 blue:0.0 alpha:1.0]


@implementation PlotDelegate {
    @private
    CPTGraphHostingView *_graphView;
    NSMutableDictionary *_plots;
    NSInteger plotsCount;
}


+ (PlotDelegate *)plotWithPlotView:(CPTGraphHostingView *)view {
    return [[self alloc] initWithPlotView:view];
}

- (id)initWithPlotView:(CPTGraphHostingView *)view {
    self = [super init];
    if (self) {
        _graphView = view;
        [_graphView setHostedGraph:[self createGraphStartX:0 andStartY:0 andMaxX:0 andMaxY:0]];
        plotsCount = 0;
        _plots = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)init {
    return [self initWithPlotView:nil];
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

- (void)addPlot:(NSArray *)plotData {
    NSNumber *plotIdentificator = [NSNumber numberWithInt:plotsCount];
    [_plots setObject:plotData forKey:[NSNumber numberWithInt:plotIdentificator]];
    [[_graphView hostedGraph] addPlot:[self createPlotWithIdentifier:plotIdentificator
                                                            andColor:RED]];
    plotsCount++;
}

- (CPTScatterPlot *)createPlotWithIdentifier:(id)ident
                                    andColor:(CPTColor *)color {
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];

    plot.dataSource = self;
    plot.identifier = ident;
    plot.interpolation = CPTScatterPlotInterpolationCurved;

    CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineColor = color;
    lineStyle.lineWidth = 2.0;
    plot.dataLineStyle = lineStyle;
    return plot;
}


- (void)redraw {
    [[_graphView hostedGraph] reloadData];
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 10;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot
                      field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index {

    NSArray *plotData = [_plots objectForKey:[plot identifier]];

    NSArray *point =  plotData[index];
    return point[fieldEnum];
}


@end