//  MCQCConsolePrincipal.h
//  QCConsole
//
//  Created by Daniel on 06.05.2013.
//  Copyright 2013 Macoscope. All rights reserved.

@interface MCQCConsolePrincipal : NSObject <GFPlugInRegistration>
+(void)registerNodesWithManager:(QCNodeManager*)manager;
@end
