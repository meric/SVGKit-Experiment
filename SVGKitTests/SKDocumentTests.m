//
//  SKDocumentTests.m
//  SVGKit
//
//  Created by Eric Man on 6/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import "SKDocumentTests.h"
#import "SVGKit.h"
#import "SVGKit+DOM.h"
#import "SKDocument.h"
#import "SKRoot.h"

@implementation SKDocumentTests

- (void)testSimple
{
    SKDocument *document = [SKDocument new];
    NSString *rootName = document.root.name;
    STAssertEquals(rootName, @"svg", @"SVGDocument init");
    [document release];
}

- (void)testWidth
{
    NSString *svg = @"<svg wIdth=\"1\" height=\"2\"></svg>";
    SKDocument *document = [[SKDocument alloc] initWithSVGString:svg error:nil];
    STAssertEquals(document.root.width == nil, true, @"");// case-sensitive test
    STAssertEquals(document.root.height != nil, true, @"");
    STAssertEqualObjects(svg, [document.root XMLString], @"");
    [document release];
}

- (void)testParse
{
    NSError *error;
    NSString *name = @"Lion";
    NSString *path = [[NSBundle bundleForClass:[self class]] 
                      pathForResource:name ofType:@"svg"];
    NSString *svg = [NSString stringWithContentsOfFile:path 
                                              encoding:NSUTF8StringEncoding 
                                                 error:&error];
    if (!svg) {
        NSLog(@"%@", error);
    }
    STAssertTrue(svg != nil, @"Test image does not exist.");
    SKDocument *document = [[SKDocument alloc] initWithSVGString:svg 
                                                           error:&error];
    if (!document) {
        NSLog(@"%@", error);
    }
    STAssertTrue(document != nil, @"SKDocument failed to init from String.");
    SKLength *width = document.root.width;
    SKLength *length = [[[SKLength alloc] init] autorelease];
    length.value = 15;
    length.unit = SKCM;
    
    STAssertTrue(width != nil, @"");
    STAssertTrue(width.value == length.value && 
                 width.unit == length.unit,
                 @"SKDocument width not saved %@ %@", 
                 [length description], [width description]);
    [document release];
}

@end

