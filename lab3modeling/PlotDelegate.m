//
// Created by danilakolesnikov on 4/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CorePlot/CorePlot.h>
#import "PlotDelegate.h"
#import <CorePlot/CPTGraphHostingView.h>

@implementation PlotDelegate {
    @private
    NSMutableDictionary *_plots;
    NSInteger plotsCount;
}

@synthesize graphView = _graphView;

+ (PlotDelegate *)plotWithPlotView:(CPTGraphHostingView *)view {
    return [[self alloc] initWithPlotView:view];
}

- (id)initWithPlotView:(CPTGraphHostingView *)view {
    self = [super init];
    if (self) {
        /*
        * странные мэджики для задания изначальной видимости
        * графика. ТОДО: убрать хардкод
        * */
        CPTGraph *graph = [self createGraphStartX:1.47 andStartY:-0.3 andMaxX:0.7 andMaxY:1.5];

        /*
        * выравниваем координатные оси, чтобы они были видны не в
        * зависимости от видимой части графика - одна снизу
        * и другая, конечно же, слева
        * */
        [[(CPTXYAxisSet *) [graph axisSet] yAxis] setAxisConstraints:[CPTConstraints constraintWithLowerOffset:60.0]];
        [[(CPTXYAxisSet *) [graph axisSet] xAxis] setAxisConstraints:[CPTConstraints constraintWithLowerOffset:60.0]];

        [view setHostedGraph:graph];
        
        [self setGraphView:view];

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
    [graph setDelegate:self];
    [axis.xAxis.labelFormatter setMaximumFractionDigits:5];

    return graph;
}

- (void)addPlot:(NSArray *)plotData withColor:(CPTColor *)_color {
    [self addPlot:plotData
        withColor:_color
        isStepped:YES];
}

- (void)addPlot:(NSArray *)plotData
      withColor:(CPTColor *)_color
      isStepped:(BOOL)_isStepped {

    NSNumber *plotIdentificator = [NSNumber numberWithInt:plotsCount];
    [_plots setObject:plotData forKey:plotIdentificator];

    /*
    * если нам нужен гафик ступеньками, выбираем гистограмму
    * */
    CPTScatterPlotInterpolation interpolation = CPTScatterPlotInterpolationHistogram;

    /*
    * иначе сглаживаем
    * */
    if (!_isStepped) {
        interpolation = CPTScatterPlotInterpolationCurved;
    }

    [[_graphView hostedGraph] addPlot:[self createPlotWithIdentifier:plotIdentificator
                                                            andColor:_color
                                                   withInterpolation:interpolation]];
    plotsCount++;
}


- (CPTScatterPlot *)createPlotWithIdentifier:(id)ident
                                    andColor:(CPTColor *)color
                           withInterpolation:(CPTScatterPlotInterpolation)_interpolation {
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];

    plot.dataSource    = self;
    plot.identifier    = ident;
    plot.interpolation = _interpolation;

    CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineColor = color;
    lineStyle.lineWidth = 2.0;
    plot.dataLineStyle = lineStyle;
    return plot;
}

- (void)cleenup {
    for (int i = 0; i < plotsCount; i++) {
        [[_graphView hostedGraph] removePlotWithIdentifier:[NSNumber numberWithInt:i]];
    }
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    NSNumber *key      = [plot identifier];
    NSArray  *plotData = [_plots objectForKey:key];
    return [plotData count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot
                      field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index {

    NSNumber *plotIdentifer = [plot identifier];
    NSArray  *plotData = [_plots objectForKey:plotIdentifer];

    NSArray  *point  = plotData[index];
    NSNumber *result = point[fieldEnum];
    return result;
}


@end