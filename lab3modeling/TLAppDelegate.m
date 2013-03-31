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

@implementation TLAppDelegate {
    @private
    TLEvaluator *_evaluator;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    //задаем предварительно расчитанную функцию плотности распределения
    //вероятности (the probability density function)
    PdfFunction pdf = ^(CGFloat number) {
        CGFloat result = acot(1 - number) + M_PI_4;
        return result;
    };

    //задаем интервал выборки
    NSPoint *range;
    range->x = 0;
    range->y = M_PI_4;

    //создаем объект, содержащий все необходимые нам вычислительные функции
    _evaluator = [TLEvaluator evaluatorWithPdf:pdf andRange:range];

}

- (IBAction)onSampleClick:(id)sender {
    NSInteger elementsCount = [[[[self elementsCount] selectedItem] title] integerValue];
    [_evaluator evaluateForCount:elementsCount];
}

@end
