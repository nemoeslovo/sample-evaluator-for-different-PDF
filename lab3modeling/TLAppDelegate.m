//
//  TLAppDelegate.m
//  lab3modeling
//
//  Created by Danila Kolesnikov on 3/27/13.
//  Copyright (c) 2013 dandandan. All rights reserved.
//

#import "TLAppDelegate.h"
#import "TLEvaluator.h"

@implementation TLAppDelegate {
    @private
    TLEvaluator *_evaluator;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _evaluator = [[TLEvaluator alloc] init];
}

- (IBAction)onSampleClick:(id)sender {
    NSInteger elementsCount = [[[[self elementsCount] selectedItem] title] integerValue];
    NSArray *array = [_evaluator reEvaluateForCount:elementsCount];


}

@end
