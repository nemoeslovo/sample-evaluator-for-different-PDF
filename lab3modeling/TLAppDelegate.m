//
//  TLAppDelegate.m
//  lab3modeling
//
//  Created by Danila Kolesnikov on 3/27/13.
//  Copyright (c) 2013 dandandan. All rights reserved.
//

#import "TLAppDelegate.h"
#import "TLEvaluator.h"
#import "Math.h"
#import "PlotDelegate.h"

#define MIN_Z 0
#define MAX_Z M_PI_4

#define IDEAL_SAMPLE_COUNT 99999

@implementation TLAppDelegate {
    @private
    TLEvaluator *_evaluator;
    PlotDelegate *_plotDelegate;
    NSArray *_idealeSampleGraphData;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    //задаем предварительно расчитанную функцию плотности распределения
    //вероятности (the probability density function)
    PdfFunction pdf = ^(CGFloat number) {
        CGFloat result = acot(1 - number) + M_PI_4;
        return result;
    };

    //задаем интервал выборки
    NSPoint range;
    range.x = MIN_Z;
    range.y = MAX_Z;

    //создаем объект, содержащий все необходимые нам вычислительные функции
    _evaluator = [TLEvaluator evaluatorWithPdf:pdf andRange:range];

    //инициализация graphView
    _plotDelegate = [PlotDelegate plotWithPlotView:_plotView];
    
    [_evaluator evaluateForCount:IDEAL_SAMPLE_COUNT];
    [[self analiticD] setStringValue:[[NSNumber numberWithFloat:[_evaluator d]]  stringValue]];
    [[self analitycMO] setStringValue:[[NSNumber numberWithFloat:[_evaluator mo]] stringValue]];

    _idealeSampleGraphData = [_evaluator sampleGraphData];
}

- (IBAction)onSampleClick:(id)sender {
    NSInteger elementsCount = [[[[self elementsCount] selectedItem] title] integerValue];
    [_evaluator evaluateForCount:elementsCount];
    [[self tfD]  setStringValue:[[NSNumber numberWithFloat:[_evaluator d]]  stringValue]];
    [[self tfMO] setStringValue:[[NSNumber numberWithFloat:[_evaluator mo]] stringValue]];

    [_plotDelegate cleenup];

    /*
    * добавляем три графика расчетной дисперсии и ее "коридора"
    * */
    [_plotDelegate addPlot:[_evaluator sampleGraphData] withColor:RED];
    [_plotDelegate addPlot:[_evaluator sampleGraphDownEdge] withColor:BLUE];
    [_plotDelegate addPlot:[_evaluator sampleGraphUpEdge] withColor:BLUE];

    /*
    * добавляем график идеальной выборки (близкой к идеальной)
    * */
    [_plotDelegate addPlot:_idealeSampleGraphData
                 withColor:GREEN
                 isStepped:NO];
}

@end