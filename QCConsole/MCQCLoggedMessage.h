//
//  MCQCLoggedMessage.m
//
//  Created by Daniel on 09.05.2013.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//
#import <Foundation/Foundation.h>

enum {
  MCQCNull,

  MCQCBoolean,
  MCQCIndex,
  MCQCNumber,
  
  MCQCString,
  MCQCStructure,
  
  MCQCColor,
  MCQCImage,
  MCQCMesh,
  MCQCInteraction,
  MCQCVirtual
};
typedef NSUInteger MCQCInputValueType;

@interface MCQCLoggedMessage : NSObject
@property(nonatomic, assign) MCQCInputValueType valueType;
@property(nonatomic, retain) NSString *valueTypeName;
@property(nonatomic, assign) NSTimeInterval timestamp;
@property(nonatomic, retain) NSURL *compositionURL;
@property(nonatomic, retain) NSString *valueDescription;
@property(nonatomic, retain) NSDictionary *arguments;
@property(nonatomic, retain) NSString *patchName;

@property(nonatomic, assign) BOOL collapsedFlag;

- (id)initWithRawQCValue:(id)rawQCValue time:(NSTimeInterval)timestamp arguments:(NSDictionary *)args;

@end