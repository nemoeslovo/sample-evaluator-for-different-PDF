//
//  TLEvaluator.m
//  lab3modeling
//
//  Created by Danila Kolesnikov on 3/27/13.
//  Copyright (c) 2013 dandandan. All rights reserved.
//

#import "TLEvaluator.h"


@interface TLEvaluator ()
- (CGFloat)evaluateDForSample:(NSArray *)sample andMO:(CGFloat)mo;

- (CGFloat)evaluateMOforSample:(NSArray *)sample;

- (NSArray *)elevateSampleForCount:(NSInteger)i;
@end

@implementation TLEvaluator {
    NSArray *_sample;
@private
    CGFloat _mo;
    CGFloat _d;
}

@synthesize mo = _mo;
@synthesize d  = _d;

- (void)reEvaluateForCount:(NSInteger)elementsCount {
    _sample = [self elevateSampleForCount:elementsCount];
    _mo     = [self evaluateMOforSample:[self sample]];
    _d      = [self evaluateDForSample:[self sample] andMO:[self mo]];
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

- (NSArray *)elevateSampleForCount:(NSInteger)i {
    return nil;
}


@end