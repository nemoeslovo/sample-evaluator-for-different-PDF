//
//  TLEvaluator.h
//  lab3modeling
//
//  Created by Danila Kolesnikov on 3/27/13.
//  Copyright (c) 2013 dandandan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLEvaluator : NSObject

@property(nonatomic, readonly) NSArray *sample;
@property(nonatomic, readonly) CGFloat mo;
@property(nonatomic, readonly) CGFloat d;

- (void)reEvaluateForCount:(NSInteger)i;

@end
