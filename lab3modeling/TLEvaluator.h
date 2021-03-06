//
//  TLEvaluator.h
//  lab3modeling
//
//  Created by Danila Kolesnikov on 3/27/13.
//  Copyright (c) 2013 dandandan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CGFloat (^PdfFunction)(CGFloat);

static const inline CGFloat _acot(CGFloat number) {
    return M_PI_2 - atan(number);
}
#define acot(number) _acot(number)

@interface TLEvaluator : NSObject {
    NSArray *_sampleGraphData;
}

@property(nonatomic, readonly) NSArray     *sample;
@property(nonatomic, readonly) CGFloat     mo;
@property(nonatomic, readonly) CGFloat     d;
@property(nonatomic, copy)     PdfFunction pdfFunction;
@property(nonatomic)           NSPoint     range;

@property(nonatomic, strong)   NSArray     *sampleGraphData;
@property(nonatomic, strong)   NSArray     *sampleGraphDownEdge;
@property(nonatomic, strong)   NSArray     *sampleGraphUpEdge;


+ (id)evaluatorWithPdf:(PdfFunction)pdfFunction andRange:(NSPoint)range;

- (void)evaluateForCount:(NSInteger)i;

- (NSArray *)statisticsCDF;

- (BOOL)isConvergence;
@end
