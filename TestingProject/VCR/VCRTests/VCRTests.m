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

- (void)testCreatesAFile
{
    [[NSFileManager defaultManager] removeItemAtPath:[SMWebRequest urlFilePath] error:nil];
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[SMWebRequest urlFilePath]], @"file not created");

    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];

    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[SMWebRequest urlFilePath]], @"file created");
}

- (void)testFileHasResponseJSON
{
    [[NSFileManager defaultManager] removeItemAtPath:[SMWebRequest urlFilePath] error:nil];
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[SMWebRequest urlFilePath]], @"file not created");
    
    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];
    
    NSData *data            = [NSData dataWithContentsOfFile:[SMWebRequest urlFilePath]];
    NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    STAssertNotNil([[response objectForKey:[[response allKeys] objectAtIndex:0]] objectForKey:@"response"], @"response is nil");
}

- (void)testFileHasCodeJSON
{
    [[NSFileManager defaultManager] removeItemAtPath:[SMWebRequest urlFilePath] error:nil];
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[SMWebRequest urlFilePath]], @"file not created");
    
    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];
    
    NSData *data            = [NSData dataWithContentsOfFile:[SMWebRequest urlFilePath]];
    NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    STAssertNotNil([[response objectForKey:[[response allKeys] objectAtIndex:0]] objectForKey:@"code"], @"response is nil");
}

- (void)testFileServesCode
{
    [[NSFileManager defaultManager] removeItemAtPath:[SMWebRequest urlFilePath] error:nil];
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[SMWebRequest urlFilePath]], @"file not created");
    
    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];
    
    [request callRequest];
    NSData *data            = [NSData dataWithContentsOfFile:[SMWebRequest urlFilePath]];
    NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    STAssertNotNil([[response objectForKey:[[response allKeys] objectAtIndex:0]] objectForKey:@"code"], @"code is nil");
    
}

- (void)testFileServesResponse
{
    [[NSFileManager defaultManager] removeItemAtPath:[SMWebRequest urlFilePath] error:nil];
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[SMWebRequest urlFilePath]], @"file not created");
    
    Request *request = [[Request alloc] init];
    [request callRequest];
    [self waitForCompletion:1];
    
    [request callRequest];
    NSData *data            = [NSData dataWithContentsOfFile:[SMWebRequest urlFilePath]];
    NSDictionary *response  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    STAssertNotNil([[response objectForKey:[[response allKeys] objectAtIndex:0]] objectForKey:@"response"], @"response is nil");

}

- (void)testXample
{
    Request *request = [[Request alloc] init];
    [request callRequest];
    
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
