//
//  MCQCConsoleWindowController.m
//  QCConsole
//
//  Created by Daniel on 07.05.2013.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//

#import "MCQCConsoleWindowController.h"
#import "MCQCMessageCellView.h"

#import "MCQCLoggedMessage.h"



@interface MCQCConsoleWindowController ()
@property(strong) NSMutableArray *messages;
@property(assign) NSUInteger lastMessageRow;

@end

@implementation MCQCConsoleWindowController


+ (instancetype)sharedInstance
{
    static MCQCConsoleWindowController *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[[self class] alloc] initWithWindowNibName:@"ConsoleWindow"];
    });
    return sharedInstance;
}

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        self.messages = [NSMutableArray arrayWithCapacity:4000];
    }
    return self;
}

#pragma mark - Window delegate
- (void)windowDidResize:(NSNotification *)notification
{
    if (![[self window] inLiveResize]) {
        [self reloadDataPreservingSelection];
    }
}

- (void)windowDidEndLiveResize:(NSNotification *)notification
{
    [self reloadDataPreservingSelection];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.messagesTable.doubleAction = @selector(tableDoubleClicked:);
    self.rulerMessageCellView = [self.messagesTable makeViewWithIdentifier:@"MessageCell" owner:self];
    self.status = NSLocalizedString(@"No message", @"");
}

#pragma mark - Public methods
- (void)cleanupLogWithCompositionURL:(NSURL *)compositionURL
{
    [self.messages removeAllObjects];
    [self.messagesTable reloadData];
}

- (void)logValue:(id)rawValue time:(NSTimeInterval)time userInfo:(NSDictionary *)args
{
    MCQCLoggedMessage *message = [[MCQCLoggedMessage alloc] initWithRawQCValue:rawValue time:time arguments:args];
    [self appendMessageToTable:message];
    [message release];
}

#pragma mark - Actions
- (IBAction)tableDoubleClicked:(id)sender
{
    NSInteger clickedRow = [self.messagesTable clickedRow];
    [self toggleCellCollapsingInRow:clickedRow];
}

- (IBAction)disclosureButtonClicked:(id)sender
{
    NSInteger clickedRow = [self.messagesTable rowForView:sender];
    [self toggleCellCollapsingInRow:clickedRow];
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.messages count];
}

#pragma mark - NSTableViewDelegate
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    MCQCMessageCellView *messageCell = [tableView makeViewWithIdentifier:@"MessageCell" owner:self];
    
    MCQCLoggedMessage *message = [self.messages objectAtIndex:row];
    
    [messageCell populateWithMessage:message rowIndex:row];
    
    return messageCell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    //http://stackoverflow.com/questions/7504546/view-based-nstableview-with-rows-that-have-dynamic-heights
    NSRect frame = NSMakeRect(0, 0, NSWidth(self.messagesTable.frame), NSHeight(self.messagesTable.frame));
    [self.rulerMessageCellView setFrame:frame];
    
    MCQCLoggedMessage *message = [self.messages objectAtIndex:row];
    [self.rulerMessageCellView populateWithMessage:message rowIndex:NSNotFound];
    
    return [self.rulerMessageCellView computeRequiredCellHeight];
}

#pragma mark Private methods
- (void)appendMessageToTable:(MCQCLoggedMessage *)message
{
    [self.messages addObject:message];
    
    // Trick stolen from NSLogger... schedule a table reload. Do this asynchronously (and cancellable-y) so we can limit the
    // number of reload requests in case of high load
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshTableView) object:nil];
    [self performSelector:@selector(refreshTableView) withObject:nil afterDelay:0];
}

- (void)refreshTableView
{
    NSAssert([NSThread isMainThread], @"Ooops we need to be called from the main thread to update the UI state" );
    
    if (self.messages.count > 0) {
        
        NSRect r = [[self.messagesTable superview] convertRect:[[self.messagesTable superview] bounds] toView:self.messagesTable];
        NSRange visibleRows = [self.messagesTable rowsInRect:r];
        BOOL visibleLastRow = (visibleRows.location == NSNotFound ||
                               visibleRows.length == 0 ||
                               (visibleRows.location + visibleRows.length) >= self.lastMessageRow);
        
        //Turning off the table animation to make the data appending more smooth
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0];
        [self.messagesTable noteNumberOfRowsChanged];
        
        if (visibleLastRow) {
            [self.messagesTable scrollRowToVisible:[self.messages count] - 1];
        }
        [NSAnimationContext endGrouping];
        
    } else {
        [self.messagesTable noteNumberOfRowsChanged];
    }
    
    self.lastMessageRow = [self.messages count];
    self.status = [NSString stringWithFormat:NSLocalizedString(@"%u messages", @"Statusbar message"), self.lastMessageRow];
}

- (void)toggleCellCollapsingInRow:(NSInteger)clickedRow
{
    if(clickedRow<0){
        return;
    }
    
    MCQCMessageCellView *clickedCell = [self.messagesTable viewAtColumn:0 row:clickedRow makeIfNecessary:NO];
    
    if (nil!=clickedCell){
        MCQCLoggedMessage *message = [self.messages objectAtIndex:clickedRow];
        message.collapsedFlag ^= YES;
        
        // Refresh the cell state before changing its frame...
        [clickedCell populateWithMessage:message rowIndex:clickedRow];
        
        [self.messagesTable noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:clickedCell.rowIndex]];
    }
    
}

- (void)reloadDataPreservingSelection
{
    NSInteger selection = [self.messagesTable selectedRow];
    [self.messagesTable reloadData];
    if (selection > -1 && selection < [self.messagesTable numberOfRows]) {
        [self.messagesTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selection] byExtendingSelection:NO];
    }
}

@end













