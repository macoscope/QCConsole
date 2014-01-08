//
//  MCQCMessageCellView.m
//  QCConsole
//
//  Created by Daniel on 07.05.2013.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//

#import "MCQCMessageCellView.h"
#import "MCQCLoggedMessage.h"
#import "NS(Attributed)String+Geometrics.h"

NSString * const kDefaultUntitledCompositionName = @"Untitled.qtz";
NSUInteger const kDefaultCollapsedTableRowHeight = 19;


@interface MCQCMessageCellView ()
@property(nonatomic, strong) NSDictionary *regularTextAttrs;
@property(nonatomic, strong) NSDictionary *strongTextAttrs;
@property(nonatomic) BOOL collapsed;

@end

@implementation MCQCMessageCellView

- (void)awakeFromNib
{
    self.regularTextAttrs = @{NSFontAttributeName : [NSFont fontWithName:@"Menlo-Regular" size:11.0]};
    self.strongTextAttrs = @{NSFontAttributeName : [NSFont fontWithName:@"Menlo-Bold" size:11.0]};
}

- (void)populateWithMessage:(MCQCLoggedMessage *)message rowIndex:(NSUInteger)row
{
    self.rowIndex = row;
    self.collapsed = message.collapsedFlag;
    
    NSAttributedString *richMessageText = [self formatMessage:message collapsed:self.collapsed];
    [self.textField setAttributedStringValue:richMessageText];
    
    NSString *typeName = [message valueTypeName];
    NSImage *typeIcon = [[NSBundle bundleForClass:[self class]] imageForResource:typeName];
    self.imageView.image = typeIcon;
    self.imageView.toolTip =  typeName;
    
    [self.disclosureButton setState: self.collapsed ? NSOffState : NSOnState ];
}

- (CGFloat)computeRequiredCellHeight
{
    if(self.collapsed){
        return kDefaultCollapsedTableRowHeight;
    }
    
    CGFloat textFieldWidth = NSWidth(self.textField.frame);
    
    gNSStringGeometricsTypesetterBehavior = NSTypesetterBehavior_10_2_WithCompatibility;
    CGFloat textHeight = [self.textField.attributedStringValue heightForWidth:textFieldWidth];
    
    return textHeight + self.textField.frame.origin.y;
}


#pragma mark - Private methods

- (NSAttributedString *)formatMessage:(MCQCLoggedMessage *)message collapsed:(BOOL)collapsed
{
    //  2.008409 *ConsoleSample.qtz:* [DESC]
    //  *Arguments:*
    //  [ARGS]
    NSMutableString *messageLine = [NSMutableString string];
    NSString *argumentsSubtitle = NSLocalizedString(@"Arguments", @"Message line arguments section subtitle");
    NSRange compositionNameRange = NSMakeRange(NSNotFound, 0);
    NSRange argumentsSubtitleRange = NSMakeRange(NSNotFound, 0);
    NSRange patchNameRange = NSMakeRange(NSNotFound, 0);
    
    //Timestamp
    [messageLine appendFormat:@"% 10f ", message.timestamp];
    
    //Composition name
    NSString *compositionName = kDefaultUntitledCompositionName;
    compositionNameRange.location = [messageLine length];
    NSURL *compositionURL = message.compositionURL;
    if (![[NSNull null] isEqualTo:compositionURL] && nil != compositionURL) {
        compositionName = [compositionURL lastPathComponent];
    }
    compositionNameRange.length = [compositionName length];
    [messageLine appendString:compositionName];
    
    [messageLine appendString:@": "];
    
    // Message body
    if(message.patchName){
        patchNameRange.location = [messageLine length];
        patchNameRange.length = [message.patchName length];
        
        [messageLine appendString:message.patchName];
        [messageLine appendString:@" = "];
    }
    NSString *valueDesc = message.valueDescription;
    if (collapsed) {
        // Squashing all repated whitespaces in the description string
        NSArray *fragments = [valueDesc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [fragments enumerateObjectsUsingBlock:^(NSString *fragment, NSUInteger idx, BOOL *stop) {
            if ([fragment length] > 0) {
                [messageLine appendString:fragment];
                [messageLine appendString:@" "];
            }
        }];
    } else {
        [messageLine appendString:@"\n"];
        [messageLine appendString:valueDesc];
    }
    
    // Arguments
    if ([message.arguments count] > 0) {
        [messageLine appendString:@"\n"];
        argumentsSubtitleRange.location = [messageLine length];
        [messageLine appendString:argumentsSubtitle];
        argumentsSubtitleRange.length = [argumentsSubtitle length];
        [messageLine appendString:@" \n"];
        
        NSString *argumentsDescr = [message.arguments description];
        [messageLine appendString:argumentsDescr];
    }
    
    
    NSMutableAttributedString *richMessageText = [[NSMutableAttributedString alloc] initWithString:messageLine attributes:self.regularTextAttrs];
    //[richMessageText setAttributes:self.strongTextAttrs range:compositionNameRange];
    if (patchNameRange.location!=NSNotFound) {
        [richMessageText setAttributes:self.strongTextAttrs range:patchNameRange];
    }
    if (argumentsSubtitleRange.location != NSNotFound) {
        [richMessageText setAttributes:self.strongTextAttrs range:argumentsSubtitleRange];
    }
    
    return [richMessageText autorelease];
}



@end
