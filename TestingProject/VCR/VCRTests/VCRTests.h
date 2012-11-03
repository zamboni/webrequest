//
//  VCRTests.h
//  VCRTests
//
//  Created by Fletcher Fowler on 11/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface VCRTests : SenTestCase
{
    BOOL done;
}

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs;

@end
