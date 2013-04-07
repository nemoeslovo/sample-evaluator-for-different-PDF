//
//  TLAppDelegate.h
//  lab3modeling
//
//  Created by Danila Kolesnikov on 3/27/13.
//  Copyright (c) 2013 dandandan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface TLAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow        *window;
@property IBOutlet CPTGraphHostingView      *plotView;
@property (weak) IBOutlet NSPopUpButtonCell *elementsCount;
@property (weak) IBOutlet NSTextField       *tfMO;
@property (weak) IBOutlet NSTextField       *tfD;

- (IBAction)onSampleClick:(id)sender;

@end