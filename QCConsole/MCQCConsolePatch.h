//
//  MCQCConsolePatch.h
//  QCConsole
//
//  Created by Daniel on 06.05.2013.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//
#import <SkankySDK/SkankySDK.h>

@interface MCQCConsolePatch : QCPatch
{
	QCVirtualPort *inputValue;
}

+(BOOL)isSafe;
+(BOOL)allowsSubpatchesWithIdentifier:(id)identifier;
+(QCPatchExecutionMode)executionModeWithIdentifier:(id)identifier;
+(QCPatchTimeMode)timeModeWithIdentifier:(id)identifier;
-(id)initWithIdentifier:(id)identifier;
-(BOOL)setup:(QCOpenGLContext*)context;
-(void)cleanup:(QCOpenGLContext*)context;
-(void)enable:(QCOpenGLContext*)context;
-(void)disable:(QCOpenGLContext*)context;
-(BOOL)execute:(QCOpenGLContext*)context time:(double)time arguments:(NSDictionary*)arguments;

@end
