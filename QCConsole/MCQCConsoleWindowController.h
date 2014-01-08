//
//  MCQCConsoleWindowController.h
//  QCConsole
//
//  Created by Daniel on 07.05.2013.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MCQCValueConverter;

@interface MCQCConsoleWindowController : NSWindowController  <NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource>
+ (instancetype)sharedInstance;
@property (assign) IBOutlet NSTableView *messagesTable;
@property (assign) IBOutlet NSString *status;


@property(nonatomic, retain) id rulerMessageCellView;

- (void)logValue:(id)rawValue time:(NSTimeInterval)time userInfo:(NSDictionary*)userInfo;
- (void)cleanupLogWithCompositionURL:(NSURL*)compositionURL;

- (IBAction)disclosureButtonClicked:(id)sender;
@end
