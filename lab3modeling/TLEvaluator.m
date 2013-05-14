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

static NSArray *idealSampleGraphData;
static CGFloat  idealSampleMO;
static CGFloat  idealSampleD;

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

        NSArray *idealSample      = [self evaluateSampleForCount:IDEAL_SAMPLE_COUNT];
        idealSampleMO             = [self evaluateMOforSample:idealSample];
        idealSampleD              = [self evaluateDForSample:idealSample andMO:idealSampleMO];
        idealSampleGraphData      = [self formSampleGraphData:idealSample];
    }
    return self;
}

- (void)evaluateForCount:(NSInteger)elementsCount {
    _sample              = [self evaluateSampleForCount:elementsCount];
//    [self logSample:_sample];
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

- (NSArray *)formSampleGraphData:(NSArray *)array {
    NSArray *sortedArray = [self sortArrayAscending:array];

    NSMutableArray *graphData = [NSMutableArray array];

    CGFloat nu = 1/(CGFloat)[sortedArray count];
    CGFloat f  = nu;
    for (NSNumber *number in sortedArray) {
        NSArray *point = [self formArrayWithX:number andY:[NSNumber numberWithFloat:f]];
        f += nu;
        [graphData addObject:point];
    }

    return graphData;
}

- (NSArray *)formArrayWithX:(NSNumber *)_x andY:(NSNumber *)_y {
    return [NSArray arrayWithObjects:_x, _y, nil];
}

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

- (void)logSample:(NSArray *)array {
    for (int i = 0; i<[array count]; i++) {
        NSLog(@"sample[%d] = %f", i, [array[i] floatValue]);
    }
}

- (CGFloat)evaluateDForSample:(NSArray *)sample andMO:(CGFloat)mo {
    CGFloat d = 0;
    for (NSNumber *number in sample) {
        CGFloat part = mo - [number doubleValue];
        d += part*part;
    }

    d /= [sample count];
    return d;
}

- (CGFloat)evaluateMOforSample:(NSArray *)sample {
    CGFloat mo = 0;
    for (NSNumber *number in sample) {
        mo += [number doubleValue];
    }

    mo /= [sample count];
    return mo;
}

- (NSArray *)evaluateSampleForCount:(NSInteger)sampleCount {
    NSMutableArray *sample = [NSMutableArray arrayWithCapacity:sampleCount];
    for (int i = 0; i < sampleCount; i++) {
        CGFloat simpleRandom        = randomInRange(_range.x, _range.y);
        CGFloat randomInRelateOfPDF = [self pdfFunction](simpleRandom);
        sample[i] = [NSNumber numberWithFloat:randomInRelateOfPDF];
    }
    return sample;
}


@end