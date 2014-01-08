//
//  MCQCLoggedMessage.m
//
//  Created by Daniel on 09.05.2013.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//

#import "MCQCLoggedMessage.h"
#import <SkankySDK/SkankySDK.h>




@implementation MCQCLoggedMessage {
    
}

- (id)initWithRawQCValue:(id)rawQCValue time:(NSTimeInterval)timestamp arguments:(NSDictionary *)args {
    self = [super init];
    if (self) {
        [self resolveTypeAndDescribe:rawQCValue];
        
        self.patchName = args[@"name"];
        self.collapsedFlag = YES;
        self.timestamp = timestamp;
        self.compositionURL = args[@"compositionURL"];
        self.arguments = [self stringifyDictionary:args];
    }
    return self;
}

- (void)dealloc
{
    self.valueTypeName = nil;
    self.compositionURL = nil;
    self.valueDescription = nil;
    self.arguments = nil;
    self.patchName = nil;
    
    [super dealloc];
}
- (void)resolveTypeAndDescribe:(id)rawQCValue {
    Class rawValueClass = [rawQCValue class];
    NSString *className = [rawQCValue className];
    
    MCQCInputValueType type;
    NSString *stringValue = nil;
    
    if(rawQCValue==nil || [NSNull null]==rawQCValue){
        type = MCQCNull;
        stringValue = @"NULL";
        
        
    } else if([rawValueClass isSubclassOfClass:[NSNumber class]]){
        const char *cType = [rawQCValue objCType];
        if( strcmp(cType, @encode(BOOL)) == 0){
            type = MCQCBoolean;
        } else if( strcmp(cType, @encode(long long)) == 0){
            type = MCQCIndex;
        } else if( strcmp(cType, @encode(double)) == 0){
            type = MCQCNumber;
        }else{
            NSLog(@"WARN: unrecognized C-type wrapped by NSNumber CTYPE: %s", [rawQCValue objCType]);
            type = MCQCNumber;
        }
        
    } else if([rawValueClass isSubclassOfClass:[NSString class]]){
        type = MCQCString;
        
    } else if([rawValueClass isSubclassOfClass:[QCStructure class]]){
        stringValue = [[(QCStructure*)rawQCValue dictionaryRepresentation] description];
        type = MCQCStructure;
        
    } else if([rawValueClass isSubclassOfClass:[NSColor class]]){
        type = MCQCColor;
        
    } else if([rawValueClass isSubclassOfClass:[QCImage class]]){
        type = MCQCImage;
        
    } else if([@"QCMesh" isEqualToString:className]){
        type = MCQCMesh;
        
    } else if([@"QCMouseInteraction" isEqualToString:className]){ //?
        type = MCQCInteraction;
        
    } else {
        type = MCQCVirtual;
    }
    
    self.valueType = type;
    self.valueTypeName = [self resolveTypeName:type];
    
    if (nil==stringValue) {
        stringValue = [rawQCValue description];
    }
    
    self.valueDescription = stringValue;
}

- (NSString *)resolveTypeName:(MCQCInputValueType)type
{
    NSString *typeName = @"Virtual";
    switch (type) {
        case MCQCNull:
            typeName = @"Null";
            break;
        case MCQCBoolean:
            typeName = @"Boolean";
            break;
        case MCQCIndex:
            typeName = @"Index";
            break;
        case MCQCNumber:
            typeName = @"Number";
            break;
        case MCQCString:
            typeName = @"String";
            break;
        case MCQCStructure:
            typeName = @"Structure";
            break;
        case MCQCColor:
            typeName = @"Color";
            break;
        case MCQCImage:
            typeName = @"Image";
            break;
        case MCQCMesh:
            typeName = @"Mesh";
            break;
        case MCQCInteraction:
            typeName = @"Interaction";
            break;
        case MCQCVirtual:
            typeName = @"Virtual";
            break;
        default:
            NSLog(@"Unrecognized input value type: %ld", type);
    }
    
    return typeName;
}

- (NSDictionary *)stringifyDictionary:(NSDictionary *)dict {
    NSMutableDictionary *stringified = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
    
    static NSSet *keysToSkip;
    if (nil==keysToSkip) {
        keysToSkip = [[NSSet setWithObjects:@"compositionURL", @"name", nil] retain];
    }
    
    //  for (NSString *key in [dict allKeys]) {
    //    if(![kKeysToSkip containsObject:key]){
    //      NSString *stringKey = [key description];
    //      NSString *stringVal = [[dict objectForKey:key] description];
    //
    //      stringified[stringKey] = stringVal;
    //    }
    //
    //  }
    [[dict allKeys] enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        
        if(![keysToSkip containsObject:key]){
            NSString *stringKey = [key description];
            NSString *stringVal = [[dict objectForKey:key] description];
            
            stringified[stringKey] = stringVal;
        }
    }];
    
    return stringified;
}

@end