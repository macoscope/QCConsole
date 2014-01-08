//
//  MCQCConsolePatch.m
//  QCConsole
//
//  Created by Daniel on 06.05.2013.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//

#import "MCQCConsolePatch.h"
#import "MCQCConsoleWindowController.h"

@implementation MCQCConsolePatch
+(BOOL)isSafe
{
	return NO;
}

+(BOOL)allowsSubpatchesWithIdentifier:(id)identifier
{
	return NO;
}

+(QCPatchExecutionMode)executionModeWithIdentifier:(id)identifier
{
	return kQCPatchExecutionModeConsumer;
}

+(QCPatchTimeMode)timeModeWithIdentifier:(id)identifier
{
	return kQCPatchTimeModeIdle;
}

-(id)initWithIdentifier:(id)identifier
{
	if(self = [super initWithIdentifier:identifier])
	{
        //NSLog(@"Identifier: %@", identifier);
		//[[self userInfo] setObject:@"Custom Patch" forKey:@"name"];
	}
	return self;
}

-(BOOL)setup:(QCOpenGLContext*)context
{
    [[MCQCConsoleWindowController sharedInstance] showWindow:self];
    [[MCQCConsoleWindowController sharedInstance] cleanupLogWithCompositionURL:[self compositionURL]] ;
    
	return YES;
}

-(void)cleanup:(QCOpenGLContext*)context
{
    // [[[MCQCConsoleWindowController sharedInstance] cleanupLog];
}

-(void)enable:(QCOpenGLContext*)context
{
}

-(void)disable:(QCOpenGLContext*)context
{
}

-(BOOL)execute:(QCOpenGLContext*)context time:(double)time arguments:(NSDictionary*)arguments
{
    
    if ([inputValue wasUpdated]){
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary: (arguments ?: @{})];
        [userInfo setObject:[self compositionURL] forKey:@"compositionURL"];
        
        NSString *patchName = [self _getUserInfo:@"name"];
        if(nil!=patchName){
            [userInfo setObject:patchName forKey:@"name"];
        }
        
        [[MCQCConsoleWindowController sharedInstance] logValue: [inputValue rawValue]
                                                          time: time
                                                      userInfo: userInfo];
        
    }
	return YES;
}

- (NSURL*)compositionURL
{
    NSDictionary *options = [self _getUserInfo:@".options"];
    return  [options objectForKey:@"compositionURL"] ?: [NSNull null];
}
@end
