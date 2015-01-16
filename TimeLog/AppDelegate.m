//
//  AppDelegate.m
//  TimeLog
//
//  Created by Anders Hovmöller on 2012-06-04.
//  Copyright (c) 2012 Satans Killingar. All rights reserved.
//

#import "AppDelegate.h"
#import "JAProcessInfo.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(locked:) name:NSWorkspaceScreensDidSleepNotification object:nil];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(unlocked:) name:NSWorkspaceScreensDidWakeNotification object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(timer:)
                                   userInfo:nil
                                    repeats:YES];    
}

- (void)log:(char*)s
{
    FILE* f = fopen("/Users/andersh/lock_unlock.log", "a");
    
    time_t currentTime = time(NULL);
    struct tm timeStruct;
    localtime_r(&currentTime, &timeStruct);
    char buffer[200];
    strftime(buffer, 20, "%Y-%m-%d %H:%M:%S", &timeStruct);
    
    fprintf(f, "%s\t%s\n", buffer, s);
    
    fclose(f); 
}

- (void)timer:(id)sender
{
    JAProcessInfo *procInfo = [[JAProcessInfo alloc] init];
    
    [procInfo obtainFreshProcessList]; // Get a list of process
    BOOL isRunning = [procInfo findProcessWithName:@"SC2"];
    
    if (self->starcraftRunning != isRunning) {
        if (isRunning) {
            [self log:"SC2 started"];
        }
        else {
            [self log:"SC2 stopped"];
        }
    }
    self->starcraftRunning = isRunning;
}

- (void)locked:(id)sender
{
    [self log:"locked"];
}

- (void)unlocked:(id)sender
{
    [self log:"unlocked"];
}

@end
