//
//  VCRTests.m
//  VCRTests
//
//  Created by Fletcher Fowler on 11/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "VCRTests.h"
#import "Request.h"
#import "SpecName.h"

@implementation VCRTests

- (void)setUp
{
    [super setUp];
    [SpecName sharedInstance].specName = [[self class] description];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:5];
//    NSLog([[NSString alloc] initWithData:[request response] encoding:NSUTF8StringEncoding]);
    STAssertNotNil([request response], @"response is nill");
}

- (void)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (TRUE);
}

@end
