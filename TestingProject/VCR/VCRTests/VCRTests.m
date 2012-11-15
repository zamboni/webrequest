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
#import "SMWebRequest+VCR.h"
#import "FileManager.h"

@implementation VCRTests

- (void)setUp
{
    [super setUp];
    [SpecName sharedInstance].specName = [[self class] description];
    [[NSFileManager defaultManager] removeItemAtPath:[FileManager urlFilePath] error:nil];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreatesAFile
{

    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];

}

- (void)testFileHasCodeAndResponseJSON
{
    [[NSFileManager defaultManager] removeItemAtPath:[FileManager urlFilePath] error:nil];
    
    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];
    
    NSData *data            = [NSData dataWithContentsOfFile:[FileManager urlFilePath]];
    NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *key           = [[response allKeys] objectAtIndex:0];
    
    STAssertNotNil([[response objectForKey:key] objectForKey:@"code"], @"response is nil");
    STAssertNotNil([[response objectForKey:key] objectForKey:@"data"], @"response is nil");
}

- (void)testFileServesCodeAndResponse
{
    [[NSFileManager defaultManager] removeItemAtPath:[FileManager urlFilePath] error:nil];
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[FileManager urlFilePath]], @"file not created");
    
    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];
    
    Request *request_new = [[Request alloc] init];
    [request_new callRequest];
    NSData *data            = [NSData dataWithContentsOfFile:[FileManager urlFilePath]];
    NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    STAssertNotNil([[response objectForKey:[[response allKeys] objectAtIndex:0]] objectForKey:@"code"], @"code is nil");
    STAssertNotNil([[response objectForKey:[[response allKeys] objectAtIndex:0]] objectForKey:@"data"], @"response is nil");
}

- (void)testExample
{
    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];

    STAssertNotNil([request response], @"null response");
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
