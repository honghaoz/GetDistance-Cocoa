//
//  AppDelegate.h
//  GetDistance
//
//  Created by Honghao on 8/2/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *origin;
@property (weak) IBOutlet NSTextField *destination;
@property (weak) IBOutlet NSButton *getButton;
@property (weak) IBOutlet NSTextField *driveDistance;
@property (weak) IBOutlet NSTextField *transitTime;
@property (weak) IBOutlet NSTextField *bathRoom;
@property (weak) IBOutlet NSTextField *isApartment;
@property (weak) IBOutlet NSTextField *rentFee;

- (IBAction)get:(id)sender;

@end
