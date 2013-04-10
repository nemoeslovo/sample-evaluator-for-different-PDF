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

@implementation TLAppDelegate {
    @private
    TLEvaluator *_evaluator;
    PlotDelegate *_plotDelegate;
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
}

- (IBAction)onSampleClick:(id)sender {
    NSInteger elementsCount = [[[[self elementsCount] selectedItem] title] integerValue];
    [_evaluator evaluateForCount:elementsCount];
    [[self tfD]  setStringValue:[[NSNumber numberWithFloat:[_evaluator d]]  stringValue]];
    [[self tfMO] setStringValue:[[NSNumber numberWithFloat:[_evaluator mo]] stringValue]];
    [_plotDelegate addPlot:[_evaluator sampleGraphData]];
    [_plotDelegate redraw];
}

@end