//
//  TLEvaluator.m
//  lab3modeling
//
//  Created by Danila Kolesnikov on 3/27/13.
//  Copyright (c) 2013 dandandan. All rights reserved.
//

#import "TLEvaluator.h"


@interface TLEvaluator ()
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

- (CGFloat)evaluateDForSample:(NSArray *)array andMO:(CGFloat)mo {
    return 0;
}

- (CGFloat)evaluateMOforSample:(NSArray *)array {
    return 0;
}

- (NSArray *)elevateSampleForCount:(NSInteger)i {
    return nil;
}


@end