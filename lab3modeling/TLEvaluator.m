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


@interface TLEvaluator ()

- (CGFloat)evaluateDForSample:(NSArray *)sample andMO:(CGFloat)mo;
- (CGFloat)evaluateMOforSample:(NSArray *)sample;
- (NSArray *)elevateSampleForCount:(NSInteger)sampleCount;

@end


@implementation TLEvaluator {
    NSArray *_sample;
@private
    CGFloat _mo;
    CGFloat _d;
}

@synthesize mo = _mo;
@synthesize d  = _d;

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
    _sample = [self elevateSampleForCount:elementsCount];
    [self logSample:_sample];
    _mo     = [self evaluateMOforSample:[self sample]];
    _d      = [self evaluateDForSample:[self sample] andMO:[self mo]];
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

- (NSArray *)elevateSampleForCount:(NSInteger)sampleCount {
    NSMutableArray *sample = [NSMutableArray arrayWithCapacity:sampleCount];
    for (int i = 0; i < sampleCount; i++) {
        CGFloat simpleRandom        = randomInRange(_range.x, _range.y);
        CGFloat randomInRelateOfPDF = [self pdfFunction](simpleRandom);
        sample[i] = [NSNumber numberWithFloat:randomInRelateOfPDF];
    }
    return sample;
}


@end