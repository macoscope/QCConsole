//  MCQCConsolePrincipal.m
//  QCConsole
//
//  Created by Daniel on 06.05.2013.
//  Copyright 2013 Macoscope. All rights reserved.

#import "MCQCConsolePrincipal.h"
#import "MCQCConsolePatch.h"

@implementation MCQCConsolePrincipal

+(void)registerNodesWithManager:(QCNodeManager*)manager
{
    KIRegisterPatch(MCQCConsolePatch);
}

@end
