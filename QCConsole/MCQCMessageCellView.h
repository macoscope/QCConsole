//
//  MCQCMessageCellView.h
//  QCConsole
//
//  Created by Daniel on 07.05.2013.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MCQCLoggedMessage;
@interface MCQCMessageCellView : NSTableCellView
@property (assign) NSUInteger rowIndex;
@property (assign) IBOutlet NSButton *disclosureButton;


- (void)populateWithMessage:(MCQCLoggedMessage *)message rowIndex:(NSUInteger)row;

- (CGFloat)computeRequiredCellHeight;


@end
