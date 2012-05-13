//
//  SVGKit.h
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdarg.h>

#ifdef DEBUG
#define SKWarn(m, ...) \
NSLog([@"warning: " stringByAppendingString:m], __VA_ARGS__)
#define SKInfo(m, ...) \
NSLog([@"info: " stringByAppendingString:m], __VA_ARGS__)
#else
#define SKWarn(m, ...) 
#define SKInfo(m, ...) 
#endif

#import "SKNode.h"
#import "SKDocument.h"
#import "SKElement.h"
#import "SKRoot.h"
