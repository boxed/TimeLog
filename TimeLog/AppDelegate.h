//
//  AppDelegate.h
//  TimeLog
//
//  Created by Anders Hovmöller on 2012-06-04.
//  Copyright (c) 2012 Satans Killingar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    BOOL starcraftRunning;
}

- (void)locked:(id)sender;
- (void)unlocked:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
