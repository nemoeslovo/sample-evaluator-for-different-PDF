//
//  TLEvaluator.m
//  lab3modeling
//
//  Created by Danila Kolesnikov on 3/27/13.
//  Copyright (c) 2013 dandandan. All rights reserved.
//

#import "TLEvaluator.h"

static const inline CGFloat _randomInRange(CGFloat smallNumber, CGFloat bigNumber) {
    CGFloat diff = bigNumber - smallNumber;
    return (((CGFloat) rand() / RAND_MAX) * diff) + smallNumber;
}
#define randomInRange(min, max) _randomInRange(min, max)

static const inline CGFloat _sqr(CGFloat x) {
    return x*x;
}
#define sqr(x) _sqr(x)


#define IDEAL_SAMPLE_COUNT 99999

@interface TLEvaluator ()

- (id)initWithPDF:(PdfFunction)pdfFunction andRange:(NSPoint)range;

- (NSArray *)evaluateSampleForDispersion:(CGFloat)d graphData:(NSArray *)data isDownEdge:(BOOL)isDownEdge;

- (CGFloat)evaluateDForSample:(NSArray *)sample andMO:(CGFloat)mo;
- (CGFloat)evaluateMOforSample:(NSArray *)sample;
- (NSArray *)evaluateSampleForCount:(NSInteger)sampleCount;

@end


@implementation TLEvaluator {
    NSArray *_sample;
@private
    CGFloat _mo;
    CGFloat _d;
    NSArray *_sampleGraphDownEdge;
    NSArray *_sampleGraphUpEdge;
}

@synthesize mo = _mo;
@synthesize d  = _d;
@synthesize sampleGraphDownEdge = _sampleGraphDownEdge;
@synthesize sampleGraphUpEdge = _sampleGraphUpEdge;

+ (id)evaluatorWithPdf:(PdfFunction)pdfFunction andRange:(NSPoint)range {
    return [[self alloc] initWithPDF:pdfFunction andRange:range];
}

- (id)initWithPDF:(PdfFunction)pdfFunction andRange:(NSPoint)range {
    self = [super init];
    if (self) {
        _range = range;
        [self setPdfFunction:pdfFunction];
    }
    return self;
}

- (void)evaluateForCount:(NSInteger)elementsCount {
    _sample              = [self evaluateSampleForCount:elementsCount];
    _mo                  = [self evaluateMOforSample:[self sample]];
    _d                   = [self evaluateDForSample:[self sample] andMO:[self mo]];
    _sampleGraphData     = [self formSampleGraphData:_sample];

    _sampleGraphDownEdge = [self evaluateSampleForDispersion:_d
                                                   graphData:_sampleGraphData
                                                  isDownEdge:YES];
    _sampleGraphUpEdge   = [self evaluateSampleForDispersion:_d
                                                   graphData:_sampleGraphData
                                                  isDownEdge:NO];
}

/*
* используется для формирования нижней и верхней границы
* относительно полученной выборки. получается путем прибавления
* или вычитания дисперсии к каждому значению выборки
* */
- (NSArray *)evaluateSampleForDispersion:(CGFloat)d
                               graphData:(NSArray *)data
                              isDownEdge:(BOOL)isDownEdge {
    NSMutableArray *newSample = [NSMutableArray arrayWithCapacity:[data count]];
    for (NSArray *xy in data) {
        CGFloat step = d;
        if (isDownEdge) {
            step *= -1;
        }
        CGFloat newY = [xy[1] floatValue] + step;
        NSArray *correctedPoint = [self formArrayWithX:xy[0] andY:[NSNumber numberWithFloat:newY]];
        [newSample addObject:correctedPoint];
    }

    return newSample;
}

/*
* на вход принимает несортированную выборку, сортирует
* на выход выдает массив из массивов. каждый эллементарный
* массив состоит из 2-х эллементов - (x; y)
* */
- (NSArray *)formSampleGraphData:(NSArray *)array {

    //сортированная выборка является аргументами по x
    NSArray *_xArgs = [self sortArrayAscending:array];

    CGFloat nu = 1/(CGFloat)[_xArgs count];
    CGFloat f  = nu;
    NSMutableArray *_yArgs = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSNumber *number in _xArgs) {
        [_yArgs addObject:[NSNumber numberWithFloat:f]];
        f += nu;
    }

    return [self formGraphFromXArray:_xArgs andYArray:_yArgs];
}

- (NSArray *)formArrayWithX:(NSNumber *)_x andY:(NSNumber *)_y {
    return [NSArray arrayWithObjects:_x, _y, nil];
}

/*
* есть стандартная обертка возрастающей сортировки,
* ТОДО: в последствии упразднить эту функцию
* */
- (NSArray *)sortArrayAscending:(NSArray *)_array {
    NSArray *sorted = [_array sortedArrayUsingComparator:^(id firstObject, id secondObject) {
        CGFloat firstNumber  = [firstObject floatValue];
        CGFloat secondNumber = [secondObject floatValue];
        if (firstNumber > secondNumber) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    return sorted;
}

/*
* формируем несортированную выборку
* */
- (NSArray *)evaluateSampleForCount:(NSInteger)sampleCount {
    NSMutableArray *sample = [NSMutableArray arrayWithCapacity:sampleCount];
    for (int i = 0; i < sampleCount; i++) {
        CGFloat simpleRandom        = randomInRange(_range.x, _range.y);
        CGFloat randomInRelateOfPDF = [self pdfFunction](simpleRandom);
        sample[i] = [NSNumber numberWithFloat:randomInRelateOfPDF];
    }
    return sample;
}

/*
* считаем дисперсию
* */
- (CGFloat)evaluateDForSample:(NSArray *)sample andMO:(CGFloat)mo {
    CGFloat d = 0;
    for (NSNumber *number in sample) {
        CGFloat part = mo - [number doubleValue];
        d += part*part;
    }

    d /= [sample count];
    return d;
}

/*
* считаем мат. ожидание
* */
- (CGFloat)evaluateMOforSample:(NSArray *)sample {
    CGFloat mo = 0;
    for (NSNumber *number in sample) {
        mo += [number doubleValue];
    }

    mo /= [sample count];
    return mo;
}

- (NSArray *)statisticsCDF {
    return [self statisticsCDFforSample:[self sortArrayAscending:_sample]];
}

/*
* расчет статистической функции распределения
* */
 - (NSArray *)statisticsCDFforSample:(NSArray *)sample {
    NSMutableArray *yArgs = [NSMutableArray arrayWithCapacity:[sample count]];
    for (NSNumber *number in sample) {
        NSInteger y = [self statisticCDFinX:[number floatValue] andSample:sample];
        [yArgs addObject:[NSNumber numberWithInt:y]];
    }
    return [self formGraphFromXArray:sample andYArray:yArgs];
}

- (NSInteger)statisticCDFinX:(CGFloat)_x andSample:(NSArray *)_sample {
    NSInteger result = 0;
    for (int i = 0; i < [_sample count]; i++) {
        if (_x - [_sample[i] floatValue] >= 0) {
            result++;
        }
    }
    return result;
}

- (NSArray *)formGraphFromXArray:(NSArray *)_xArgs andYArray:(NSArray *)_yArgs {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[_xArgs count]];
    for (int i = 0; i < [_xArgs count]; i++) {
        NSArray *point = [NSArray arrayWithObjects:_xArgs[i], _yArgs[i], nil];
        [result addObject:point];
    }
    return result;
}

/*
* выводит в логи любой массив из NSNumber float
* */
- (void)logSample:(NSArray *)array {
    for (int i = 0; i<[array count]; i++) {
        NSLog(@"sample[%d] = %f", i, [array[i] floatValue]);
    }
}






@end