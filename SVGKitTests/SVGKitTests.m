//
//  SVGKitTests.m
//  SVGKitTests
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import "SVGKitTests.h"
#import "SVGKit+DOM.h"

@implementation SVGKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}
/*
- (void)testMakeQuantity
{
    NSLog(@"%d", [@"em" intValue]);
    struct SKQuantity quantity = SKMakeQuantity(5, SKCM);
    STAssertEquals(quantity.unit, SKCM, @"struct SKQuantity unit mismatch");
    STAssertEquals(quantity.value, 5.0, @"struct SKQuantity value mismatch");
}

- (void)testStringFromNumber
{
    STAssertEqualObjects(SKStringFromNumber(2), @"2", @"2");
    STAssertEqualObjects(SKStringFromNumber(2.0010), @"2.001", @"2.001");
    STAssertEqualObjects(SKStringFromNumber(0.4), @"0.4", @"0.4");
    STAssertEqualObjects(SKStringFromNumber(0.0000), @"0", @"0");
}

- (void)testStringFromQuantity
{
    struct SKQuantity quantity = SKMakeQuantity(2, SKCM);
    STAssertEqualObjects(SKStringFromQuantity(quantity), @"2cm", @"2cm");
}

- (void)testScanSeparator
{
    NSString *string = @" , ";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    STAssertEquals(SKScanSeparator(scanner, nil), YES, @"");
}
*/

- (void)testScanColor
{
    NSString* string = @"   rgba(93, 123, 56, 1.0)";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    SKColor *color;
    BOOL success = SKScanColor(scanner, &color);
    STAssertEquals(success, YES, @"");
    STAssertEqualObjects([color.array objectAtIndex:0], 
                         [NSNumber numberWithDouble:93], @"");
    STAssertEqualObjects([color.array objectAtIndex:1], 
                         [NSNumber numberWithDouble:123], @"");
    STAssertEqualObjects([color.array objectAtIndex:2], 
                         [NSNumber numberWithDouble:56], @"");
    STAssertEqualObjects([color.array objectAtIndex:3], 
                         [NSNumber numberWithDouble:1.0], @"");
}
/*
- (void)testScanLength
{
    NSString* string = @"3";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    struct SKQuantity length;
    BOOL success = SKScanLength(scanner, &length);
    STAssertEquals(success, YES, @"");
    STAssertEquals(length.unit, SKNumber, @"");
}

- (void)testScanWhitespaces 
{
    NSString* string = @"      ";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    
    STAssertEquals(YES, SKScanWhitespaces(scanner, NULL), @"");
}

- (void)testScanNumberArray
{
    NSString* string = @"   0.6  , 3  70.0 ,4,623,63.9   ";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    NSArray *arr;
    double expected[6]={0.6,3,70,4,623,63.9};
    SKScanNumberArray(scanner, &arr);
    STAssertEquals([arr count], (NSUInteger)6, @"");
    for (int i = 0 ; i < 6; i++) {
        STAssertEquals([[arr objectAtIndex:i] doubleValue], expected[i], @"");
    }
    string = [string substringFromIndex:[scanner scanLocation]];
    STAssertEqualObjects(string, @"   ", @"[%@] %d", string, [scanner scanLocation]);
}

- (void)testScanMethod
{
    NSString *string = @"   scale  ";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    SKTransformMethod method;
    BOOL success = SKScanMethod(scanner, &method);
    string = [string substringFromIndex:[scanner scanLocation]];
    STAssertEquals(success, YES, @"parse %@ failed ", string);
}

- (void)testScanTransform
{
    NSString *string = @"scale(1, 2)";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    struct SKTransform transform;
    BOOL success = SKScanTransform(scanner, &transform);
    string = [string substringFromIndex:[scanner scanLocation]];
    STAssertEquals(success, YES, string);
}

- (void)testScanTransformArray
{
    NSString *string = @"scale(1, 2) rotate(4, 1, 3) translate(4, 5), \
                            matrix(1, 6 3 8 , 5, 5)";
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    NSArray *array;
    SKScanTransformArray(scanner, &array);
    STAssertEquals([array count], (NSUInteger)4, string);
}
*/
@end
