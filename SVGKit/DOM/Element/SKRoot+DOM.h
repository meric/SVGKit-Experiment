//
//  SKRoot+DOM.h
//  SVGKit
//
//  Created by Eric Man on 10/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKRoot.h"
@class SKDocument;

@interface SKRoot (SKDOM)
- (void)addedToDocument:(SKDocument *)document;
- (void)removedFromDocument;
@end

